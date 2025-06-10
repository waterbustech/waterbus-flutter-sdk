import 'dart:async';

import 'package:flutter/foundation.dart';

import 'package:injectable/injectable.dart';
import 'package:sdp_transform/sdp_transform.dart';

import 'package:waterbus_sdk/constants/rtc_configurations.dart';
import 'package:waterbus_sdk/core/webrtc/webrtc_manager.dart';
import 'package:waterbus_sdk/core/websocket/interfaces/ws_emitter.dart';
import 'package:waterbus_sdk/e2ee/e2ee_manager.dart';
import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';
import 'package:waterbus_sdk/native/native_channel.dart';
import 'package:waterbus_sdk/native/replaykit.dart';
import 'package:waterbus_sdk/native/virtual_background/index.dart';
import 'package:waterbus_sdk/stats/webrtc_audio_stats.dart';
import 'package:waterbus_sdk/stats/webrtc_video_stats.dart';
import 'package:waterbus_sdk/utils/extensions/pc_extension.dart';
import 'package:waterbus_sdk/utils/extensions/sdp_extension.dart';
import 'package:waterbus_sdk/utils/extensions/string_extension.dart';
import 'package:waterbus_sdk/utils/logger/logger.dart';

@LazySingleton(as: WebRTCManager)
class WebRTCManagerIpml extends WebRTCManager {
  final E2EEManager _e2eeManager;
  final WsEmitter _wsEmitter;
  final ReplayKitChannel _replayKitChannel;
  final NativeService _nativeService;
  final WebRTCVideoStats _videoStats;
  final WebRTCAudioStats _audioStats;
  WebRTCManagerIpml(
    this._e2eeManager,
    this._wsEmitter,
    this._replayKitChannel,
    this._nativeService,
    this._videoStats,
    this._audioStats,
  );

  String? _currentRoomId;
  String? _currentParticipantId;
  MediaStream? _localCameraStream;
  MediaStream? _screenSharingStream;
  ParticipantMediaState? _mParticipant;
  bool _canPublisherAddIceCandidate = false;
  bool _isSessionBeingRecorded = false;
  MediaConfig _currentCallSetting = MediaConfig();
  final Map<String, ParticipantMediaState> _remoteSubscribers = {};
  final Map<String, List<RTCIceCandidate>> _iceCandidateQueueForSubscribers =
      {};
  final List<RTCIceCandidate> _iceCandidateQueueForPublisher = [];
  final List<RTCIceCandidate> _remoteIceCandidatesForPublisher = [];
  // ignore: close_sinks
  final StreamController<CallbackPayload> _eventStreamController =
      StreamController<CallbackPayload>.broadcast();

  // ====== Room Management ======
  @override
  Future<void> joinRoom({
    required String roomId,
    required int participantId,
  }) async {
    await Future.wait([
      _e2eeManager.initialize(
        roomId,
        codec: _currentCallSetting.videoConfig.preferedCodec,
        participantId: participantId.toString(),
        enabled: _currentCallSetting.e2eeEnabled,
      ),
      initializeMediaDevices(),
    ]);

    if (_mParticipant?.peerConnection == null) return;

    if (WebRTC.platformIsMobile) {
      if (WebRTC.platformIsIOS) {
        await Helper.setAppleAudioIOMode(
          AppleAudioIOMode.localAndRemote,
          preferSpeakerOutput: true,
        );
      }
      await toggleSpeakerOutput(forceValue: true);
    }

    _currentRoomId = roomId;
    _currentParticipantId = participantId.toString();

    await _establishBroadcastConnection();

    _nativeService.startCallKit(roomId.roomCodeFormatted);
  }

  @override
  Future<void> reconnectRoom() async {
    if (_mParticipant == null) return;

    _videoStats.dispose();
    _audioStats.dispose();
    await _mParticipant?.peerConnection.close();

    final RTCPeerConnection peerConnection = await _createPeerConnection(
      constraints: RTCConfigurations.offerPublisherSdpConstraints,
    );

    _mParticipant = _mParticipant?.copyWith(peerConnection: peerConnection);

    await _establishBroadcastConnection();
  }

