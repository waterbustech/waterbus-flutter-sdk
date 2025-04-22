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
import 'package:waterbus_sdk/types/enums/rtc_track_kind.dart';
import 'package:waterbus_sdk/types/enums/track_type.dart';
import 'package:waterbus_sdk/types/models/audio_stats_params.dart';
import 'package:waterbus_sdk/utils/extensions/pc_extensions.dart';
import 'package:waterbus_sdk/utils/extensions/sdp_extensions.dart';
import 'package:waterbus_sdk/utils/logger/logger.dart';

@LazySingleton(as: WaterbusWebRTCManager)
class WaterbusWebRTCManagerIpml extends WaterbusWebRTCManager {
  final WebRTCFrameCrypto _frameCryptor;
  final SocketEmiter _wsEmiter;
  final ReplayKitChannel _replayKitChannel;
  final NativeService _nativeService;
  final WebRTCVideoStats _videoStats;
  final WebRTCAudioStats _audioStats;
  WaterbusWebRTCManagerIpml(
    this._frameCryptor,
    this._wsEmiter,
    this._replayKitChannel,
    this._nativeService,
    this._videoStats,
    this._audioStats,
  );

  String? _currentRoomId;
  String? _currentParticipantId;
  MediaStream? _localCameraStream;
  MediaStream? _screenSharingStream;
  ParticipantSFU? _mParticipant;
  bool _canPublisherAddIceCandidate = false;
  bool _isSessionBeingRecorded = false;
  CallSetting _currentCallSetting = CallSetting();
  final Map<String, ParticipantSFU> _remoteSubscribers = {};
  final Map<String, List<RTCIceCandidate>> _iceCandidateQueueForSubscribers =
      {};
  final List<RTCIceCandidate> _iceCandidateQueueForPublisher = [];
  final List<RTCIceCandidate> _remoteIceCandidatesForPublisher = [];
  // ignore: close_sinks
  final StreamController<CallbackPayload> _eventStreamController =
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

      _screenSharingStream = await _getDisplayMedia(source);

      if (_screenSharingStream?.getVideoTracks().isEmpty ?? true) return;

      if (WebRTC.platformIsMobile && _mParticipant!.isVideoEnabled) {
        await toggleVideo(forceValue: false);
      }

      final screenTrack = _screenSharingStream!.getVideoTracks().first;

      final sender = await _mParticipant!.peerConnection.addSimulcastTrack(
        screenTrack,
        vCodec: _currentCallSetting.preferedCodec,
        stream: _screenSharingStream!,
      );

      _videoStats.addSenders(
        ownerId: '$kIsMine-${TrackType.screen.toString()}',
        senders: [sender],
        callback: (stats) {
          _mParticipant?.sinkScreenStats(stats);
        },
      );

      await _mParticipant?.setSrcObject(
        _screenSharingStream!,
        isDisplayStream: true,
      );

      _screenSharingStream?.getVideoTracks().first.onEnded = () {
        stopScreenSharing();
      };

      _mParticipant?.setScreenSharing(true);

