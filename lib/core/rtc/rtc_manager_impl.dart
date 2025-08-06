import 'dart:async';

import 'package:flutter/foundation.dart';

import 'package:injectable/injectable.dart';
import 'package:sdp_transform/sdp_transform.dart';

import 'package:waterbus_sdk/constants/rtc_configurations.dart';
import 'package:waterbus_sdk/core/api/auth/repositories/auth_repository.dart';
import 'package:waterbus_sdk/core/events/waterbus_event_system.dart';
import 'package:waterbus_sdk/core/rtc/e2ee/e2ee_manager.dart';
import 'package:waterbus_sdk/core/rtc/rtc_manager.dart';
import 'package:waterbus_sdk/core/rtc/stats/rtc_audio_stats.dart';
import 'package:waterbus_sdk/core/rtc/stats/rtc_video_stats.dart';
import 'package:waterbus_sdk/core/ws/interfaces/ws_emitter.dart';
import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';
import 'package:waterbus_sdk/native/native_channel.dart';
import 'package:waterbus_sdk/native/replaykit.dart';
import 'package:waterbus_sdk/native/virtual_background/index.dart';
import 'package:waterbus_sdk/utils/extensions/duration_extension.dart';
import 'package:waterbus_sdk/utils/extensions/pc_extension.dart';
import 'package:waterbus_sdk/utils/extensions/sdp_extension.dart';
import 'package:waterbus_sdk/utils/ipv6/index.dart';
import 'package:waterbus_sdk/utils/logger/logger.dart';

@LazySingleton(as: RtcManager)
class RtcManagerIpml extends RtcManager {
  final E2EEManager _e2eeManager;
  final WsEmitter _wsEmitter;
  final ReplayKitChannel _replayKitChannel;
  final NativeService _nativeService;
  final RtcVideoStats _videoStats;
  final RtcAudioStats _audioStats;
  final AuthRepository _authRepository;
  RtcManagerIpml(
    this._e2eeManager,
    this._wsEmitter,
    this._replayKitChannel,
    this._nativeService,
    this._videoStats,
    this._audioStats,
    this._authRepository,
  ) {
    scheduleMicrotask(() async {
      _isIpv6Supported = await isIpv6Supported();
    });
  }

  ConnectionType _connectionType = ConnectionType.p2p;
  String? _currentRoomId;
  String? _currentParticipantId;
  MediaStream? _localCameraStream;
  MediaStream? _screenSharingStream;
  LocalParticipant? _localParticipant;
  bool _canPublisherAddIceCandidate = false;
  bool _isSessionBeingRecorded = false;
  bool _isIpv6Supported = false;
  MediaConfig _currentCallSetting = MediaConfig();
  final Map<String, RemoteParticipant> _remoteSubscribers = {};
  final Map<String, List<RTCIceCandidate>> _iceCandidateQueueForSubscribers =
      {};
  final List<RTCIceCandidate> _iceCandidateQueueForPublisher = [];
  final List<RTCIceCandidate> _remoteIceCandidatesForPublisher = [];
  final WaterbusEventSystem _eventSystem = WaterbusEventSystem();

  // ====== Room Management ======
  @override
  Future<void> joinRoom({
    required String roomId,
    required int participantId,
    required ConnectionType connectionType,
  }) async {
    _connectionType = connectionType;

    await Future.wait([
      _e2eeManager.initialize(
        roomId,
        codec: _currentCallSetting.videoConfig.preferedCodec,
        participantId: participantId.toString(),
        enabled: _currentCallSetting.e2eeEnabled,
      ),
      initializeMediaDevices(),
    ]);

    if (_localParticipant?.peerConnection == null) return;

    if (WebRTC.platformIsMobile) {
      final futures = <Future>[];
      if (WebRTC.platformIsIOS) {
        futures.add(
          Helper.setAppleAudioIOMode(
            AppleAudioIOMode.localAndRemote,
            preferSpeakerOutput: true,
          ),
        );
      }
      futures.add(toggleSpeakerOutput(forceValue: true));
      await Future.wait(futures);
    }

    if (connectionType == ConnectionType.sfu) {
      _localParticipant = await _localParticipant?.createTrackQualityChannel();
    }

    _currentRoomId = roomId;
    _currentParticipantId = participantId.toString();

    await _establishPublisher();

    _nativeService.startCallKit(roomId);
  }

  @override
  Future<void> reconnectRoom() async {
    if (_localParticipant == null) return;

    _videoStats.dispose();
    _audioStats.dispose();
    await _localParticipant?.peerConnection.close();

    final RTCPeerConnection peerConnection = await _createPeerConnection(
      constraints: RTCConfigurations.offerPublisherSdpConstraints,
    );

    if (_localParticipant != null) {
      _localParticipant!.peerConnection = peerConnection;
    }

    await _establishPublisher();
  }