  @override
  Future<void> subscribeToParticipants(List<String> targetIds) async {
    for (final targetId in targetIds) {
      _establishSubscriberConnection(targetId);
    }
  }

  @override
  Future<void> leaveRoom() async {
    try {
      if (_mParticipant == null) return;

      if (_currentRoomId != null) {
        _wsEmitter.leaveRoom(_currentRoomId!);
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

      await stopScreenShare(stayInRoom: false);

      final tracks = _localCameraStream?.getTracks() ?? [];

      for (final track in tracks) {
        track.stop();
      }

      await _localCameraStream?.dispose();
      await _mParticipant?.dispose();
      _mParticipant = null;
      _localCameraStream = null;
      _e2eeManager.dispose();

      _notify(CallbackEvents.roomEnded);

      // Clear for next time
      disableVirtualBg(reset: true);
    } catch (error) {
      WaterbusLogger().bug(error.toString());
    }
  }

  // ====== Signaling / SDP / ICE ======
  @override
  Future<void> setLocalSdpAsPublisher(String sdp, [bool? isRecording]) async {
    if (isRecording != null) _isSessionBeingRecorded = isRecording;

    final RTCSessionDescription description = RTCSessionDescription(
      sdp,
      DescriptionType.answer.type,
    );

    await _mParticipant?.setRemoteDescription(description);

    for (final candidate in _iceCandidateQueueForPublisher) {
      _wsEmitter.sendPublisherIceCandidate(candidate);
    }

    for (final candidate in _remoteIceCandidatesForPublisher) {
      await _mParticipant?.addCandidate(candidate);
    }

    _iceCandidateQueueForPublisher.clear();
    _remoteIceCandidatesForPublisher.clear();
    _canPublisherAddIceCandidate = true;
  }

  @override
  Future<void> setRemoteSdpAsSubscriber(
    SubscribeResponsePayload payload,
  ) async {
    if (_remoteSubscribers[payload.targetId] != null) return;

    final RTCSessionDescription description = RTCSessionDescription(
      payload.sdp,
      DescriptionType.offer.type,
    );

    await _answerSubscriber(remoteDescription: description, payload: payload);
  }

  @override
  Future<void> renegotiateWithParticipant({
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
      final String ansSdp = await _createAnswerSdp(pc);
      final RTCSessionDescription localDescription = RTCSessionDescription(
        ansSdp,
        DescriptionType.answer.type,
      );
      await pc.setLocalDescription(localDescription);

      _wsEmitter.answerSubscription(targetId: targetId, sdp: ansSdp);
    } catch (_) {}
  }

  @override
  Future<void> addIceCandidateToPublisher(RTCIceCandidate candidate) async {
    if (_canPublisherAddIceCandidate) {
      await _mParticipant?.addCandidate(candidate);
    } else {
      _remoteIceCandidatesForPublisher.add(candidate);
    }
  }

  @override
  Future<void> addIceCandidateToSubscriber(
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

  // ====== Participant Handling ======
  @override
  Future<void> handleParticipantJoined(Participant participant) async {
    await _establishSubscriberConnection(participant.id.toString());

    _notify(CallbackEvents.newParticipant, participant: participant);
  }

  @override
  Future<void> handleParticipantLeft(String targetId) async {
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

  // ====== Media & Device Control ======
  @override
  Future<void> initializeMediaDevices() async {
    if (_mParticipant?.peerConnection != null) return;

    final RTCPeerConnection peerConnection = await _createPeerConnection(
      constraints: RTCConfigurations.offerPublisherSdpConstraints,
    );

    _mParticipant = ParticipantMediaState.init(
      ownerId: kIsMine,
      peerConnection: peerConnection,
      onFirstFrameRendered: () => _notify(CallbackEvents.shouldBeUpdateState),
      videoCodec: _currentCallSetting.videoConfig.preferedCodec,
      isE2eeEnabled: _currentCallSetting.e2eeEnabled,
    );

    _localCameraStream = await _getUserMedia();
    if (_localCameraStream != null) {
      _mParticipant?.setSrcObject(_localCameraStream!);
    }
  }

  @override
  Future<void> applyMediaSettings(MediaConfig setting) async {
    if (_currentCallSetting.videoConfig.videoQuality ==
        setting.videoConfig.videoQuality) {
      if (_currentCallSetting.e2eeEnabled != setting.e2eeEnabled) {
        await _applyEncryption(setting.e2eeEnabled);
      }

      _currentCallSetting = setting;

      return;
    }

    _currentCallSetting = setting;

    if (_localCameraStream == null || _mParticipant == null) return;

    final MediaStream? newStream = await _getUserMedia(onlyStream: true);

    await _replaceMediaStream(newStream);

    if (!(_mParticipant?.isVideoEnabled ?? true)) {
      await toggleVideoInput(forceValue: _mParticipant?.isVideoEnabled);
    }

    if (!(_mParticipant?.isAudioEnabled ?? true)) {
      await toggleAudioInput(forceValue: _mParticipant?.isAudioEnabled);
    }
  }

  @override
  Future<void> toggleAudioInput({bool? forceValue}) async {
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

    _mParticipant = _mParticipant?.copyWith(
      isAudioEnabled: forceValue ?? !_mParticipant!.isAudioEnabled,
    );

    _notify(CallbackEvents.shouldBeUpdateState);

    if (_currentRoomId != null) {
      _wsEmitter.toggleAudio(
        forceValue ?? _mParticipant!.isAudioEnabled,
      );
    }
  }

  @override
  Future<void> toggleVideoInput({
    bool? forceValue,
    bool ignoreUpdateValue = false,
  }) async {
    if (_mParticipant == null) return;

    if (_mParticipant!.isSharingScreen && WebRTC.platformIsMobile) return;

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

    _mParticipant = _mParticipant?.copyWith(
      isVideoEnabled: forceValue ?? !_mParticipant!.isVideoEnabled,
    );

    _notify(CallbackEvents.shouldBeUpdateState);

    if (_currentRoomId != null) {
      _wsEmitter.toggleVideo(
        forceValue ?? _mParticipant!.isVideoEnabled,
      );
    }
  }

  @override
  Future<void> toggleSpeakerOutput({bool? forceValue}) async {
    if (_mParticipant == null) return;

    _mParticipant = _mParticipant?.copyWith(
      isSpeakerPhoneEnabled:
          forceValue ?? !_mParticipant!.isSpeakerPhoneEnabled,
    );

    if (WebRTC.platformIsMobile) {
      await Helper.setSpeakerphoneOn(_mParticipant!.isSpeakerPhoneEnabled);

      if (_mParticipant?.isSpeakerPhoneEnabled ?? false) {
        await Helper.setSpeakerphoneOnButPreferBluetooth();
      }
    }

    _notify(CallbackEvents.shouldBeUpdateState);
  }

  @override
  Future<void> toggleAudioInputDevice({required String deviceId}) async {
    if (_mParticipant == null) return;

    final List<MediaStreamTrack> oldAudioTracks =
        List.from(_localCameraStream?.getAudioTracks() ?? []);

    for (final track in oldAudioTracks) {
      await _localCameraStream?.removeTrack(track);
      await track.stop();
    }

    _currentCallSetting = _currentCallSetting.copyWith(
      audioConfig: _currentCallSetting.audioConfig.copyWith(deviceId: deviceId),
    );

    final Map<String, dynamic> userMedia = _currentCallSetting.mediaConstraints;

    final MediaStream newAudioStream =
        await navigator.mediaDevices.getUserMedia(userMedia);

    if (_localCameraStream != null) {
      final MediaStreamTrack audioTrack = newAudioStream.getAudioTracks().first;
      await _localCameraStream!.addTrack(audioTrack);
      await _replaceAudioTrack(audioTrack);

      await _mParticipant?.setSrcObject(_localCameraStream!);
    }

    _notify(CallbackEvents.shouldBeUpdateState);
  }

  @override
  Future<void> toggleVideoInputDevice({required String deviceId}) async {
    if (_mParticipant == null) return;

    final List<MediaStreamTrack> oldVideoTracks =
        List.from(_localCameraStream?.getVideoTracks() ?? []);

    for (final track in oldVideoTracks) {
      await _localCameraStream?.removeTrack(track);
      await track.stop();
    }
    final Map<String, dynamic> userMedia = _currentCallSetting.mediaConstraints;

    _currentCallSetting = _currentCallSetting.copyWith(
      videoConfig: _currentCallSetting.videoConfig.copyWith(deviceId: deviceId),
    );

    final MediaStream newVideoStream =
        await navigator.mediaDevices.getUserMedia(userMedia);

    if (_localCameraStream != null) {
      final MediaStreamTrack videoTrack = newVideoStream.getVideoTracks().first;
      await _localCameraStream!.addTrack(videoTrack);
      await _replaceVideoTrack(videoTrack);

      await _mParticipant?.setSrcObject(_localCameraStream!);
    }
  }

  @override
  Future<void> switchCameraInput() async {
    if (_localCameraStream == null) {
      throw Exception('Stream is not initialized');
    }

    final List<MediaStreamTrack> videoTracks =
        _localCameraStream!.getVideoTracks();

    if (videoTracks.isEmpty) return;

    await Helper.switchCamera(videoTracks.first);

    _mParticipant = _mParticipant?.switchCamera;

    _wsEmitter.switchCamera(_mParticipant?.cameraType ?? CameraType.front);

    _notify(CallbackEvents.shouldBeUpdateState);
  }

  // ====== Screen Sharing ======
  @override
  Future<void> startScreenShare({DesktopCapturerSource? source}) async {
    try {
      if (_mParticipant == null || _mParticipant!.isSharingScreen) return;

      if (WebRTC.platformIsAndroid) {
        await _nativeService.startForegroundService();
      }

      _screenSharingStream = await _getDisplayMedia(source);

      if (_screenSharingStream?.getVideoTracks().isEmpty ?? true) return;

      if (WebRTC.platformIsMobile && _mParticipant!.isVideoEnabled) {
        await toggleVideoInput(forceValue: false);
      }

      final screenTrack = _screenSharingStream!.getVideoTracks().first;

      final sender = await _mParticipant!.peerConnection.addSimulcastTrack(
        screenTrack,
        vCodec: _currentCallSetting.videoConfig.preferedCodec,
        stream: _screenSharingStream!,
      );

      await _e2eeManager.addRtpSender(sender: sender);

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

      _wsEmitter.toggleScreenSharing(true, screenTrackId: screenTrack.id);

      await _performRenegotiation();

      _screenSharingStream?.getVideoTracks().first.onEnded = () {
        stopScreenShare();
      };

      _mParticipant = await _mParticipant?.setScreenSharing(true);

      _notify(CallbackEvents.shouldBeUpdateState);
    } catch (e) {
      stopScreenShare();
    }
  }

  @override
  Future<void> stopScreenShare({bool stayInRoom = true}) async {
    if (!(_mParticipant?.isSharingScreen ?? true)) return;

    if (_mParticipant == null) return;

    _videoStats.removeSenders('$kIsMine-${TrackType.screen.toString()}');

    if (stayInRoom) {
      if (WebRTC.platformIsMobile &&
          (_localCameraStream?.getVideoTracks().isNotEmpty ?? false)) {
        if (_mParticipant!.isVideoEnabled) {
          await toggleVideoInput(forceValue: true);
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

    _mParticipant = await _mParticipant?.setScreenSharing(false);
    _screenSharingStream?.dispose();
    _screenSharingStream = null;

    if (stayInRoom) {
      _notify(CallbackEvents.shouldBeUpdateState);
      _wsEmitter.toggleScreenSharing(false);
    } else {
      _replayKitChannel.closeReplayKit();
    }
  }

  // ====== Virtual Background ======
  @override
  Future<void> enableVirtualBg({
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
  Future<void> disableVirtualBg({bool reset = false}) async {
    await stopVirtualBackground(reset: reset);
  }

  // ====== Raise Hand & State Toggling ======
  @override
  void toggleHandRaise() {
    if (_mParticipant == null) return;

    _mParticipant = _mParticipant?.copyWith(
      isHandRaising: !_mParticipant!.isHandRaising,
    );

    _notify(CallbackEvents.shouldBeUpdateState);

    _wsEmitter.toggleHandRaise(_mParticipant!.isHandRaising);
  }

  @override
  void setParticipantHandRaising({
    required String targetId,
    required bool isRaising,
  }) {
    if (_remoteSubscribers[targetId]?.isHandRaising == isRaising) return;

    _remoteSubscribers[targetId] =
        _remoteSubscribers[targetId]!.copyWith(isHandRaising: isRaising);

    _notify(CallbackEvents.raiseHand);
  }

  @override
  void setRecordingStatus({required bool isRecording}) {
    _isSessionBeingRecorded = isRecording;
    _notify(CallbackEvents.shouldBeUpdateState);
  }

  @override
  void setParticipantCameraType({
    required String targetId,
    required CameraType type,
  }) {
    if (_remoteSubscribers[targetId]?.cameraType == type) return;

    _remoteSubscribers[targetId] =
        _remoteSubscribers[targetId]!.copyWith(cameraType: type);
    _notify(CallbackEvents.shouldBeUpdateState);
  }

  @override
  void setParticipantVideoEnabled({
    required String targetId,
    required bool isEnabled,
  }) {
    if (_remoteSubscribers[targetId]?.isVideoEnabled == isEnabled) return;

    _remoteSubscribers[targetId] =
        _remoteSubscribers[targetId]!.copyWith(isVideoEnabled: isEnabled);
    _notify(CallbackEvents.shouldBeUpdateState);
  }

  @override
  void setParticipantAudioEnabled({
    required String targetId,
    required bool isEnabled,
  }) {
    if (_remoteSubscribers[targetId]?.isAudioEnabled == isEnabled) return;

    _remoteSubscribers[targetId] =
        _remoteSubscribers[targetId]!.copyWith(isAudioEnabled: isEnabled);

    _notify(CallbackEvents.shouldBeUpdateState);
  }

  @override
  Future<void> setParticipantScreenSharing({
    required ParticipantScreenSharingConfig config,
  }) async {
    final state =
        await _remoteSubscribers[config.participantId]?.setScreenSharing(
      config.isSharing,
      screenTrackId: config.screenTrackId,
    );

    if (state != null) {
      _remoteSubscribers[config.participantId] = state;
      _notify(CallbackEvents.shouldBeUpdateState);
    }
  }

  @override
  Future<void> setParticipantE2ee({
    required ParticipantE2eeConfig config,
  }) async {
    if (_remoteSubscribers[config.targetId] != null) {
      _remoteSubscribers[config.targetId] =
          _remoteSubscribers[config.targetId]!.copyWith(
        isE2eeEnabled: config.isEnabled,
      );
    }

    await _e2eeManager.addRtpReceiver(
      receiver: config.receiver,
      codec:
          _remoteSubscribers[config.targetId]?.videoCodec ?? RTCVideoCodec.h264,
      enabled: config.isEnabled,
    );
  }

  // ====== State Exposure ======
  @override
  CallState getCallState() {
    return CallState(
      mParticipant: _mParticipant,
      participants: _remoteSubscribers,
    );
  }

  @override
  Stream<CallbackPayload> get onCallChanged => _eventStreamController.stream;

  @override
  String? get currentRoomId => _currentRoomId;

  @override
  bool get isRecordingActive => _isSessionBeingRecorded;

  // MARK: Private methods
  // ======== Media Acquisition ========
  Future<MediaStream?> _getUserMedia({bool onlyStream = false}) async {
    try {
      final MediaStream stream = await navigator.mediaDevices.getUserMedia(
        _currentCallSetting.mediaConstraints,
      );
      // Microphone not granted or has been broken
      if (stream.getAudioTracks().isEmpty) {
        toggleAudioInput(forceValue: false);
      }

      // Camera not granted or has been broken
      if (stream.getVideoTracks().isEmpty) {
        toggleVideoInput(forceValue: false);
      }

      if (stream.getTracks().isEmpty) return null;

      if (onlyStream) return stream;

      if (_currentCallSetting.audioConfig.isAudioMuted) {
        toggleAudioInput(forceValue: false);
      }

      if (_currentCallSetting.videoConfig.isVideoMuted) {
        toggleVideoInput(forceValue: false);
      }

      return stream;
    } catch (error) {
      // Unable getUserMedia
      toggleAudioInput(forceValue: false);
      toggleVideoInput(forceValue: false);

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

  // ======== PeerConnection Lifecycle ========
  Future<RTCPeerConnection> _createPeerConnection({
    Map<String, dynamic> constraints = const {},
    bool? isE2eeEnabled,
  }) async {
    final RTCPeerConnection pc = await createPeerConnection(
      RTCConfigurations.configuration(
        isE2eeEnabled ?? _currentCallSetting.e2eeEnabled,
      ),
      constraints,
    );

    pc.createDataChannel('waterbus', RTCDataChannelInit());

    return pc;
  }

  Future<void> _establishBroadcastConnection() async {
    final RTCPeerConnection peerConnection = _mParticipant!.peerConnection;

    peerConnection.onIceCandidate = (candidate) {
      if (_canPublisherAddIceCandidate) {
        _wsEmitter.sendPublisherIceCandidate(candidate);
      } else {
        _iceCandidateQueueForPublisher.add(candidate);
      }
    };

    final List<MediaStreamTrack> tracks = _localCameraStream?.getTracks() ?? [];
    final List<RTCRtpSender> senders = [];

    for (final track in tracks) {
      final sender = await peerConnection.addSimulcastTrack(
        track,
        vCodec: _currentCallSetting.videoConfig.preferedCodec,
        stream: _localCameraStream!,
        kind: track.kind == RtcTrackKind.video.kind
            ? RtcTrackKind.video
            : RtcTrackKind.audio,
      );

      senders.add(sender);

      if (track.kind == RtcTrackKind.audio.kind) {
        _audioStats.setSender = AudioStatsParams(
          receivers: [],
          ownerId: kIsMine,
          pc: peerConnection,
          callBack: (audioLevel) {
            _mParticipant = _mParticipant?.sinkAudioLevel(audioLevel);
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

    await _applyEncryption(_currentCallSetting.e2eeEnabled, senders: senders);

    String sdp = await _createOfferSdp(peerConnection);

    if (_localCameraStream?.getVideoTracks().isNotEmpty ?? false) {
      sdp = sdp.optimizeSdp(
        codec: _currentCallSetting.videoConfig.preferedCodec,
      );
    }

    final RTCSessionDescription description = RTCSessionDescription(
      sdp,
      DescriptionType.offer.type,
    );

    await peerConnection.setLocalDescription(description);

    final PublishWsEmitterPayLoad payload = PublishWsEmitterPayLoad(
      sdp: sdp,
      roomId: _currentRoomId!,
      participantId: _currentParticipantId!,
      totalTracks: senders.length,
      isVideoEnabled: _mParticipant?.isVideoEnabled ?? false,
      isAudioEnabled: _mParticipant?.isAudioEnabled ?? false,
      isE2eeEnabled: _mParticipant?.isE2eeEnabled ?? false,
    );

    _wsEmitter.publishRoom(payload: payload);

    if (WebRTC.platformIsLinux) return;

    _videoStats.initialize();
    _audioStats.initialize();
  }

  Future<void> _establishSubscriberConnection(String targetId) async {
    if (_currentRoomId == null || _currentParticipantId == null) return;

    final SubscribePayload payload = SubscribePayload(
      roomId: _currentRoomId ?? "",
      participantId: _currentParticipantId ?? "",
      targetId: targetId,
    );

    _wsEmitter.subscribeRoom(payload: payload);
  }

  // ======== SDP Offer/Answer ========
  Future<String> _createAnswerSdp(RTCPeerConnection peerConnection) async {
    final RTCSessionDescription description =
        await peerConnection.createAnswer();
    final session = parse(description.sdp.toString());
    final String sdp = write(session, null);

    return sdp;
  }

  Future<String> _createOfferSdp(RTCPeerConnection peerConnection) async {
    final RTCSessionDescription description =
        await peerConnection.createOffer();
    final session = parse(description.sdp.toString());
    final String sdp = write(session, null);

    return sdp;
  }

// ======== ICE Handling ========
  Future<void> _answerSubscriber({
    required RTCSessionDescription remoteDescription,
    required SubscribeResponsePayload payload,
  }) async {
    final RTCPeerConnection rtcPeerConnection = await _createPeerConnection(
      constraints: RTCConfigurations.offerSubscriberSdpConstraints,
      isE2eeEnabled: payload.isE2eeEnabled,
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

    final targetId = payload.targetId;

    _remoteSubscribers[targetId] = ParticipantMediaState.init(
      ownerId: targetId,
      peerConnection: rtcPeerConnection,
      onFirstFrameRendered: () => _notify(CallbackEvents.shouldBeUpdateState),
      isAudioEnabled: payload.audioEnabled,
      isVideoEnabled: payload.videoEnabled,
      isSharingScreen: payload.isScreenSharing,
      isE2eeEnabled: payload.isE2eeEnabled,
      isHandRaising: payload.isHandRaising,
      screenTrackId: payload.screenTrackId,
      cameraType: payload.type,
      videoCodec: payload.codec,
    );

    rtcPeerConnection.onTrack = (track) {
      if (_remoteSubscribers[targetId] == null) return;

      if (track.streams.isEmpty) return;

      Future.microtask(() async {
        if (track.receiver == null) return;
        final ParticipantE2eeConfig config = ParticipantE2eeConfig(
          receiver: track.receiver!,
          targetId: targetId,
          isEnabled: payload.isE2eeEnabled,
        );

        await setParticipantE2ee(config: config);

        final TrackType? type =
            await _remoteSubscribers[targetId]?.setSrcObject(
          track.streams.first,
          trackId: track.track.id,
        );

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
      _wsEmitter.sendSubscriberIceCandidate(
        candidate: candidate,
        targetId: targetId,
      );
    };

    rtcPeerConnection.setRemoteDescription(remoteDescription);

    final String sdp = await _createAnswerSdp(rtcPeerConnection);
    final RTCSessionDescription description = RTCSessionDescription(
      sdp,
      DescriptionType.answer.type,
    );
    await rtcPeerConnection.setLocalDescription(description);

    _wsEmitter.answerSubscription(targetId: targetId, sdp: sdp);

    // Process queue candidates from server
    final List<RTCIceCandidate> candidates =
        _iceCandidateQueueForSubscribers[targetId] ?? [];

    for (final candidate in candidates) {
      addIceCandidateToSubscriber(targetId, candidate);
    }
  }

  // ======== Stream Replacement ========
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

  Future<void> _replaceAudioTrack(
    MediaStreamTrack track, {
    List<RTCRtpSender>? sendersList,
  }) async {
    final List<RTCRtpSender> senders =
        (sendersList ?? await _mParticipant!.peerConnection.getSenders())
            .where(
              (sender) => sender.track?.kind == RtcTrackKind.audio.kind,
            )
            .toList();

    if (senders.isEmpty) return;

    final sender = senders.first;

    await sender.replaceTrack(track);

    await _applyEncryption(_currentCallSetting.e2eeEnabled, senders: [sender]);
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

    await _applyEncryption(_currentCallSetting.e2eeEnabled, senders: [sender]);
  }

  // ======== Encryption (E2EE) Setup ========
  Future<void> _applyEncryption(
    bool enabled, {
    List<RTCRtpSender> senders = const [],
  }) async {
    final List<Future> futureTasks = [];

    for (final sender in senders) {
      futureTasks.add(
        _e2eeManager.addRtpSender(sender: sender),
      );
    }

    await Future.wait(futureTasks);

    _mParticipant = _mParticipant?.copyWith(isE2eeEnabled: enabled);
  }

  // ======== Renegotiation Flow ========
  Future<void> _performRenegotiation() async {
    final pc = _mParticipant?.peerConnection;

    if (pc == null) return;

    String sdp = await _createOfferSdp(pc);

    if (_localCameraStream?.getVideoTracks().isNotEmpty ?? false) {
      sdp = sdp.optimizeSdp(
        codec: _currentCallSetting.videoConfig.preferedCodec,
      );
    }

    final RTCSessionDescription description = RTCSessionDescription(
      sdp,
      DescriptionType.offer.type,
    );

    await pc.setLocalDescription(description);

    _wsEmitter.renegotiateSdp(sdp);
  }

  // ======== Room / Signaling Helper Methods ========
  void _notify(
    CallbackEvents event, {
    String? participantId,
    Participant? participant,
  }) {
    _eventStreamController.sink.add(
      CallbackPayload(
        event: event,
        callState: getCallState(),
        newParticipant: participant,
        participantId: participantId,
      ),
    );
  }
}