      _notify(CallbackEvents.shouldBeUpdateState);
      _wsEmiter.setScreenSharing(true);
    } catch (e) {
      stopScreenSharing();
    }
  }

  @override
  Future<void> stopScreenSharing({bool stayInRoom = true}) async {
    if (!(_mParticipant?.isSharingScreen ?? true)) return;

    if (_mParticipant == null) return;

    _videoStats.removeSenders('$kIsMine-${TrackType.screen.toString()}');

    if (stayInRoom) {
      if (WebRTC.platformIsMobile &&
          (_localCameraStream?.getVideoTracks().isNotEmpty ?? false)) {
        if (_mParticipant!.isVideoEnabled) {
          await toggleVideo(forceValue: true);
        }
      }

      final List<RTCRtpSender> senders =
          await _mParticipant!.peerConnection.getSenders();

      final RTCRtpSender? sendersVideo = senders
          .where((sender) => sender.track?.kind == RtcTrackKind.video.kind)
          .toList()
          .lastOrNull;

      if (sendersVideo != null) {
        await _mParticipant!.peerConnection.removeTrack(sendersVideo);
      }
    }

    if (WebRTC.platformIsAndroid) {
      await _nativeService.stopForegroundService();
    }

    final tracks = _screenSharingStream?.getTracks() ?? [];

    for (final track in tracks) {
      await track.stop();
    }

    _mParticipant?.setScreenSharing(false);
    _screenSharingStream?.dispose();
    _screenSharingStream = null;

    if (stayInRoom) {
      _notify(CallbackEvents.shouldBeUpdateState);
      _wsEmiter.setScreenSharing(false);
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
      _frameCryptor.initialize(
        roomId,
        codec: _currentCallSetting.preferedCodec,
      ),
      _prepareMedia(),
    ]);

    if (_mParticipant?.peerConnection == null) return;

    if (WebRTC.platformIsMobile) {
      if (WebRTC.platformIsIOS) {
        await Helper.setAppleAudioIOMode(
          AppleAudioIOMode.localAndRemote,
          preferSpeakerOutput: true,
        );
      }
      await toggleSpeakerPhone(forceValue: true);
    }

    _currentRoomId = roomId;
    _currentParticipantId = participantId.toString();

    await _establishBroadcastConnection();

    _nativeService.startCallKit(roomId.roomCodeFormatted);
  }

  @override
  Future<void> reconnect() async {
    if (_mParticipant == null) return;

    _videoStats.dispose();
    _audioStats.dispose();
    await _mParticipant?.peerConnection.close();

    final RTCPeerConnection peerConnection = await _createPeerConnection(
      WebRTCConfigurations.offerPublisherSdpConstraints,
    );

    _mParticipant = _mParticipant?.copyWith(peerConnection: peerConnection);

    await _establishBroadcastConnection();
  }

  @override
  Future<void> subscribe(List<String> targetIds) async {
    for (final targetId in targetIds) {
      _makeConnectionReceive(targetId);
    }
  }

  @override
  Future<void> setPublisherRemoteSdp(String sdp, [bool? isRecording]) async {
    if (isRecording != null) _isSessionBeingRecorded = isRecording;

    final RTCSessionDescription description = RTCSessionDescription(
      sdp,
      DescriptionType.answer.type,
    );

    await _mParticipant?.setRemoteDescription(description);

    for (final candidate in _iceCandidateQueueForPublisher) {
      _wsEmiter.sendBroadcastCandidate(candidate);
    }

    for (final candidate in _remoteIceCandidatesForPublisher) {
      await _mParticipant?.addCandidate(candidate);
    }

    _iceCandidateQueueForPublisher.clear();
    _remoteIceCandidatesForPublisher.clear();
    _canPublisherAddIceCandidate = true;
  }

  @override
  Future<void> setSubscriberRemoteSdp({
    required String targetId,
    required String sdp,
    required bool videoEnabled,
    required bool audioEnabled,
    required bool isScreenSharing,
    required bool isE2eeEnabled,
    required bool isHandRaising,
    required CameraType type,
    required WebRTCCodec codec,
  }) async {
    if (_remoteSubscribers[targetId] != null) return;

    final RTCSessionDescription description = RTCSessionDescription(
      sdp,
      DescriptionType.offer.type,
    );

    await _answerSubscriber(
      targetId: targetId,
      remoteDescription: description,
      videoEnabled: videoEnabled,
      audioEnabled: audioEnabled,
      isScreenSharing: isScreenSharing,
      isE2eeEnabled: isE2eeEnabled,
      isHandRaising: isHandRaising,
      type: type,
      codec: codec,
    );
  }

  @override
  Future<void> handleSubscriberRenegotiation({
    required String targetId,
    required String sdp,
  }) async {
    if (_remoteSubscribers[targetId]?.peerConnection == null) return;

    final RTCPeerConnection pc = _remoteSubscribers[targetId]!.peerConnection;

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

      _wsEmiter.answerEstablishSubscriber(targetId: targetId, sdp: ansSdp);
    } catch (_) {}
  }

  @override
  Future<void> addPublisherCandidate(RTCIceCandidate candidate) async {
    if (_canPublisherAddIceCandidate) {
      await _mParticipant?.addCandidate(candidate);
    } else {
      _remoteIceCandidatesForPublisher.add(candidate);
    }
  }

  @override
  Future<void> addSubscriberCandidate(
    String targetId,
    RTCIceCandidate candidate,
  ) async {
    if (_remoteSubscribers[targetId] != null) {
      await _remoteSubscribers[targetId]?.addCandidate(candidate);
    } else {
      final List<RTCIceCandidate> candidates =
          _iceCandidateQueueForSubscribers[targetId] ?? [];

      candidates.add(candidate);

      _iceCandidateQueueForSubscribers[targetId] = candidates;
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

    await _remoteSubscribers[targetId]?.dispose();
    _remoteSubscribers.remove(targetId);
    _iceCandidateQueueForSubscribers.remove(targetId);
    _audioStats.removeReceiver(targetId);
    _videoStats.removeReceivers(targetId);
  }

  // MARK: Control Media
  @override
  Future<void> applyCallSettings(CallSetting setting) async {
    if (_currentCallSetting.videoQuality == setting.videoQuality) {
      if (_currentCallSetting.e2eeEnabled != setting.e2eeEnabled) {
        await _enableEncryption(setting.e2eeEnabled);
      }

      _currentCallSetting = setting;

      return;
    }

    _currentCallSetting = setting;

    if (_localCameraStream == null || _mParticipant == null) return;

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
    if (_localCameraStream == null) {
      throw Exception('Stream is not initialized');
    }

    final List<MediaStreamTrack> videoTracks =
        _localCameraStream!.getVideoTracks();

    if (videoTracks.isEmpty) return;

    await Helper.switchCamera(videoTracks.first);

    _mParticipant?.switchCamera();

    _wsEmiter.setCameraType(_mParticipant?.cameraType ?? CameraType.front);

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

    final tracks = _localCameraStream?.getVideoTracks() ?? [];

    for (final track in tracks) {
      track.enabled = forceValue ?? !_mParticipant!.isVideoEnabled;

      if (kIsWeb) {
        if (!track.enabled) {
          await track.stop();
        } else {
          await _localCameraStream?.removeTrack(track);
        }
      }
    }

    if (kIsWeb && (forceValue ?? !_mParticipant!.isVideoEnabled)) {
      final MediaStream? localStream = await _getUserMedia(onlyStream: true);

      if (localStream != null) {
        await _localCameraStream!.addTrack(localStream.getVideoTracks().first);
        await _replaceVideoTrack(localStream.getVideoTracks().first);

        _mParticipant?.setSrcObject(localStream);
      }
    }

    if (ignoreUpdateValue) return;

    _mParticipant!.isVideoEnabled =
        forceValue ?? !_mParticipant!.isVideoEnabled;

    _notify(CallbackEvents.shouldBeUpdateState);

    if (_currentRoomId != null) {
      _wsEmiter.setVideoEnabled(
        forceValue ?? _mParticipant!.isVideoEnabled,
      );
    }
  }

  @override
  Future<void> toggleAudio({bool? forceValue}) async {
    if (_mParticipant == null) return;

    final tracks = _localCameraStream?.getAudioTracks() ?? [];

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

    if (_currentRoomId != null) {
      _wsEmiter.setAudioEnabled(
        forceValue ?? _mParticipant!.isAudioEnabled,
      );
    }
  }

  @override
  Future<void> toggleSpeakerPhone({bool? forceValue}) async {
    if (_mParticipant == null) return;

    _mParticipant?.isSpeakerPhoneEnabled =
        forceValue ?? !_mParticipant!.isSpeakerPhoneEnabled;

    if (WebRTC.platformIsMobile) {
      await Helper.setSpeakerphoneOn(_mParticipant!.isSpeakerPhoneEnabled);

      if (_mParticipant?.isSpeakerPhoneEnabled ?? false) {
        await Helper.setSpeakerphoneOnButPreferBluetooth();
      }
    }

    _notify(CallbackEvents.shouldBeUpdateState);
  }

  @override
  void toggleRaiseHand() {
    if (_mParticipant == null) return;

    _mParticipant!.isHandRaising = !_mParticipant!.isHandRaising;

    _notify(CallbackEvents.shouldBeUpdateState);

    _wsEmiter.setHandRaising(_mParticipant!.isHandRaising);
  }

  @override
  Future<void> setE2eeEnabled({
    required RTCRtpReceiver receiver,
    required String targetId,
    required bool isEnabled,
  }) async {
    _remoteSubscribers[targetId]?.isE2eeEnabled = isEnabled;

    await _frameCryptor.enableDecryption(
      receiver: receiver,
      codec: _remoteSubscribers[targetId]?.videoCodec ?? WebRTCCodec.h264,
      enabled: isEnabled,
    );
  }

  @override
  void setVideoEnabled({required String targetId, required bool isEnabled}) {
    if (_remoteSubscribers[targetId]?.isVideoEnabled == isEnabled) return;

    _remoteSubscribers[targetId]?.isVideoEnabled = isEnabled;
    _notify(CallbackEvents.shouldBeUpdateState);
  }

  @override
  void setCameraType({required String targetId, required CameraType type}) {
    if (_remoteSubscribers[targetId]?.cameraType == type) return;

    _remoteSubscribers[targetId]?.cameraType = type;
    _notify(CallbackEvents.shouldBeUpdateState);
  }

  @override
  void setAudioEnabled({required String targetId, required bool isEnabled}) {
    if (_remoteSubscribers[targetId]?.isAudioEnabled == isEnabled) return;

    _remoteSubscribers[targetId]?.isAudioEnabled = isEnabled;
    _notify(CallbackEvents.shouldBeUpdateState);
  }

  @override
  void setScreenSharing({required String targetId, required bool isSharing}) {
    _remoteSubscribers[targetId]?.setScreenSharing(isSharing);
    _notify(CallbackEvents.shouldBeUpdateState);
  }

  @override
  void setHandRaising({required String targetId, required bool isRaising}) {
    if (_remoteSubscribers[targetId]?.isHandRaising == isRaising) return;

    _remoteSubscribers[targetId]?.isHandRaising = isRaising;

    _notify(CallbackEvents.raiseHand);
  }

  @override
  void setIsRecording({required bool isRecording}) {
    _isSessionBeingRecorded = isRecording;
    _notify(CallbackEvents.shouldBeUpdateState);
  }

  @override
  Future<void> dispose() async {
    try {
      if (_mParticipant == null) return;

      if (_currentRoomId != null) {
        _wsEmiter.leaveRoom(_currentRoomId!);
      }

      _currentRoomId = null;
      _currentParticipantId = null;
      _iceCandidateQueueForPublisher.clear();
      _remoteIceCandidatesForPublisher.clear();
      _iceCandidateQueueForSubscribers.clear();
      _canPublisherAddIceCandidate = false;
      _nativeService.endCallKit();
      _videoStats.dispose();
      _audioStats.dispose();

      for (final subscriber in _remoteSubscribers.values) {
        await subscriber.dispose();
      }
      _remoteSubscribers.clear();

      await stopScreenSharing(stayInRoom: false);

      final tracks = _localCameraStream?.getTracks() ?? [];

      for (final track in tracks) {
        track.stop();
      }

      await _localCameraStream?.dispose();
      await _mParticipant?.dispose();
      _mParticipant = null;
      _localCameraStream = null;
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
      textureId: _mParticipant?.cameraSource?.textureId.toString(),
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
      onFirstFrameRendered: () => _notify(CallbackEvents.shouldBeUpdateState),
      videoCodec: _currentCallSetting.preferedCodec,
      isE2eeEnabled: _currentCallSetting.e2eeEnabled,
    );

    _localCameraStream = await _getUserMedia();
    if (_localCameraStream != null) {
      _mParticipant?.setSrcObject(_localCameraStream!);
    }
  }

  Future<MediaStream?> _getUserMedia({bool onlyStream = false}) async {
    try {
      final MediaStream stream = await navigator.mediaDevices.getUserMedia(
        _currentCallSetting.mediaConstraints,
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

      if (_currentCallSetting.isAudioMuted) {
        toggleAudio(forceValue: false);
      }

      if (_currentCallSetting.isVideoMuted) {
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
    } else if (WebRTC.platformIsLinux) {
      mediaConstraints = {
        'video': {
          'deviceId': {'exact': source?.id},
          'mandatory': {'frameRate': 30.0},
        },
      };
    } else {
      mediaConstraints = <String, dynamic>{
        'audio': false,
        'video': {
          'deviceId': source?.id ?? 'broadcast',
          'frameRate': 30,
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

  Future<void> _establishBroadcastConnection() async {
    final RTCPeerConnection peerConnection = _mParticipant!.peerConnection;

    peerConnection.onRenegotiationNeeded = () async {
      String sdp = await _createOffer(peerConnection);

      if (_localCameraStream?.getVideoTracks().isNotEmpty ?? false) {
        sdp = sdp.optimizeSdp(
          codec: _currentCallSetting.preferedCodec,
        );
      }

      final RTCSessionDescription description = RTCSessionDescription(
        sdp,
        DescriptionType.offer.type,
      );

      await peerConnection.setLocalDescription(description);

      _wsEmiter.sendNewSdp(sdp);
    };

    peerConnection.onIceCandidate = (candidate) {
      if (_canPublisherAddIceCandidate) {
        _wsEmiter.sendBroadcastCandidate(candidate);
      } else {
        _iceCandidateQueueForPublisher.add(candidate);
      }
    };

    final List<MediaStreamTrack> tracks = _localCameraStream?.getTracks() ?? [];
    final List<RTCRtpSender> senders = [];

    for (final track in tracks) {
      final sender = await peerConnection.addSimulcastTrack(
        track,
        vCodec: _currentCallSetting.preferedCodec,
        stream: _localCameraStream!,
        kind: track.kind == RtcTrackKind.video.kind
            ? RtcTrackKind.video
            : RtcTrackKind.audio,
      );

      senders.add(sender);

      if (track.kind == RtcTrackKind.audio.kind) {
        _audioStats.setSender = AudioStatsParams(
          ownerId: kIsMine,
          pc: peerConnection,
          callBack: (audioLevel) {
            _mParticipant?.sinkAudioLevel(audioLevel);
          },
        );
      } else {
        _videoStats.addSenders(
          ownerId: '$kIsMine-${TrackType.webcam.toString()}',
          senders: [sender],
          callback: (stats) {
            _mParticipant?.sinkWebcamStats(stats);
          },
        );
      }
    }

    await _enableEncryption(
      _currentCallSetting.e2eeEnabled,
      skipEmitToServer: true,
      senders: senders,
    );

    String sdp = await _createOffer(peerConnection);

    if (_localCameraStream?.getVideoTracks().isNotEmpty ?? false) {
      sdp = sdp.optimizeSdp(
        codec: _currentCallSetting.preferedCodec,
      );
    }

    final RTCSessionDescription description = RTCSessionDescription(
      sdp,
      DescriptionType.offer.type,
    );

    await peerConnection.setLocalDescription(description);

    _wsEmiter.establishBroadcast(
      sdp: sdp,
      roomId: _currentRoomId!,
      participantId: _currentParticipantId!,
      participant: _mParticipant!,
    );

    if (WebRTC.platformIsLinux) return;

    _videoStats.initialize();
    _audioStats.initialize();
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
    if (_currentRoomId == null || _currentParticipantId == null) return;

    _wsEmiter.requestEstablishSubscriber(
      roomId: _currentRoomId!,
      participantId: _currentParticipantId!,
      targetId: targetId,
    );
  }

  Future<void> _answerSubscriber({
    required String targetId,
    required RTCSessionDescription remoteDescription,
    required bool videoEnabled,
    required bool audioEnabled,
    required bool isScreenSharing,
    required bool isHandRaising,
    required bool isE2eeEnabled,
    required CameraType type,
    required WebRTCCodec codec,
  }) async {
    final RTCPeerConnection rtcPeerConnection = await _createPeerConnection(
      WebRTCConfigurations.offerSubscriberSdpConstraints,
    );

    rtcPeerConnection.addTransceiver(
      kind: RTCRtpMediaType.RTCRtpMediaTypeVideo,
      init: RTCRtpTransceiverInit(
        direction: TransceiverDirection.RecvOnly,
      ),
    );
    rtcPeerConnection.addTransceiver(
      kind: RTCRtpMediaType.RTCRtpMediaTypeAudio,
      init: RTCRtpTransceiverInit(
        direction: TransceiverDirection.RecvOnly,
      ),
    );

    _remoteSubscribers[targetId] = ParticipantSFU(
      ownerId: targetId,
      peerConnection: rtcPeerConnection,
      onFirstFrameRendered: () => _notify(CallbackEvents.shouldBeUpdateState),
      isAudioEnabled: audioEnabled,
      isVideoEnabled: videoEnabled,
      isSharingScreen: isScreenSharing,
      isE2eeEnabled: isE2eeEnabled,
      isHandRaising: isHandRaising,
      cameraType: type,
      videoCodec: codec,
    );

    rtcPeerConnection.onTrack = (track) {
      if (_remoteSubscribers[targetId] == null) return;

      if (track.streams.isEmpty) return;

      Future.microtask(() async {
        if (track.receiver == null) return;

        await setE2eeEnabled(
          receiver: track.receiver!,
          targetId: targetId,
          isEnabled: isE2eeEnabled,
        );

        final TrackType? type = await _remoteSubscribers[targetId]
            ?.setSrcObject(track.streams.first);

        if (type == null) return;

        if (track.track.kind == RtcTrackKind.video.kind) {
          _videoStats.addReceivers(
            ownerId:
                targetId + DateTime.now().microsecondsSinceEpoch.toString(),
            receivers: [track.receiver!],
            callback: (stats) {
              if (type == TrackType.screen) {
                _remoteSubscribers[targetId]?.sinkWebcamStats(stats);
              } else {
                _remoteSubscribers[targetId]?.sinkScreenStats(stats);
              }
            },
          );
        } else if (track.track.kind == RtcTrackKind.audio.kind) {
          _audioStats.addReceiver(
            ownerId: targetId,
            receiver: track.receiver!,
            callback: (audioLevel) {
              _remoteSubscribers[targetId]?.sinkAudioLevel(audioLevel);
            },
          );
        }

        _notify(CallbackEvents.shouldBeUpdateState);
      });
    };

    rtcPeerConnection.onIceCandidate = (candidate) {
      _wsEmiter.sendReceiverCandidate(
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

    _wsEmiter.answerEstablishSubscriber(targetId: targetId, sdp: sdp);

    // Process queue candidates from server
    final List<RTCIceCandidate> candidates =
        _iceCandidateQueueForSubscribers[targetId] ?? [];

    for (final candidate in candidates) {
      addSubscriberCandidate(targetId, candidate);
    }
  }

  Future<void> _replaceMediaStream(MediaStream? newStream) async {
    final List<RTCRtpSender> senders =
        await _mParticipant!.peerConnection.getSenders();

    final List<RTCRtpSender> sendersAudio = senders
        .where((sender) => sender.track?.kind == RtcTrackKind.audio.kind)
        .toList();
    final List<RTCRtpSender> sendersVideo = senders
        .where((sender) => sender.track?.kind == RtcTrackKind.video.kind)
        .toList();

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
    _localCameraStream = newStream;
  }

  Future<void> _replaceVideoTrack(
    MediaStreamTrack track, {
    List<RTCRtpSender>? sendersList,
  }) async {
    final List<RTCRtpSender> senders =
        (sendersList ?? await _mParticipant!.peerConnection.getSenders())
            .where(
              (sender) => sender.track?.kind == RtcTrackKind.video.kind,
            )
            .toList();

    if (senders.isEmpty) return;

    final sender = senders.first;

    sender.replaceTrack(track);

    await _enableEncryption(
      _currentCallSetting.e2eeEnabled,
      senders: [sender],
    );
  }

  Future<void> _enableEncryption(
    bool enabled, {
    bool skipEmitToServer = false,
    List<RTCRtpSender> senders = const [],
  }) async {
    final RTCPeerConnection? peerConnection = _mParticipant?.peerConnection;

    if (peerConnection == null) return;

    final List<Future> futureTasks = [];

    for (final sender in senders) {
      futureTasks.add(
        _frameCryptor.enableEncryption(
          sender: sender,
          enabled: enabled,
        ),
      );
    }

    await Future.wait(futureTasks);

    _mParticipant?.isE2eeEnabled = enabled;

    if (skipEmitToServer) return;

    _wsEmiter.setE2eeEnabled(enabled);
  }

  void _notify(
    CallbackEvents event, {
    String? participantId,
    Participant? participant,
  }) {
    _eventStreamController.sink.add(
      CallbackPayload(
        event: event,
        callState: callState(),
        newParticipant: participant,
        participantId: participantId,
      ),
    );
  }

  @override
  Stream<CallbackPayload> get notifyChanged => _eventStreamController.stream;

  @override
  CallState callState() {
    return CallState(
      mParticipant: _mParticipant,
      participants: _remoteSubscribers,
    );
  }

  @override
  String? get roomId => _currentRoomId;

  @override
  bool get isRecording => _isSessionBeingRecorded;
}
