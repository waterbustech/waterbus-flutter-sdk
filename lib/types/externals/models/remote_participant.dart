import 'dart:async';
import 'dart:convert';

import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';
import 'package:waterbus_sdk/types/internals/enums/connection_type.dart';
import 'package:waterbus_sdk/types/internals/enums/index.dart';
import 'package:waterbus_sdk/types/internals/models/track_quality.dart';
import 'package:waterbus_sdk/types/internals/models/track_subscribed_message.dart';
import 'package:waterbus_sdk/utils/logger/logger.dart';

class RemoteParticipant implements Participant {
  @override
  String ownerId;

  @override
  bool isVideoEnabled;

  @override
  bool isAudioEnabled;

  @override
  bool isSharingScreen;

  @override
  bool isE2eeEnabled;

  @override
  bool isSpeakerPhoneEnabled;

  @override
  bool isHandRaising;

  @override
  CameraType cameraType;

  // @override
  RTCPeerConnection _peerConnection;

  @override
  RTCPeerConnection get peerConnection => _peerConnection;

  @override
  set peerConnection(RTCPeerConnection value) {
    _peerConnection = value;
  }

  @override
  Function()? onFirstFrameRendered;

  @override
  RTCVideoCodec videoCodec;

  @override
  AudioLevel audioLevel;

  @override
  MediaSource? cameraSource;

  @override
  MediaSource? screenSource;

  @override
  StreamController<AudioLevel>? audioLevelController;

  @override
  StreamController<RtcParticipantStats>? webcamStatsController;

  @override
  StreamController<RtcParticipantStats>? screenStatsController;

  @override
  String? screenTrackId;

  // @override
  ConnectionType _connectionType;

  @override
  ConnectionType get connectionType => _connectionType;

  @override
  set connectionType(ConnectionType value) {
    _connectionType = value;
  }

  @override
  RTCDataChannel? trackQualityChannel;

  @override
  RTCPeerConnection? backupPc;

  RemoteParticipant({
    required this.ownerId,
    this.isVideoEnabled = true,
    this.isAudioEnabled = true,
    this.isSharingScreen = false,
    this.isE2eeEnabled = false,
    this.isSpeakerPhoneEnabled = true,
    this.isHandRaising = false,
    this.cameraType = CameraType.front,
    required RTCPeerConnection peerConnection,
    this.onFirstFrameRendered,
    required this.videoCodec,
    this.audioLevel = AudioLevel.kSilence,
    this.cameraSource,
    this.screenSource,
    this.audioLevelController,
    this.webcamStatsController,
    this.screenStatsController,
    this.screenTrackId,
    required ConnectionType connectionType,
    this.trackQualityChannel,
    this.backupPc,
  })  : _peerConnection = peerConnection,
        _connectionType = connectionType {
    // Initialize controllers if not provided
    audioLevelController ??= StreamController<AudioLevel>.broadcast();
    webcamStatsController ??= StreamController<RtcParticipantStats>.broadcast();
    screenStatsController ??= StreamController<RtcParticipantStats>.broadcast();

    // Initialize media sources if not provided
    cameraSource ??= MediaSource(onFirstFrameRendered: onFirstFrameRendered);
    screenSource ??= MediaSource(onFirstFrameRendered: onFirstFrameRendered);
  }

  factory RemoteParticipant.init({
    required String ownerId,
    bool isVideoEnabled = true,
    bool isAudioEnabled = true,
    bool isSharingScreen = false,
    bool isE2eeEnabled = false,
    bool isSpeakerPhoneEnabled = true,
    bool isHandRaising = false,
    String? screenTrackId,
    CameraType cameraType = CameraType.front,
    MediaSource? cameraSource,
    MediaSource? screenSource,
    required RTCPeerConnection peerConnection,
    required RTCVideoCodec videoCodec,
    required Function()? onFirstFrameRendered,
    AudioLevel audioLevel = AudioLevel.kSilence,
    StreamController<AudioLevel>? audioLevelController,
    StreamController<RtcParticipantStats>? webcamStatsController,
    StreamController<RtcParticipantStats>? screenStatsController,
    required ConnectionType connectionType,
  }) {
    final hasCustomSources = cameraSource != null || screenSource != null;

    return RemoteParticipant(
      ownerId: ownerId,
      isVideoEnabled: isVideoEnabled,
      isAudioEnabled: isAudioEnabled,
      isSharingScreen: isSharingScreen,
      isE2eeEnabled: isE2eeEnabled,
      isSpeakerPhoneEnabled: isSpeakerPhoneEnabled,
      isHandRaising: isHandRaising,
      screenTrackId: screenTrackId,
      cameraType: cameraType,
      cameraSource: hasCustomSources
          ? cameraSource
          : MediaSource(onFirstFrameRendered: onFirstFrameRendered),
      screenSource: hasCustomSources
          ? screenSource
          : MediaSource(onFirstFrameRendered: onFirstFrameRendered),
      peerConnection: peerConnection,
      videoCodec: videoCodec,
      onFirstFrameRendered: onFirstFrameRendered,
      audioLevel: audioLevel,
      audioLevelController: audioLevelController,
      webcamStatsController: webcamStatsController,
      screenStatsController: screenStatsController,
      connectionType: connectionType,
    );
  }

