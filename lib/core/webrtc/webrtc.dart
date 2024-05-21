import 'dart:async';

import 'package:flutter/foundation.dart';

import 'package:injectable/injectable.dart';
import 'package:sdp_transform/sdp_transform.dart';

import 'package:waterbus_sdk/constants/webrtc_configurations.dart';
import 'package:waterbus_sdk/core/webrtc/webrtc_interface.dart';
import 'package:waterbus_sdk/core/websocket/interfaces/socket_emiter_interface.dart';
import 'package:waterbus_sdk/e2ee/frame_crypto.dart';
import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';
import 'package:waterbus_sdk/native/native_channel.dart';
import 'package:waterbus_sdk/native/replaykit.dart';
import 'package:waterbus_sdk/native/virtual_background/index.dart';
import 'package:waterbus_sdk/stats/webrtc_audio_stats.dart';
import 'package:waterbus_sdk/stats/webrtc_video_stats.dart';
import 'package:waterbus_sdk/utils/extensions/peer_extensions.dart';
import 'package:waterbus_sdk/utils/extensions/sdp_extensions.dart';
import 'package:waterbus_sdk/utils/logger/logger.dart';

@LazySingleton(as: WaterbusWebRTCManager)
class WaterbusWebRTCManagerIpml extends WaterbusWebRTCManager {
  final WebRTCFrameCrypto _frameCryptor;
  final SocketEmiter _socketEmiter;
  final ReplayKitChannel _replayKitChannel;
  final NativeService _nativeService;
  final WebRTCVideoStats _stats;
  final WebRTCAudioStats _audioStats;
  WaterbusWebRTCManagerIpml(
    this._frameCryptor,
    this._socketEmiter,
    this._replayKitChannel,
    this._nativeService,
    this._stats,
    this._audioStats,
  );

  String? _roomId;
  String? _participantId;
  MediaStream? _localStream;
  MediaStream? _displayStream;
  ParticipantSFU? _mParticipant;
  bool _flagPublisherCanAddCandidate = false;
  CallSetting _callSetting = CallSetting();
  final Map<String, ParticipantSFU> _subscribers = {};
  final Map<String, List<RTCIceCandidate>> _queueRemoteSubCandidates = {};
  final List<RTCIceCandidate> _queuePublisherCandidates = [];
  // ignore: close_sinks
  final StreamController<CallbackPayload> _notifyChanged =
      StreamController<CallbackPayload>.broadcast();

  @override
  Future<void> prepareMedia() async {
    await _prepareMedia();
  }

  @override
  Future<void> startScreenSharing({DesktopCapturerSource? source}) async {
    try {
      if (_mParticipant == null || _mParticipant!.isSharingScreen) return;

      if (WebRTC.platformIsAndroid) {
        await _nativeService.startForegroundService();
      }

      _displayStream = await _getDisplayMedia(source);

      if (_displayStream?.getVideoTracks().isEmpty ?? true) return;

      if (WebRTC.platformIsMobile && _mParticipant!.isVideoEnabled) {
        await toggleVideo(forceValue: false);
      }

      final screenTrack = _displayStream!.getVideoTracks().first;

      await _mParticipant!.peerConnection.createScreenSharingTrack(
        screenTrack,
        vCodec: _callSetting.preferedCodec,
        stream: _displayStream!,
      );

      await _mParticipant?.setScreenSrcObject(_displayStream!);

      _displayStream?.getVideoTracks().first.onEnded = () {
        stopScreenSharing();
      };

      _mParticipant?.isSharingScreen = true;

      _notify(CallbackEvents.shouldBeUpdateState);
      _socketEmiter.setScreenSharing(true);
    } catch (e) {
      stopScreenSharing();
    }
  }