  @override
  void subscribeToParticipants(List<String> targetIds) {
    for (final targetId in targetIds) {
      scheduleMicrotask(() => _establishSubscriber(targetId));
    }
  }

  @override
  Future<void> leaveRoom() async {
    try {
      if (_localParticipant == null) return;

      if (_currentRoomId != null) {
        _wsEmitter.leaveRoom(_currentRoomId!);
      }

      _resetRoomState();

      final disposeOperations = <Future>[];

      for (final subscriber in _remoteSubscribers.values) {
        disposeOperations.add(subscriber.dispose());
      }

      if (_localCameraStream != null) {
        final tracks = _localCameraStream!.getTracks();
        for (final track in tracks) {
          track.stop();
        }
        disposeOperations.add(_localCameraStream!.dispose());
      }

      if (_localParticipant != null) {
        disposeOperations.add(_localParticipant!.dispose());
      }

      disposeOperations.addAll([
        stopScreenShare(stayInRoom: false),
      ]);

      await Future.wait(disposeOperations);

      // Clear collections efficiently
      _remoteSubscribers.clear();
      _localParticipant = null;
      _localCameraStream = null;
      _videoStats.dispose();
      _audioStats.dispose();
      _e2eeManager.dispose();

      _notifyRoomEvent(
        RoomEnded(
          timestamp: DateTime.now(),
          roomId: _currentRoomId ?? '',
        ),
      );

      // Clear for next time
      disableVirtualBg(reset: true);

      // Dispose event system
      _eventSystem.dispose();
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

    await _localParticipant?.setRemoteDescription(description);

    _canPublisherAddIceCandidate = true;

    final candidateOperations = <Future>[];

    for (final candidate in _iceCandidateQueueForPublisher) {
      _wsEmitter.sendPublisherIceCandidate(
        candidate: candidate,
        connectionType: _connectionType,
        roomId: _currentRoomId!,
      );
    }

    for (final candidate in _remoteIceCandidatesForPublisher) {
      candidateOperations.add(_localParticipant!.addCandidate(candidate));
    }

    if (candidateOperations.isNotEmpty) {
      await Future.wait(candidateOperations);
    }

    _iceCandidateQueueForPublisher.clear();
    _remoteIceCandidatesForPublisher.clear();
  }

  @override
  Future<void> setRemoteSdpAsSubscriber(
    SubscribeResponsePayload payload,
  ) async {
    final subscriber = _remoteSubscribers[payload.targetId];
    if (subscriber != null && subscriber.connectionType == ConnectionType.sfu) {
      return;
    }

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
    if (targetId.isEmpty && _remoteSubscribers.length != 1) {
      return;
    }

    late String participantId;

    if (targetId.isEmpty) {
      participantId = _remoteSubscribers.keys.first;
      await Future.delayed(1.seconds);
    } else {
      participantId = targetId;
    }

    if (_remoteSubscribers[participantId]?.peerConnection == null) return;

    final RTCPeerConnection pc =
        _remoteSubscribers[participantId]!.peerConnection;

    final RTCSessionDescription remoteDescription = RTCSessionDescription(
      sdp,
      DescriptionType.offer.type,
    );

    await pc.setRemoteDescription(remoteDescription);

    try {
      final String sdpAnswer = await _createAnswerSdp(pc);
      final RTCSessionDescription localDescription = RTCSessionDescription(
        sdpAnswer,
        DescriptionType.answer.type,
      );
      await pc.setLocalDescription(localDescription);

      _wsEmitter.answerSubscription(
        roomId: _currentRoomId!,
        targetId: targetId,
        sdp: sdpAnswer,
        connectionType: _connectionType,
      );
    } catch (_) {}
  }

  @override
  Future<void> addIceCandidateToPublisher(RTCIceCandidate candidate) async {
    if (_canPublisherAddIceCandidate) {
      await _localParticipant?.addCandidate(candidate);
    } else {
      _remoteIceCandidatesForPublisher.add(candidate);
    }
  }

  @override
  Future<void> addIceCandidateToSubscriber(
    String targetId,
    RTCIceCandidate candidate,
  ) async {
    if (targetId.isEmpty && _remoteSubscribers.length != 1) {
      return;
    }

    late String participantId;

    if (targetId.isEmpty) {
      participantId = _remoteSubscribers.keys.first;
    } else {
      participantId = targetId;
    }

    if (_remoteSubscribers[participantId] != null &&
        _remoteSubscribers[participantId]!.connectionType == _connectionType) {
      await _remoteSubscribers[participantId]?.addCandidate(candidate);
    } else {
      _iceCandidateQueueForSubscribers
          .putIfAbsent(participantId, () => [])
          .add(candidate);
    }
  }

  // ====== ParticipantInfo Handling ======
  @override
  Future<void> handleParticipantJoined({
    required ParticipantInfo participant,
    required bool isMigrate,
  }) async {
    final participantId = participant.id.toString();
    final isExists = _remoteSubscribers.containsKey(participantId);

    if (_remoteSubscribers.length == 1 && !isExists) {
      _setConnectionType(ConnectionType.sfu, needMigrate: true);
    }

    scheduleMicrotask(() => _establishSubscriber(participantId));

    _notifyParticipantEvent(
      ParticipantJoined(
        timestamp: DateTime.now(),
        roomId: _currentRoomId ?? '',
        participantId: participant.id.toString(),
        participantData: {'participant': participant},
      ),
    );
  }

  @override
  Future<void> handleParticipantLeft(String targetId) async {
    _notifyParticipantEvent(
      ParticipantLeft(
        timestamp: DateTime.now(),
        roomId: _currentRoomId ?? '',
        participantId: targetId,
      ),
    );

    final subscriber = _remoteSubscribers.remove(targetId);
    if (subscriber != null) {
      await subscriber.dispose();
    }

    _iceCandidateQueueForSubscribers.remove(targetId);
    _audioStats.removeReceiver(targetId);
    _videoStats.removeReceivers(targetId);

    if (_remoteSubscribers.isEmpty) {
      _setConnectionType(ConnectionType.p2p, needMigrate: true);
    }
  }

  // ====== Media & Device Control ======
  @override
  Future<void> initializeMediaDevices() async {
    if (_localParticipant?.peerConnection != null) return;

    final RTCPeerConnection peerConnection = await _createPeerConnection(
      constraints: RTCConfigurations.offerPublisherSdpConstraints,
    );

    _localParticipant = LocalParticipant.init(
      ownerId: kIsMine,
      peerConnection: peerConnection,
      onFirstFrameRendered: () => _notifyRoomEvent(
        RoomStateChanged(
          timestamp: DateTime.now(),
          roomId: _currentRoomId ?? '',
        ),
      ),
      videoCodec: _currentCallSetting.videoConfig.preferedCodec,
      isE2eeEnabled: _currentCallSetting.e2eeEnabled,
      connectionType: _connectionType,
    );

    _localCameraStream = await _getUserMedia();
    if (_localCameraStream != null) {
      _localParticipant?.setSrcObject(_localCameraStream!);
    }
  }

  @override
  Future<void> updateMediaConfig(MediaConfig setting) async {
    if (_currentCallSetting.videoConfig.videoQuality ==
        setting.videoConfig.videoQuality) {
      if (_currentCallSetting.e2eeEnabled != setting.e2eeEnabled) {
        await _applyEncryption(setting.e2eeEnabled);
      }

      _currentCallSetting = setting;

      return;
    }

    _currentCallSetting = setting;

    if (_localCameraStream == null || _localParticipant == null) return;

    final MediaStream? newStream = await _getUserMedia(onlyStream: true);

    await _replaceMediaStream(newStream);

    if (!(_localParticipant?.isVideoEnabled ?? true)) {
      await toggleVideoInput(forceValue: _localParticipant?.isVideoEnabled);
    }

    if (!(_localParticipant?.isAudioEnabled ?? true)) {
      await toggleAudioInput(forceValue: _localParticipant?.isAudioEnabled);
    }
  }

  @override
  Future<void> toggleAudioInput({bool? forceValue}) async {
    if (_localParticipant == null) return;

    final tracks = _localCameraStream?.getAudioTracks() ?? [];
    final newValue = forceValue ?? !_localParticipant!.isAudioEnabled;

    for (final track in tracks) {
      track.enabled = newValue;
    }

    if (_localParticipant != null) {
      _localParticipant!.isAudioEnabled = newValue;
    }
    _notifyRoomEvent(
      RoomStateChanged(
        timestamp: DateTime.now(),
        roomId: _currentRoomId ?? '',
      ),
    );

    if (_currentRoomId != null) {
      _wsEmitter.toggleAudio(newValue);
    }
  }

  @override
  Future<void> toggleVideoInput({
    bool? forceValue,
    bool ignoreUpdateValue = false,
  }) async {
    if (_localParticipant == null) return;

    if (_localParticipant!.isSharingScreen && WebRTC.platformIsMobile) return;

    final tracks = _localCameraStream?.getVideoTracks() ?? [];
    final newValue = forceValue ?? !_localParticipant!.isVideoEnabled;

    if (kIsWeb) {
      await _handleWebVideoToggle(tracks, newValue);
    } else {
      for (final track in tracks) {
        track.enabled = newValue;
      }
    }

    if (ignoreUpdateValue) return;

    if (_localParticipant != null) {
      _localParticipant!.isVideoEnabled = newValue;
    }
    _notifyRoomEvent(
      RoomStateChanged(
        timestamp: DateTime.now(),
        roomId: _currentRoomId ?? '',
      ),
    );

    if (_currentRoomId != null) {
      _wsEmitter.toggleVideo(newValue);
    }
  }

  Future<void> _handleWebVideoToggle(
    List<MediaStreamTrack> tracks,
    bool enable,
  ) async {
    for (final track in tracks) {
      track.enabled = enable;
      if (!enable) {
        await track.stop();
      } else {
        await _localCameraStream?.removeTrack(track);
      }
    }

    if (enable && _localCameraStream != null) {
      final localStream = await _getUserMedia(onlyStream: true);
      if (localStream != null) {
        final videoTrack = localStream.getVideoTracks().firstOrNull;
        if (videoTrack != null) {
          await _localCameraStream!.addTrack(videoTrack);
          await _replaceVideoTrack(videoTrack);
          _localParticipant?.setSrcObject(localStream);
        }
      }
    }
  }

  @override
  Future<void> toggleSpeakerOutput({bool? forceValue}) async {
    if (_localParticipant == null) return;

    final newValue = forceValue ?? !_localParticipant!.isSpeakerPhoneEnabled;
    if (_localParticipant != null) {
      _localParticipant!.isSpeakerPhoneEnabled = newValue;
    }

    if (WebRTC.platformIsMobile) {
      await Helper.setSpeakerphoneOn(newValue);
      if (newValue) {
        await Helper.setSpeakerphoneOnButPreferBluetooth();
      }
    }

    _notifyRoomEvent(
      RoomStateChanged(
        timestamp: DateTime.now(),
        roomId: _currentRoomId ?? '',
      ),
    );
  }

  @override
  Future<void> changeAudioInputDevice({required String deviceId}) async {
    if (_localParticipant == null) return;

    _currentCallSetting = _currentCallSetting.copyWith(
      audioConfig: _currentCallSetting.audioConfig.copyWith(deviceId: deviceId),
    );

    final MediaStream? newStream = await _getUserMedia(onlyStream: true);

    if (newStream == null) return;

    final MediaStreamTrack? audioTrack = newStream.getAudioTracks().firstOrNull;

    if (audioTrack == null) return;

    _localCameraStream = newStream;
    await _replaceAudioTrack(audioTrack);

    _localParticipant?.setSrcObject(newStream);
  }

  @override
  Future<void> changeVideoInputDevice({required String deviceId}) async {
    if (_localParticipant == null) return;

    _currentCallSetting = _currentCallSetting.copyWith(
      videoConfig: _currentCallSetting.videoConfig.copyWith(deviceId: deviceId),
    );

    final MediaStream? newStream = await _getUserMedia(onlyStream: true);

    if (newStream == null) return;

    final MediaStreamTrack? videoTrack = newStream.getVideoTracks().firstOrNull;

    if (videoTrack == null) return;

    _localCameraStream = newStream;
    await _replaceVideoTrack(videoTrack);

    _localParticipant?.setSrcObject(newStream);
  }

  @override
  Future<void> switchCameraInput() async {
    if (_localCameraStream == null) {
      throw Exception('Stream is not initialized');
    }

    final videoTracks = _localCameraStream!.getVideoTracks();
    if (videoTracks.isEmpty) return;

    await Helper.switchCamera(videoTracks.first);
    _localParticipant = _localParticipant?.switchCamera;
    _wsEmitter.switchCamera(_localParticipant?.cameraType ?? CameraType.front);
    _notifyRoomEvent(
      RoomStateChanged(
        timestamp: DateTime.now(),
        roomId: _currentRoomId ?? '',
      ),
    );
  }

  // ====== Screen Sharing ======
  @override
  Future<void> startScreenShare({DesktopCapturerSource? source}) async {
    try {
      if (_localParticipant == null || _localParticipant!.isSharingScreen) {
        return;
      }

      if (WebRTC.platformIsAndroid) {
        await _nativeService.startForegroundService();
      }

      _screenSharingStream = await _getDisplayMedia(source);

      if (_screenSharingStream?.getVideoTracks().isEmpty ?? true) return;

      if (WebRTC.platformIsMobile && _localParticipant!.isVideoEnabled) {
        await toggleVideoInput(forceValue: false);
      }

      final screenTrack = _screenSharingStream!.getVideoTracks().first;

      _wsEmitter.toggleScreenSharing(true, screenTrackId: screenTrack.id);

      final sender = await _localParticipant!.peerConnection.addSimulcastTrack(
        screenTrack,
        vCodec: _currentCallSetting.videoConfig.preferedCodec,
        stream: _screenSharingStream!,
        isSingleTrack: _connectionType == ConnectionType.p2p,
      );

      await Future.wait([
        _e2eeManager.addRtpSender(sender: sender),
        _performRenegotiation(),
      ]);

      _videoStats.addSenders(
        ownerId: '$kIsMine-${TrackType.screen.toString()}',
        senders: [sender],
        callback: (stats) => _localParticipant?.sinkScreenStats(stats),
      );

      _localParticipant?.setSrcObject(
        _screenSharingStream!,
        isDisplayStream: true,
      );

      screenTrack.onEnded = () => scheduleMicrotask(stopScreenShare);
      _localParticipant = await _localParticipant?.setScreenSharing(true);
      _notifyRoomEvent(
        RoomStateChanged(
          timestamp: DateTime.now(),
          roomId: _currentRoomId ?? '',
        ),
      );
    } catch (e) {
      stopScreenShare();
    }
  }

  @override
  Future<void> stopScreenShare({bool stayInRoom = true}) async {
    if (!(_localParticipant?.isSharingScreen ?? true)) return;
    if (_localParticipant == null) return;

    _videoStats.removeSenders('$kIsMine-${TrackType.screen.toString()}');

    if (stayInRoom) {
      if (WebRTC.platformIsMobile &&
          (_localCameraStream?.getVideoTracks().isNotEmpty ?? false) &&
          _localParticipant!.isVideoEnabled) {
        await toggleVideoInput(forceValue: true);
      }

      final senders = await _localParticipant!.peerConnection.getSenders();
      final videoSender = senders
          .where((s) => s.track?.kind == RtcTrackKind.video.kind)
          .lastOrNull;

      if (videoSender != null) {
        await _localParticipant!.peerConnection.removeTrack(videoSender);
      }
    }

    final operations = <Future>[];

    if (WebRTC.platformIsAndroid) {
      operations.add(_nativeService.stopForegroundService());
    }

    final tracks = _screenSharingStream?.getTracks() ?? [];

    for (final track in tracks) {
      operations.add(track.stop());
    }

    if (operations.isNotEmpty) {
      await Future.wait(operations);
    }

    _localParticipant = await _localParticipant?.setScreenSharing(false);
    _screenSharingStream?.dispose();
    _screenSharingStream = null;

    if (stayInRoom) {
      _notifyRoomEvent(
        RoomStateChanged(
          timestamp: DateTime.now(),
          roomId: _currentRoomId ?? '',
        ),
      );
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
      textureId: _localParticipant?.cameraSource?.textureId.toString(),
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
    if (_localParticipant == null) return;

    _localParticipant!.isHandRaising = !_localParticipant!.isHandRaising;

    _notifyRoomEvent(
      RoomStateChanged(
        timestamp: DateTime.now(),
        roomId: _currentRoomId ?? '',
      ),
    );

    _wsEmitter.toggleHandRaise(_localParticipant!.isHandRaising);
  }

  @override
  void setParticipantHandRaising({
    required String targetId,
    required bool isRaising,
  }) {
    if (_remoteSubscribers[targetId]?.isHandRaising == isRaising) return;

    _remoteSubscribers[targetId]!.isHandRaising = isRaising;

    _notifyParticipantEvent(
      ParticipantHandRaiseChanged(
        timestamp: DateTime.now(),
        roomId: _currentRoomId ?? '',
        participantId: targetId,
        isRaising: isRaising,
      ),
    );
  }

  @override
  void setRecordingStatus({required bool isRecording}) {
    _isSessionBeingRecorded = isRecording;
    _notifyRoomEvent(
      RoomRecordingStatusChanged(
        timestamp: DateTime.now(),
        roomId: _currentRoomId ?? '',
        isRecording: isRecording,
      ),
    );
  }

  @override
  void setParticipantCameraType({
    required String targetId,
    required CameraType type,
  }) {
    if (_remoteSubscribers[targetId]?.cameraType == type) return;

    _remoteSubscribers[targetId]!.cameraType = type;
    _notifyParticipantEvent(
      ParticipantCameraTypeChanged(
        timestamp: DateTime.now(),
        roomId: _currentRoomId ?? '',
        participantId: targetId,
        cameraType: type.toString(),
      ),
    );
  }

  @override
  void setParticipantVideoEnabled({
    required String targetId,
    required bool isEnabled,
  }) {
    if (_remoteSubscribers[targetId]?.isVideoEnabled == isEnabled) return;

    _remoteSubscribers[targetId]!.isVideoEnabled = isEnabled;
    _notifyParticipantEvent(
      ParticipantVideoEnabledChanged(
        timestamp: DateTime.now(),
        roomId: _currentRoomId ?? '',
        participantId: targetId,
        isEnabled: isEnabled,
      ),
    );
  }

  @override
  void setParticipantAudioEnabled({
    required String targetId,
    required bool isEnabled,
  }) {
    if (_remoteSubscribers[targetId]?.isAudioEnabled == isEnabled) return;

    _remoteSubscribers[targetId]!.isAudioEnabled = isEnabled;

    _notifyParticipantEvent(
      ParticipantAudioEnabledChanged(
        timestamp: DateTime.now(),
        roomId: _currentRoomId ?? '',
        participantId: targetId,
        isEnabled: isEnabled,
      ),
    );
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
      _notifyParticipantEvent(
        ParticipantScreenSharingChanged(
          timestamp: DateTime.now(),
          roomId: _currentRoomId ?? '',
          participantId: config.participantId,
          isSharing: config.isSharing,
          screenTrackId: config.screenTrackId,
        ),
      );
    }
  }

  @override
  Future<void> setParticipantE2ee({
    required ParticipantE2eeConfig config,
  }) async {
    if (_remoteSubscribers[config.targetId] != null) {
      _remoteSubscribers[config.targetId]!.isE2eeEnabled = config.isEnabled;
    }

    await _e2eeManager.addRtpReceiver(
      receiver: config.receiver,
      codec:
          _remoteSubscribers[config.targetId]?.videoCodec ?? RTCVideoCodec.h264,
      enabled: config.isEnabled,
    );
  }

  // ====== Event streams ======
  @override
  Stream<RoomEvent> get roomEvents {
    return _eventSystem.roomEvents;
  }

  @override
  Stream<ParticipantEvent> get participantEvents {
    return _eventSystem.participantEvents;
  }

  @override
  Stream<TrackEvent> get trackEvents {
    return _eventSystem.trackEvents;
  }

  @override
  Stream<ConnectionEvent> get connectionEvents {
    return _eventSystem.connectionEvents;
  }

  @override
  Stream<MessageEvent> get messageEvents {
    return _eventSystem.messageEvents;
  }

  @override
  Stream<T> on<T>() {
    return _eventSystem.on<T>();
  }

  @override
  RoomState get roomState {
    return RoomState(
      localParticipant: _localParticipant,
      remoteParticipants: _remoteSubscribers,
    );
  }

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
    IceServersResponse iceServers = kIceServers;

    if (_connectionType == ConnectionType.p2p) {
      iceServers = await _authRepository.getIceServers();
    }

    final RTCPeerConnection pc = await createPeerConnection(
      RTCConfigurations.configuration(
        isE2eeEnabled ?? _currentCallSetting.e2eeEnabled,
        iceServers: iceServers,
      ),
      constraints,
    );

    return pc;
  }