  @override
  bool get isMe => ownerId == kIsMine;

  @override
  Future<RemoteParticipant> createTrackQualityChannel({
    RTCPeerConnection? pc,
  }) async {
    final peerConnection = pc ?? this.peerConnection;

    final channelInit = RTCDataChannelInit()
      ..ordered = true
      ..binaryType = 'binary'
      ..maxRetransmits = 30;

    peerConnection.onDataChannel = (dc) {
      if (dc.label == "track_quality") {
        trackQualityChannel = dc;
        if (isMe) {
          listenTrackQualityChannel();
        }
      }
    };

    final channel = await peerConnection.createDataChannel(
      "track_quality",
      channelInit,
    );

    if (!isMe) {
      cameraSource?.trackQualityChannel = channel;
      screenSource?.trackQualityChannel = channel;
    }

    trackQualityChannel = channel;

    return this;
  }

  @override
  void listenTrackQualityChannel() {
    if (trackQualityChannel == null) return;

    trackQualityChannel!.onMessage = (message) {
      WaterbusLogger.instance.log(
        "[track_quality] received message (binary: ${message.isBinary})",
      );

      final data = message.binary;
      final String jsonStr = utf8.decode(data);
      final TrackSubscribedMessage msg = TrackSubscribedMessage.fromJson(
        jsonDecode(jsonStr),
      );

      if (msg.trackId == cameraSource?.getVideoTrackId) {
        cameraSource?.setRidActive(msg.quality.rid, msg.subscribedCount > 0);
      } else if (msg.trackId == screenSource?.getVideoTrackId) {
        screenSource?.setRidActive(msg.quality.rid, msg.subscribedCount > 0);
      }
    };

    trackQualityChannel!.onDataChannelState = (state) {
      WaterbusLogger.instance.log("[track_quality] State changed: $state");
    };
  }

  @override
  RemoteParticipant sinkAudioLevel(AudioLevel level) {
    if (level == audioLevel) return this;

    audioLevelController?.sink.add(level);
    audioLevel = level;

    return this;
  }

  @override
  void sinkWebcamStats(RtcParticipantStats stats) {
    webcamStatsController?.sink.add(stats);
  }

  @override
  void sinkScreenStats(RtcParticipantStats stats) {
    screenStatsController?.sink.add(stats);
  }

  @override
  Future<void> addCandidate(RTCIceCandidate candidate) async {
    try {
      if (backupPc != null) {
        await backupPc?.addCandidate(candidate);
      } else {
        await peerConnection.addCandidate(candidate);
      }
    } catch (error) {
      WaterbusLogger.instance.bug("====> E: ${error.toString()}");
    }
  }

  @override
  Future<void> setRemoteDescription(RTCSessionDescription description) async {
    try {
      if (backupPc != null) {
        await backupPc?.setRemoteDescription(description);
      } else {
        await peerConnection.setRemoteDescription(description);
      }
    } catch (error) {
      WaterbusLogger.instance.bug(error.toString());
    }
  }

  @override
  RemoteParticipant get switchCamera {
    if (cameraType == CameraType.front) {
      cameraType = CameraType.rear;
    } else {
      cameraType = CameraType.front;
    }
    return this;
  }

  @override
  TrackType? setSrcObject(
    MediaStream stream, {
    String? trackId,
    bool isDisplayStream = false,
  }) {
    if (screenTrackId != null && trackId == screenTrackId) {
      // Set src screen
      screenSource?.setSrcObject(stream);
      return TrackType.screen;
    } else {
      // Set src camera
      cameraSource?.setSrcObject(stream);
      return TrackType.webcam;
    }
  }

  @override
  Future<RemoteParticipant> setScreenSharing(
    bool isSharing, {
    String? screenTrackId,
  }) async {
    isSharingScreen = isSharing;
    this.screenTrackId = screenTrackId;

    if (!isSharing) {
      await screenSource?.dispose();
      screenSource = MediaSource(onFirstFrameRendered: onFirstFrameRendered);
    }

    return this;
  }

  @override
  RemoteParticipant setHandRaising(bool isRaising) {
    isHandRaising = isRaising;
    return this;
  }

  @override
  Future<void> dispose() async {
    await setScreenSharing(false);
    await cameraSource?.dispose();
    await screenSource?.dispose();
    peerConnection.close();
    backupPc?.close();
    audioLevelController?.close();
    webcamStatsController?.close();
    screenStatsController?.close();
    trackQualityChannel?.close();
  }

  @override
  Stream<AudioLevel>? get audioLevelStream => audioLevelController?.stream;

  @override
  Stream<RtcParticipantStats>? get webcamStatsStream =>
      webcamStatsController?.stream;

  @override
  Stream<RtcParticipantStats>? get screenStatsStream =>
      screenStatsController?.stream;
}