  @override
  Future<void> stopScreenSharing({bool stayInRoom = true}) async {
    if (!(_mParticipant?.isSharingScreen ?? true)) return;

    _mParticipant?.isSharingScreen = false;

    if (_mParticipant == null) return;

    if (stayInRoom) {
      if (WebRTC.platformIsMobile &&
          (_localStream?.getVideoTracks().isNotEmpty ?? false)) {
        if (_mParticipant!.isVideoEnabled) {
          await toggleVideo(forceValue: true);
        }
      }

      final List<RTCRtpSender> senders =
          await _mParticipant!.peerConnection.getSenders();

      final RTCRtpSender? sendersVideo = senders
          .where((sender) => sender.track?.kind == 'video')
          .toList()
          .lastOrNull;

      if (sendersVideo != null) {
        _mParticipant!.peerConnection.removeTrack(sendersVideo);
      }
    }

    if (WebRTC.platformIsAndroid) {
      await _nativeService.stopForegroundService();
    }

    for (final MediaStreamTrack track in _displayStream?.getTracks() ?? []) {
      track.stop();
    }

    _mParticipant?.isSharingScreen = false;
    _displayStream?.dispose();
    _displayStream = null;

    if (stayInRoom) {
      _notify(CallbackEvents.shouldBeUpdateState);
      _socketEmiter.setScreenSharing(false);
    } else {
      _replayKitChannel.closeReplayKit();
    }
  }

  @override
  Future<void> joinRoom({
    required String roomId,
    required int participantId,
  }) async {
    await Future.wait([
      _frameCryptor.initialize(roomId, codec: _callSetting.preferedCodec),
      _prepareMedia(),
    ]);

    if (_mParticipant?.peerConnection == null) return;

    _roomId = roomId;
    _participantId = participantId.toString();

    final RTCPeerConnection peerConnection = _mParticipant!.peerConnection;

    peerConnection.onRenegotiationNeeded = () async {
      String sdp = await _createOffer(peerConnection);

      if (_localStream?.getVideoTracks().isNotEmpty ?? false) {
        sdp = sdp.enableAudioDTX().setPreferredCodec(
              codec: _callSetting.preferedCodec,
            );
      }

      final RTCSessionDescription description = RTCSessionDescription(
        sdp,
        DescriptionType.offer.type,
      );

      await peerConnection.setLocalDescription(description);

      _socketEmiter.sendNewSdp(sdp);
    };

    peerConnection.onIceCandidate = (candidate) {
      if (_flagPublisherCanAddCandidate) {
        _socketEmiter.sendBroadcastCandidate(candidate);
      } else {
        _queuePublisherCandidates.add(candidate);
      }
    };

    await _enableEncryption(_callSetting.e2eeEnabled);

    _localStream?.getTracks().forEach((track) {
      peerConnection.addTrack(track, _localStream!);
    });

    String sdp = await _createOffer(peerConnection);

    if (_localStream?.getVideoTracks().isNotEmpty ?? false) {
      sdp = sdp.enableAudioDTX().setPreferredCodec(
            codec: _callSetting.preferedCodec,
          );
    }

    final RTCSessionDescription description = RTCSessionDescription(
      sdp,
      DescriptionType.offer.type,
    );

    await peerConnection.setLocalDescription(description);

    _socketEmiter.establishBroadcast(
      sdp: sdp,
      roomId: _roomId!,
      participantId: participantId.toString(),
      participant: _mParticipant!,
    );

    _nativeService.startCallKit(roomId);
    _stats.initialize();
    _audioStats.initialize();
  }

  @override
  Future<void> subscribe(List<String> targetIds) async {
    for (final targetId in targetIds) {
      _makeConnectionReceive(targetId);
    }
  }

  @override
  Future<void> setPublisherRemoteSdp(String sdp) async {
    final RTCSessionDescription description = RTCSessionDescription(
      sdp,
      DescriptionType.answer.type,
    );

    await _mParticipant?.setRemoteDescription(description);

    for (final candidate in _queuePublisherCandidates) {
      _socketEmiter.sendBroadcastCandidate(candidate);
    }

    _queuePublisherCandidates.clear();
    _flagPublisherCanAddCandidate = true;
  }

  @override
  Future<void> setSubscriberRemoteSdp({
    required String targetId,
    required String sdp,
    required bool videoEnabled,
    required bool audioEnabled,
    required bool isScreenSharing,
    required bool isE2eeEnabled,
    required CameraType type,
    required WebRTCCodec codec,
  }) async {
    if (_subscribers[targetId] != null) return;

    final RTCSessionDescription description = RTCSessionDescription(
      sdp,
      DescriptionType.offer.type,
    );

    await _answerSubscriber(
      targetId,
      description,
      videoEnabled,
      audioEnabled,
      isScreenSharing,
      isE2eeEnabled,
      type,
      codec,
    );
  }