  Future<void> _establishPublisher() async {
    final RTCPeerConnection peerConnection = _localParticipant!.peerConnection;

    peerConnection.onIceCandidate = (candidate) {
      if (_canPublisherAddIceCandidate) {
        _wsEmitter.sendPublisherIceCandidate(
          candidate: candidate,
          connectionType: _connectionType,
          roomId: _currentRoomId!,
        );
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
        isSingleTrack: _connectionType == ConnectionType.p2p,
      );

      senders.add(sender);

      if (track.kind == RtcTrackKind.audio.kind) {
        _audioStats.setSender = AudioStatsParams(
          receivers: [],
          ownerId: kIsMine,
          pc: peerConnection,
          callBack: (audioLevel) {
            _localParticipant = _localParticipant?.sinkAudioLevel(audioLevel);
          },
        );
      } else {
        _videoStats.addSenders(
          ownerId: '$kIsMine-${TrackType.webcam.toString()}',
          senders: [sender],
          callback: (stats) {
            _localParticipant?.sinkWebcamStats(stats);
          },
        );
      }
    }

    await _applyEncryption(_currentCallSetting.e2eeEnabled, senders: senders);

    String sdp = await _createOfferSdp(peerConnection);

    if (_localCameraStream?.getVideoTracks().isNotEmpty ?? false) {
      sdp = sdp.optimizeSdp(
        codec: _currentCallSetting.videoConfig.preferedCodec,
        isP2P: _connectionType == ConnectionType.p2p,
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
      isVideoEnabled: _localParticipant?.isVideoEnabled ?? false,
      isAudioEnabled: _localParticipant?.isAudioEnabled ?? false,
      isE2eeEnabled: _localParticipant?.isE2eeEnabled ?? false,
      connectionType: _connectionType,
      streamingProtocol: StreamingProtocol.sfu,
      isIpv6Supported: _isIpv6Supported,
    );

    _wsEmitter.publishRoom(payload: payload);

    if (WebRTC.platformIsLinux) return;

    _videoStats.initialize();
    _audioStats.initialize();
  }

  void _establishSubscriber(String targetId) {
    if (_currentRoomId == null || _currentParticipantId == null) return;

    final SubscribePayload payload = SubscribePayload(
      roomId: _currentRoomId ?? "",
      participantId: _currentParticipantId ?? "",
      targetId: targetId,
      isIpv6Supported: _isIpv6Supported,
    );

    _wsEmitter.subscribeRoom(payload: payload);
  }

  // ======== Migrate connection between P2P and SFU ========
  Future<void> _migrateConnection() async {
    _iceCandidateQueueForPublisher.clear();
    _remoteIceCandidatesForPublisher.clear();
    _canPublisherAddIceCandidate = false;
    final pc = await _createPeerConnection(
      constraints: RTCConfigurations.offerPublisherSdpConstraints,
    );

    if (_connectionType == ConnectionType.sfu) {
      _localParticipant =
          await _localParticipant?.createTrackQualityChannel(pc: pc);
    }

    _localParticipant!.backupPc = pc;

    pc.onIceCandidate = (candidate) {
      if (_canPublisherAddIceCandidate) {
        _wsEmitter.sendPublisherIceCandidate(
          candidate: candidate,
          connectionType: _connectionType,
          roomId: _currentRoomId!,
        );
      } else {
        _iceCandidateQueueForPublisher.add(candidate);
      }
    };

    pc.onConnectionState = (state) {
      if (state == RTCPeerConnectionState.RTCPeerConnectionStateConnected) {
        // Stop p2p connection after 10s since sfu connected
        // to ensure other participants migrate silently
        Future.delayed(10.seconds, () async {
          final p2pPeerConnection = _localParticipant?.peerConnection;

          _localParticipant!.peerConnection = pc;
          _localParticipant!.backupPc = null;

          await p2pPeerConnection?.close();
        });
      }
    };

    final List<MediaStreamTrack> streamTracks =
        _screenSharingStream?.getTracks() ?? [];
    final List<MediaStreamTrack> tracks = _localCameraStream?.getTracks() ?? [];
    final List<RTCRtpSender> senders = [];

    tracks.addAll(streamTracks);

    for (final track in tracks) {
      final sender = await pc.addSimulcastTrack(
        track,
        vCodec: _currentCallSetting.videoConfig.preferedCodec,
        stream: _localCameraStream!,
        kind: track.kind == RtcTrackKind.video.kind
            ? RtcTrackKind.video
            : RtcTrackKind.audio,
        isSingleTrack: _connectionType == ConnectionType.p2p,
      );

      senders.add(sender);

      if (track.kind == RtcTrackKind.audio.kind) {
        _audioStats.setSender = AudioStatsParams(
          receivers: [],
          ownerId: kIsMine,
          pc: pc,
          callBack: (audioLevel) {
            _localParticipant = _localParticipant?.sinkAudioLevel(audioLevel);
          },
        );
      } else {
        _videoStats.addSenders(
          ownerId: '$kIsMine-${TrackType.webcam.toString()}',
          senders: [sender],
          callback: (stats) {
            _localParticipant?.sinkWebcamStats(stats);
          },
        );
      }
    }

    await _applyEncryption(_currentCallSetting.e2eeEnabled, senders: senders);

    String sdp = await _createOfferSdp(pc);

    if (_localCameraStream?.getVideoTracks().isNotEmpty ?? false) {
      sdp = sdp.optimizeSdp(
        codec: _currentCallSetting.videoConfig.preferedCodec,
        isP2P: _connectionType == ConnectionType.p2p,
      );
    }

    final RTCSessionDescription description = RTCSessionDescription(
      sdp,
      DescriptionType.offer.type,
    );

    await pc.setLocalDescription(description);

    _wsEmitter.migrateConnection(
      roomId: _currentRoomId!,
      participantId: _currentParticipantId!,
      sdp: sdp,
      connectionType: _connectionType,
    );
  }

  void _setConnectionType(
    ConnectionType connectionType, {
    bool needMigrate = false,
  }) {
    if (_connectionType == connectionType) return;

    _connectionType = connectionType;

    if (needMigrate) {
      scheduleMicrotask(() async {
        await _migrateConnection();
      });
    }
  }

  void _resetRoomState() {
    _currentRoomId = null;
    _currentParticipantId = null;
    _iceCandidateQueueForPublisher.clear();
    _remoteIceCandidatesForPublisher.clear();
    _iceCandidateQueueForSubscribers.clear();
    _canPublisherAddIceCandidate = false;
    _nativeService.endCallKit();
    _connectionType = ConnectionType.p2p;
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

    final isMigrate = _remoteSubscribers.containsKey(targetId);

    _remoteSubscribers[targetId] ??= RemoteParticipant.init(
      ownerId: targetId,
      peerConnection: rtcPeerConnection,
      onFirstFrameRendered: () => _notifyRoomEvent(
        RoomStateChanged(
          timestamp: DateTime.now(),
          roomId: _currentRoomId ?? '',
        ),
      ),
      isAudioEnabled: payload.audioEnabled,
      isVideoEnabled: payload.videoEnabled,
      isSharingScreen: payload.isScreenSharing,
      isE2eeEnabled: payload.isE2eeEnabled,
      isHandRaising: payload.isHandRaising,
      screenTrackId: payload.screenTrackId,
      cameraType: payload.type,
      videoCodec: payload.codec,
      connectionType: _connectionType,
    );

    if (isMigrate) {
      if (_remoteSubscribers[targetId] != null) {
        _remoteSubscribers[targetId]!.backupPc = rtcPeerConnection;
        _remoteSubscribers[targetId]!.connectionType = _connectionType;
      }

      rtcPeerConnection.onConnectionState = (state) async {
        if (state == RTCPeerConnectionState.RTCPeerConnectionStateConnected ||
            _remoteSubscribers[targetId]?.backupPc != null) {
          if (_remoteSubscribers[targetId] != null) {
            _remoteSubscribers[targetId]!.peerConnection = rtcPeerConnection;
            _remoteSubscribers[targetId]!.backupPc = null;
          }
        }
      };
    }

    if (_connectionType == ConnectionType.sfu) {
      _remoteSubscribers[targetId] =
          await _remoteSubscribers[targetId]!.createTrackQualityChannel();
    }

    rtcPeerConnection.onTrack = (track) {
      if (!_remoteSubscribers.containsKey(targetId)) return;

      if (track.streams.isEmpty) return;

      Future.microtask(() async {
        if (track.receiver == null) return;
        final ParticipantE2eeConfig config = ParticipantE2eeConfig(
          receiver: track.receiver!,
          targetId: targetId,
          isEnabled: payload.isE2eeEnabled,
        );

        await setParticipantE2ee(config: config);

        final TrackType? type = _remoteSubscribers[targetId]?.setSrcObject(
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

        _notifyRoomEvent(
          RoomStateChanged(
            timestamp: DateTime.now(),
            roomId: _currentRoomId ?? '',
          ),
        );
      });
    };

    rtcPeerConnection.onIceCandidate = (candidate) {
      _wsEmitter.sendSubscriberIceCandidate(
        candidate: candidate,
        targetId: targetId,
        connectionType: _connectionType,
        roomId: _currentRoomId!,
      );
    };

    rtcPeerConnection.setRemoteDescription(remoteDescription);

    final String sdp = await _createAnswerSdp(rtcPeerConnection);
    final RTCSessionDescription description = RTCSessionDescription(
      sdp,
      DescriptionType.answer.type,
    );
    await rtcPeerConnection.setLocalDescription(description);

    _wsEmitter.answerSubscription(
      roomId: _currentRoomId!,
      targetId: targetId,
      sdp: sdp,
      connectionType: _connectionType,
    );

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
        await _localParticipant!.peerConnection.getSenders();

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

    if (newStream != null) _localParticipant?.setSrcObject(newStream);
    _localCameraStream = newStream;
  }

  Future<void> _replaceAudioTrack(
    MediaStreamTrack track, {
    List<RTCRtpSender>? sendersList,
  }) async {
    final List<RTCRtpSender> senders =
        (sendersList ?? await _localParticipant!.peerConnection.getSenders())
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
        (sendersList ?? await _localParticipant!.peerConnection.getSenders())
            .where(
              (sender) => sender.track?.kind == RtcTrackKind.video.kind,
            )
            .toList();

    if (senders.isEmpty) return;

    final sender = senders.first;

    await sender.replaceTrack(track);

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

    _localParticipant!.isE2eeEnabled = enabled;
  }

  // ======== Renegotiation Flow ========
  Future<void> _performRenegotiation() async {
    final pc = _localParticipant?.peerConnection;

    if (pc == null) return;

    String sdp = await _createOfferSdp(pc);

    if (_localCameraStream?.getVideoTracks().isNotEmpty ?? false) {
      sdp = sdp.optimizeSdp(
        codec: _currentCallSetting.videoConfig.preferedCodec,
        isP2P: _connectionType == ConnectionType.p2p,
      );
    }

    final RTCSessionDescription description = RTCSessionDescription(
      sdp,
      DescriptionType.offer.type,
    );

    await pc.setLocalDescription(description);

    _wsEmitter.renegotiateSdp(
      sdp: sdp,
      roomId: _currentRoomId!,
      connectionType: _connectionType,
    );
  }

  // ======== New Event Notification Methods ========
  void _notifyRoomEvent(
    RoomEvent event,
  ) {
    _eventSystem.emitRoomEvent(event);
  }

  void _notifyParticipantEvent(
    ParticipantEvent event,
  ) {
    _eventSystem.emitParticipantEvent(event);
  }
}
