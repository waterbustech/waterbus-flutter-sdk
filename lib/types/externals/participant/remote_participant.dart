import 'dart:async';

import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';
import 'package:waterbus_sdk/types/externals/rtc/channel_event.dart';
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

  RTCPeerConnection _peerConnection;

  @override
  RTCPeerConnection get peerConnection => _peerConnection;

  RTCDataChannel? _dataChannel;

  @override
  RTCDataChannel? get dataChannel => _dataChannel;

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
  String? screenMid;

  // @override
  ConnectionType _connectionType;

  @override
  ConnectionType get connectionType => _connectionType;

  @override
  set connectionType(ConnectionType value) {
    _connectionType = value;
  }

  @override
  RTCPeerConnection? backupPc;

  @override
  ParticipantInfo info;

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
    required RTCDataChannel? dataChannel,
    this.onFirstFrameRendered,
    required this.videoCodec,
    this.audioLevel = AudioLevel.kSilence,
    this.cameraSource,
    this.screenSource,
    this.audioLevelController,
    this.webcamStatsController,
    this.screenStatsController,
    this.screenMid,
    required ConnectionType connectionType,
    this.backupPc,
    required this.info,
  })  : _peerConnection = peerConnection,
        _dataChannel = dataChannel,
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
    required ParticipantInfo info,
  }) {
    final hasCustomSources = cameraSource != null || screenSource != null;

    final participant = RemoteParticipant(
      ownerId: ownerId,
      isVideoEnabled: isVideoEnabled,
      isAudioEnabled: isAudioEnabled,
      isSharingScreen: isSharingScreen,
      isE2eeEnabled: isE2eeEnabled,
      isSpeakerPhoneEnabled: isSpeakerPhoneEnabled,
      isHandRaising: isHandRaising,
      screenMid: screenTrackId,
      cameraType: cameraType,
      cameraSource: hasCustomSources
          ? cameraSource
          : MediaSource(onFirstFrameRendered: onFirstFrameRendered),
      screenSource: hasCustomSources
          ? screenSource
          : MediaSource(onFirstFrameRendered: onFirstFrameRendered),
      peerConnection: peerConnection,
      dataChannel: null,
      videoCodec: videoCodec,
      onFirstFrameRendered: onFirstFrameRendered,
      audioLevel: audioLevel,
      audioLevelController: audioLevelController,
      webcamStatsController: webcamStatsController,
      screenStatsController: screenStatsController,
      connectionType: connectionType,
      info: info,
    );

    participant._createDataChannel();

    return participant;
  }

  void _createDataChannel() {
    peerConnection.onDataChannel = (channel) {
      _dataChannel = channel;
      listenDataChannel();
    };
  }

  @override
  void listenDataChannel() {
    _dataChannel?.onMessage = (message) async {
      final ChannelEvent event = ChannelEvent.fromBinary(message.binary);

      if (event is Renegotitate) {
        if (event.mid != null) {
          screenMid = event.mid;
        }

        await setRemoteDescription(
          RTCSessionDescription(
            event.sdp,
            DescriptionType.offer.type,
          ),
        );

        final offer = await (backupPc ?? peerConnection).createAnswer();

        await (backupPc ?? peerConnection).setLocalDescription(offer);

        if (offer.sdp == null) return;

        final renegotitate = Renegotitate(sdp: offer.sdp!);

        _dataChannel?.send(
          RTCDataChannelMessage.fromBinary(renegotitate.toBinary()),
        );
      }
    };

    _dataChannel?.onDataChannelState = (state) {
      WaterbusLogger.instance.log("[subscriber-channel] State changed: $state");
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
      WaterbusLogger.instance.bug(error.toString());
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
    /// P2P: mid is the mid of the track
    String? mid,

    /// SFU: trackId is the mid of the track
    String? trackId,
    bool isDisplayStream = false,
  }) {
    if (screenMid != null && (mid == screenMid || trackId == screenMid)) {
      // Set src screen
      screenSource?.setSrcObject(stream);
      screenSource?.mid = trackId;
      return TrackType.screen;
    } else {
      // Set src camera
      cameraSource?.setSrcObject(stream);
      cameraSource?.mid = mid;
      return TrackType.webcam;
    }
  }

  @override
  Future<RemoteParticipant> setScreenSharing(
    bool isSharing, {
    String? screenMid,
  }) async {
    isSharingScreen = isSharing;
    this.screenMid = screenMid;

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
    dataChannel?.close();
    peerConnection.close();
    backupPc?.close();
    audioLevelController?.close();
    webcamStatsController?.close();
    screenStatsController?.close();
  }

  @override
  Stream<AudioLevel>? get audioLevelStream => audioLevelController?.stream;

  @override
  Stream<RtcParticipantStats>? get webcamStatsStream =>
      webcamStatsController?.stream;

  @override
  Stream<RtcParticipantStats>? get screenStatsStream =>
      screenStatsController?.stream;

  RemoteParticipant copyWith({
    String? ownerId,
    bool? isVideoEnabled,
    bool? isAudioEnabled,
    bool? isSharingScreen,
    bool? isE2eeEnabled,
    bool? isSpeakerPhoneEnabled,
    bool? isHandRaising,
    CameraType? cameraType,
    RTCPeerConnection? peerConnection,
    RTCDataChannel? dataChannel,
    Function()? onFirstFrameRendered,
    RTCVideoCodec? videoCodec,
    AudioLevel? audioLevel,
    MediaSource? cameraSource,
    MediaSource? screenSource,
    StreamController<AudioLevel>? audioLevelController,
    StreamController<RtcParticipantStats>? webcamStatsController,
    StreamController<RtcParticipantStats>? screenStatsController,
    String? screenMid,
    ConnectionType? connectionType,
    RTCPeerConnection? backupPc,
    ParticipantInfo? info,
  }) {
    return RemoteParticipant(
      ownerId: ownerId ?? this.ownerId,
      isVideoEnabled: isVideoEnabled ?? this.isVideoEnabled,
      isAudioEnabled: isAudioEnabled ?? this.isAudioEnabled,
      isSharingScreen: isSharingScreen ?? this.isSharingScreen,
      isE2eeEnabled: isE2eeEnabled ?? this.isE2eeEnabled,
      isSpeakerPhoneEnabled:
          isSpeakerPhoneEnabled ?? this.isSpeakerPhoneEnabled,
      isHandRaising: isHandRaising ?? this.isHandRaising,
      cameraType: cameraType ?? this.cameraType,
      peerConnection: peerConnection ?? this.peerConnection,
      dataChannel: dataChannel ?? this.dataChannel,
      onFirstFrameRendered: onFirstFrameRendered ?? this.onFirstFrameRendered,
      videoCodec: videoCodec ?? this.videoCodec,
      audioLevel: audioLevel ?? this.audioLevel,
      cameraSource: cameraSource ?? this.cameraSource,
      screenSource: screenSource ?? this.screenSource,
      audioLevelController: audioLevelController ?? this.audioLevelController,
      webcamStatsController:
          webcamStatsController ?? this.webcamStatsController,
      screenStatsController:
          screenStatsController ?? this.screenStatsController,
      screenMid: screenMid ?? this.screenMid,
      connectionType: connectionType ?? this.connectionType,
      backupPc: backupPc ?? this.backupPc,
      info: info ?? this.info,
    );
  }
}