  @override
  Future<void> handleSubscriberRenegotiation({
    required String targetId,
    required String sdp,
  }) async {
    if (_subscribers[targetId]?.peerConnection == null) return;

    final RTCPeerConnection pc = _subscribers[targetId]!.peerConnection;

    final RTCSessionDescription remoteDescription = RTCSessionDescription(
      sdp,
      DescriptionType.offer.type,
    );

    await pc.setRemoteDescription(remoteDescription);

    try {
      final String ansSdp = await _createAnswer(pc);
      final RTCSessionDescription localDescription = RTCSessionDescription(
        ansSdp,
        DescriptionType.answer.type,
      );
      await pc.setLocalDescription(localDescription);

      _socketEmiter.answerEstablishSubscriber(targetId: targetId, sdp: ansSdp);
    } catch (_) {}
  }

  @override
  Future<void> addPublisherCandidate(RTCIceCandidate candidate) async {
    await _mParticipant?.addCandidate(candidate);
  }

  @override
  Future<void> addSubscriberCandidate(
    String targetId,
    RTCIceCandidate candidate,
  ) async {
    if (_subscribers[targetId] != null) {
      await _subscribers[targetId]?.addCandidate(candidate);
    } else {
      final List<RTCIceCandidate> candidates =
          _queueRemoteSubCandidates[targetId] ?? [];

      candidates.add(candidate);

      _queueRemoteSubCandidates[targetId] = candidates;
    }
  }

  @override
  Future<void> newParticipant(Participant participant) async {
    await _makeConnectionReceive(participant.id.toString());

    _notify(CallbackEvents.newParticipant, participant: participant);
  }

  @override
  Future<void> participantHasLeft(String targetId) async {
    _notify(
      CallbackEvents.participantHasLeft,
      participantId: targetId,
    );

    await _subscribers[targetId]?.dispose();
    _subscribers.remove(targetId);
    _queueRemoteSubCandidates.remove(targetId);
  }

  // MARK: Control Media
  @override
  Future<void> applyCallSettings(CallSetting setting) async {
    if (_callSetting.videoQuality == setting.videoQuality) {
      if (_callSetting.e2eeEnabled != setting.e2eeEnabled) {
        await _enableEncryption(setting.e2eeEnabled);
      }

      _callSetting = setting;

      return;
    }

    _callSetting = setting;

    if (_localStream == null || _mParticipant == null) return;

    final MediaStream? newStream = await _getUserMedia(onlyStream: true);

    await _replaceMediaStream(newStream);

    if (!(_mParticipant?.isVideoEnabled ?? true)) {
      await toggleVideo(forceValue: _mParticipant?.isVideoEnabled);
    }

    if (!(_mParticipant?.isAudioEnabled ?? true)) {
      await toggleAudio(forceValue: _mParticipant?.isAudioEnabled);
    }
  }

  @override
  Future<void> switchCamera() async {
    if (_localStream == null) throw Exception('Stream is not initialized');

    final List<MediaStreamTrack> videoTracks = _localStream!.getVideoTracks();

    if (videoTracks.isEmpty) return;

    await Helper.switchCamera(videoTracks.first);

    _mParticipant?.switchCamera();

    _socketEmiter.setCameraType(_mParticipant?.cameraType ?? CameraType.front);

    _notify(CallbackEvents.shouldBeUpdateState);
  }

  @override
  Future<void> toggleVideo({
    bool? forceValue,
    bool ignoreUpdateValue = false,
  }) async {
    if (_mParticipant == null ||
        (_mParticipant!.isSharingScreen && WebRTC.platformIsMobile)) {
      return;
    }

    final tracks = _localStream?.getVideoTracks() ?? [];

    for (final track in tracks) {
      track.enabled = forceValue ?? !_mParticipant!.isVideoEnabled;

      if (kIsWeb) {
        if (!track.enabled) {
          await track.stop();
        } else {
          await _localStream?.removeTrack(track);
        }
      }
    }

    if (kIsWeb && (forceValue ?? !_mParticipant!.isVideoEnabled)) {
      final MediaStream? localStream = await _getUserMedia(onlyStream: true);

      if (localStream != null) {
        await _localStream!.addTrack(localStream.getVideoTracks().first);
        await _replaceVideoTrack(localStream.getVideoTracks().first);

        _mParticipant?.setSrcObject(localStream);
      }
    }

    if (ignoreUpdateValue) return;

    _mParticipant!.isVideoEnabled =
        forceValue ?? !_mParticipant!.isVideoEnabled;

    _notify(CallbackEvents.shouldBeUpdateState);

    if (_roomId != null) {
      _socketEmiter.setVideoEnabled(
        forceValue ?? _mParticipant!.isVideoEnabled,
      );
    }
  }

