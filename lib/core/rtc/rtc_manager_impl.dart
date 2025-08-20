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

part 'rtc_manager_private.dart';

@LazySingleton(as: RtcManager)
class RtcManagerIpml extends RtcManager {
  final EncryptionManager _encryptionManager;
  final WsEmitter _wsEmitter;
  final ReplayKitChannel _replayKitChannel;
  final NativeService _nativeService;
  final RtcVideoStats _videoStats;
  final RtcAudioStats _audioStats;
  final AuthRepository _authRepository;
  RtcManagerIpml(
    this._encryptionManager,
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
  final Map<String, ParticipantInfo> _participants = {};

  // ====== Room Management ======
  @override
  Future<void> joinRoom({
    required String roomId,
    required ParticipantInfo participant,
    required ConnectionType connectionType,
  }) async {
    _connectionType = connectionType;

    await Future.wait([
      _encryptionManager.initialize(
        roomId,
        codec: _currentCallSetting.videoConfig.preferedCodec,
        participantId: participant.id.toString(),
        enabled: _currentCallSetting.e2eeEnabled,
      ),
      initializeMediaDevices(),
    ]);

    if (_localParticipant?.peerConnection == null) return;

    _localParticipant?.info = participant;

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
    _currentParticipantId = participant.id.toString();

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
  void subscribeToParticipants(List<ParticipantInfo> participants) {
    for (final participant in participants) {
      _participants[participant.id.toString()] = participant;
      scheduleMicrotask(() => _establishSubscriber(participant.id.toString()));
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
      _encryptionManager.dispose();

      _notifyRoomEvent(
        RoomEnded(
          timestamp: DateTime.now(),
          roomId: _currentRoomId ?? '',
        ),
      );

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

    _participants[participantId] = participant;

    scheduleMicrotask(() => _establishSubscriber(participantId));

    _notifyParticipantEvent(
      ParticipantJoined(
        timestamp: DateTime.now(),
        roomId: _currentRoomId ?? '',
        participantId: participant.id.toString(),
        participant: participant,
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
      info: _localParticipant?.info ?? ParticipantInfo(id: 0),
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
        _encryptionManager.addRtpSender(sender: sender),
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

    await _encryptionManager.addRtpReceiver(
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
}