  @override
  Future<void> toggleAudio({bool? forceValue}) async {
    if (_mParticipant == null) return;

    final tracks = _localStream?.getAudioTracks() ?? [];

    if (_mParticipant!.isAudioEnabled) {
      for (final track in tracks) {
        track.enabled = forceValue ?? false;
      }
    } else {
      for (final track in tracks) {
        track.enabled = forceValue ?? true;
      }
    }

    _mParticipant!.isAudioEnabled =
        forceValue ?? !_mParticipant!.isAudioEnabled;

    _notify(CallbackEvents.shouldBeUpdateState);

    if (_roomId != null) {
      _socketEmiter.setAudioEnabled(
        forceValue ?? _mParticipant!.isAudioEnabled,
      );
    }
  }

  @override
  Future<void> toggleSpeakerPhone({bool? forceValue}) async {
    if (_mParticipant == null) return;

    if (WebRTC.platformIsMobile) {
      Helper.setSpeakerphoneOn(
        forceValue ?? !_mParticipant!.isSpeakerPhoneEnabled,
      );
    }

    _mParticipant?.isSpeakerPhoneEnabled =
        forceValue ?? !_mParticipant!.isSpeakerPhoneEnabled;

    _notify(CallbackEvents.shouldBeUpdateState);
  }

  @override
  Future<void> setE2eeEnabled({
    required String targetId,
    required bool isEnabled,
    bool isForce = false,
  }) async {
    final RTCPeerConnection? peerConnection =
        _subscribers[targetId]?.peerConnection;

    if (peerConnection == null) return;

    if (_subscribers[targetId]?.isE2eeEnabled == isEnabled && !isForce) {
      return;
    }

    _subscribers[targetId]?.isE2eeEnabled = isEnabled;

    await _frameCryptor.enableDecryption(
      peerConnection: peerConnection,
      codec: _subscribers[targetId]?.videoCodec ?? WebRTCCodec.h264,
      enabled: isEnabled,
    );
  }

  @override
  void setVideoEnabled({required String targetId, required bool isEnabled}) {
    if (_subscribers[targetId]?.isVideoEnabled == isEnabled) return;

    _subscribers[targetId]?.isVideoEnabled = isEnabled;
    _notify(CallbackEvents.shouldBeUpdateState);
  }

  @override
  void setCameraType({required String targetId, required CameraType type}) {
    if (_subscribers[targetId]?.cameraType == type) return;

    _subscribers[targetId]?.cameraType = type;
    _notify(CallbackEvents.shouldBeUpdateState);
  }

  @override
  void setAudioEnabled({required String targetId, required bool isEnabled}) {
    if (_subscribers[targetId]?.isAudioEnabled == isEnabled) return;

    _subscribers[targetId]?.isAudioEnabled = isEnabled;
    _notify(CallbackEvents.shouldBeUpdateState);
  }

  @override
  void setScreenSharing({required String targetId, required bool isSharing}) {
    _subscribers[targetId]?.isSharingScreen = isSharing;
    _notify(CallbackEvents.shouldBeUpdateState);
  }

  @override
  Future<void> dispose() async {
    try {
      if (_mParticipant == null) return;

      if (_roomId != null) {
        _socketEmiter.leaveRoom(_roomId!);
        _roomId = null;
        _participantId = null;
      }

      _queuePublisherCandidates.clear();
      _queueRemoteSubCandidates.clear();
      _flagPublisherCanAddCandidate = false;
      _nativeService.endCallKit();
      _stats.dispose();
      _audioStats.dispose();

      for (final subscriber in _subscribers.values) {
        await subscriber.dispose();
      }
      _subscribers.clear();

      await stopScreenSharing(stayInRoom: false);

      for (final MediaStreamTrack track in _localStream?.getTracks() ?? []) {
        track.stop();
      }

      await _localStream?.dispose();
      await _mParticipant?.dispose();
      _mParticipant = null;
      _localStream = null;
      _frameCryptor.dispose();

      _notify(CallbackEvents.meetingEnded);

      // Clear for next time
      disableVirtualBackground(reset: true);
    } catch (error) {
      WaterbusLogger().bug(error.toString());
    }
  }

  // MARK: Public virtual background
  @override
  Future<void> enableVirtualBackground({
    required Uint8List backgroundImage,
    double thresholdConfidence = 0.7,
  }) async {
    final MediaStream? segmentedStream = await startVirtualBackground(
      backgroundImage: backgroundImage,
      textureId: _mParticipant?.renderer?.textureId.toString(),
    );

    if (segmentedStream == null) return;

    _replaceVideoTrack(segmentedStream.getVideoTracks().first);
  }

  @override
  Future<void> disableVirtualBackground({bool reset = false}) async {
    await stopVirtualBackground(reset: reset);
  }

  // MARK: Private methods
  Future<void> _prepareMedia() async {
    if (_mParticipant?.peerConnection != null) return;

    final RTCPeerConnection peerConnection = await _createPeerConnection(
      WebRTCConfigurations.offerPublisherSdpConstraints,
    );

    _mParticipant = ParticipantSFU(
      ownerId: kIsMine,
      peerConnection: peerConnection,
      onChanged: () => _notify(CallbackEvents.shouldBeUpdateState),
      videoCodec: _callSetting.preferedCodec,
      isE2eeEnabled: _callSetting.e2eeEnabled,
      stats: _stats,
      audioStats: _audioStats,
      isMe: true,
    );

    _localStream = await _getUserMedia();
    if (_localStream != null) {
      _mParticipant?.setSrcObject(_localStream!);
    }
  }

  Future<MediaStream?> _getUserMedia({bool onlyStream = false}) async {
    try {
      final MediaStream stream = await navigator.mediaDevices.getUserMedia(
        _callSetting.mediaConstraints,
      );
      // Microphone not granted or has been broken
      if (stream.getAudioTracks().isEmpty) {
        toggleAudio(forceValue: false);
      }

      // Camera not granted or has been broken
      if (stream.getVideoTracks().isEmpty) {
        toggleVideo(forceValue: false);
      }

      if (stream.getTracks().isEmpty) return null;

      if (onlyStream) return stream;

      if (WebRTC.platformIsMobile) {
        await toggleSpeakerPhone(forceValue: true);
      }

      if (_callSetting.isAudioMuted) {
        toggleAudio(forceValue: false);
      }

      if (_callSetting.isVideoMuted) {
        toggleVideo(forceValue: false);
      }

      return stream;
    } catch (error) {
      // Unable getUserMedia
      toggleAudio(forceValue: false);
      toggleVideo(forceValue: false);

      return null;
    }
  }

  Future<MediaStream> _getDisplayMedia(DesktopCapturerSource? source) async {
    late final Map<String, dynamic> mediaConstraints;
    if (kIsWeb) {
      mediaConstraints = {
        "video": true,
        "audio": false,
      };
    } else {
      mediaConstraints = <String, dynamic>{
        'audio': false,
        'video': {
          'deviceId': source?.id ?? 'broadcast',
          'frameRate': 15,
          'mandatory': {
            'minWidth': 1280,
            'minHeight': 720,
            'minFrameRate': 10,
          },
        },
      };
    }

    final MediaStream stream = await navigator.mediaDevices.getDisplayMedia(
      mediaConstraints,
    );

    return stream;
  }

  Future<RTCPeerConnection> _createPeerConnection([
    Map<String, dynamic> constraints = const {},
  ]) async {
    final RTCPeerConnection pc = await createPeerConnection(
      WebRTCConfigurations.configurationWebRTC,
      constraints,
    );

    pc.createDataChannel('waterbus', RTCDataChannelInit());

    return pc;
  }

  Future<String> _createOffer(RTCPeerConnection peerConnection) async {
    final RTCSessionDescription description =
        await peerConnection.createOffer();
    final session = parse(description.sdp.toString());
    final String sdp = write(session, null);

    return sdp;
  }

  Future<String> _createAnswer(RTCPeerConnection peerConnection) async {
    final RTCSessionDescription description =
        await peerConnection.createAnswer();
    final session = parse(description.sdp.toString());
    final String sdp = write(session, null);

    return sdp;
  }

  Future<void> _makeConnectionReceive(String targetId) async {
    if (_roomId == null || _participantId == null) return;

    _socketEmiter.requestEstablishSubscriber(
      roomId: _roomId!,
      participantId: _participantId!,
      targetId: targetId,
    );
  }

  Future<void> _answerSubscriber(
    String targetId,
    RTCSessionDescription remoteDescription,
    bool videoEnabled,
    bool audioEnabled,
    bool isScreenSharing,
    bool isE2eeEnabled,
    CameraType type,
    WebRTCCodec codec,
  ) async {
    final RTCPeerConnection rtcPeerConnection = await _createPeerConnection(
      WebRTCConfigurations.offerSubscriberSdpConstraints,
    );

    _subscribers[targetId] = ParticipantSFU(
      ownerId: targetId,
      peerConnection: rtcPeerConnection,
      onChanged: () => _notify(CallbackEvents.shouldBeUpdateState),
      isAudioEnabled: audioEnabled,
      isVideoEnabled: videoEnabled,
      isSharingScreen: isScreenSharing,
      isE2eeEnabled: isE2eeEnabled,
      cameraType: type,
      videoCodec: codec,
      stats: _stats,
      audioStats: _audioStats,
    );

    setE2eeEnabled(
      targetId: targetId,
      isEnabled: isE2eeEnabled,
      isForce: true,
    );

    rtcPeerConnection.onTrack = (track) {
      if (_subscribers[targetId] == null) return;

      if (track.streams.isEmpty) return;

      _subscribers[targetId]?.setSrcObject(track.streams.first);
    };

    rtcPeerConnection.onIceCandidate = (candidate) {
      _socketEmiter.sendReceiverCandidate(
        candidate: candidate,
        targetId: targetId,
      );
    };

    rtcPeerConnection.setRemoteDescription(remoteDescription);

    final String sdp = await _createAnswer(rtcPeerConnection);
    final RTCSessionDescription description = RTCSessionDescription(
      sdp,
      DescriptionType.answer.type,
    );
    await rtcPeerConnection.setLocalDescription(description);

    _socketEmiter.answerEstablishSubscriber(targetId: targetId, sdp: sdp);

    // Process queue candidates from server
    final List<RTCIceCandidate> candidates =
        _queueRemoteSubCandidates[targetId] ?? [];

    for (final candidate in candidates) {
      addSubscriberCandidate(targetId, candidate);
    }
  }

  Future<void> _replaceMediaStream(MediaStream? newStream) async {
    final List<RTCRtpSender> senders =
        await _mParticipant!.peerConnection.getSenders();

    final List<RTCRtpSender> sendersAudio =
        senders.where((sender) => sender.track?.kind == 'audio').toList();
    final List<RTCRtpSender> sendersVideo =
        senders.where((sender) => sender.track?.kind == 'video').toList();

    final MediaStreamTrack? audioTrack =
        newStream?.getAudioTracks().firstOrNull;
    final MediaStreamTrack? videoTrack =
        newStream?.getVideoTracks().firstOrNull;

    if (audioTrack != null) {
      for (final sender in sendersAudio) {
        sender.replaceTrack(audioTrack);
      }
    }

    if (videoTrack != null) {
      await _replaceVideoTrack(
        videoTrack,
        sendersList: sendersVideo,
      );
    }

    if (newStream != null) _mParticipant?.setSrcObject(newStream);
    _localStream = newStream;
  }

  Future<void> _replaceVideoTrack(
    MediaStreamTrack track, {
    List<RTCRtpSender>? sendersList,
  }) async {
    final List<RTCRtpSender> senders =
        (sendersList ?? await _mParticipant!.peerConnection.getSenders())
            .where(
              (sender) => sender.track?.kind == 'video',
            )
            .toList();

    if (senders.isEmpty) return;

    final sender = senders.first;

    sender.replaceTrack(track);

    await _enableEncryption(_callSetting.e2eeEnabled);
  }

  Future<void> _enableEncryption(bool enabled) async {
    final RTCPeerConnection? peerConnection = _mParticipant?.peerConnection;

    if (peerConnection == null) return;

    await _frameCryptor.enableEncryption(
      peerConnection: peerConnection,
      enabled: enabled,
    );

    _mParticipant?.isE2eeEnabled = enabled;
    _socketEmiter.setE2eeEnabled(enabled);
  }

  void _notify(
    CallbackEvents event, {
    String? participantId,
    Participant? participant,
  }) {
    _notifyChanged.sink.add(
      CallbackPayload(
        event: event,
        callState: callState(),
        newParticipant: participant,
        participantId: participantId,
      ),
    );
  }

  @override
  Stream<CallbackPayload> get notifyChanged => _notifyChanged.stream;

  @override
  CallState callState() {
    return CallState(
      mParticipant: _mParticipant,
      participants: _subscribers,
    );
  }
}
