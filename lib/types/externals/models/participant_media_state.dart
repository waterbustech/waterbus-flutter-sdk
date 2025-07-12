import 'dart:async';
import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';
import 'package:waterbus_sdk/types/internals/enums/connection_type.dart';
import 'package:waterbus_sdk/types/internals/enums/index.dart';
import 'package:waterbus_sdk/types/internals/models/track_quality.dart';
import 'package:waterbus_sdk/types/internals/models/track_subscribed_message.dart';
import 'package:waterbus_sdk/utils/logger/logger.dart';

part 'participant_media_state.freezed.dart';

@freezed
abstract class ParticipantMediaState with _$ParticipantMediaState {
  const factory ParticipantMediaState({
    required String ownerId,
    @Default(true) bool isVideoEnabled,
    @Default(true) bool isAudioEnabled,
    @Default(false) bool isSharingScreen,
    @Default(false) bool isE2eeEnabled,
    @Default(true) bool isSpeakerPhoneEnabled,
    @Default(false) bool isHandRaising,
    @Default(CameraType.front) CameraType cameraType,
    required RTCPeerConnection peerConnection,
    required Function()? onFirstFrameRendered,
    required RTCVideoCodec videoCodec,
    @Default(AudioLevel.kSilence) AudioLevel audioLevel,
    MediaSource? cameraSource,
    MediaSource? screenSource,
    StreamController<AudioLevel>? audioLevelController,
    StreamController<RtcParticipantStats>? webcamStatsController,
    StreamController<RtcParticipantStats>? screenStatsController,
    String? screenTrackId,
    required ConnectionType connectionType,
    RTCDataChannel? trackQualityChannel,

    // ==== Backup variables for migrate case ====
    RTCPeerConnection? backupPc,
  }) = _ParticipantMediaState;

  factory ParticipantMediaState.init({
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

    return ParticipantMediaState(
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
      audioLevelController:
          audioLevelController ?? StreamController<AudioLevel>.broadcast(),
      webcamStatsController: webcamStatsController ??
          StreamController<RtcParticipantStats>.broadcast(),
      screenStatsController: screenStatsController ??
          StreamController<RtcParticipantStats>.broadcast(),
      connectionType: connectionType,
    );
  }
}

extension ParticipantSFUX on ParticipantMediaState {
  bool get isMe => ownerId == kIsMine;

  Future<ParticipantMediaState> createTrackQualityChannel({
    RTCPeerConnection? pc,
  }) async {
    final peerConnection = pc ?? this.peerConnection;

    final channelInit = RTCDataChannelInit()
      ..ordered = true
      ..binaryType = 'binary'
      ..maxRetransmits = 30;

    peerConnection.onDataChannel = (dc) {
      if (dc.label == "track_quality") {
        final updated = copyWith(trackQualityChannel: dc);
        if (isMe) {
          updated.listenTrackQualityChannel();
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

    final updatedState = copyWith(trackQualityChannel: channel);

    return updatedState;
  }

  void listenTrackQualityChannel() {
    if (trackQualityChannel == null) return;

    trackQualityChannel!.onMessage = (message) {
      WaterbusLogger.instance.log(
        "[track_quality] 🔥 Received message (binary: ${message.isBinary})",
      );

      final data = message.binary;
      final String jsonStr = utf8.decode(data);
      final TrackSubscribedMessage msg = TrackSubscribedMessage.fromJson(
        jsonDecode(jsonStr),
      );

      WaterbusLogger.instance.log(
        "[track_quality] 📦 Decoded: ${msg.toString()}",
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

  ParticipantMediaState sinkAudioLevel(AudioLevel level) {
    if (level == audioLevel) return this;

    audioLevelController?.sink.add(level);

    return copyWith(audioLevel: level);
  }

  void sinkWebcamStats(RtcParticipantStats stats) {
    webcamStatsController?.sink.add(stats);
  }

  void sinkScreenStats(RtcParticipantStats stats) {
    screenStatsController?.sink.add(stats);
  }

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

  ParticipantMediaState get switchCamera {
    if (cameraType == CameraType.front) {
      return copyWith(cameraType: CameraType.rear);
    } else {
      return copyWith(cameraType: CameraType.front);
    }
  }

  TrackType? setSrcObject(
    MediaStream stream, {
    String? trackId,
    bool isDisplayStream = false,
  }) {
    if (ownerId == kIsMine) {
      if (isDisplayStream) {
        screenSource?.setSrcObject(stream);
      } else {
        cameraSource?.setSrcObject(stream);
      }

      return null;
    }

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

  Future<ParticipantMediaState> setScreenSharing(
    bool isSharing, {
    String? screenTrackId,
  }) async {
    ParticipantMediaState mediaState =
        copyWith(isSharingScreen: isSharing, screenTrackId: screenTrackId);

    if (!isSharing) {
      await screenSource?.dispose();
      mediaState = mediaState.copyWith(
        screenSource: MediaSource(onFirstFrameRendered: onFirstFrameRendered),
      );
    }

    return mediaState;
  }

  ParticipantMediaState setHandRaising(bool isRaising) {
    return copyWith(isHandRaising: isRaising);
  }

  Future<void> dispose() async {
    setScreenSharing(false);
    cameraSource?.dispose();
    screenSource?.dispose();
    peerConnection.close();
    backupPc?.close();
    audioLevelController?.close();
    webcamStatsController?.close();
    screenStatsController?.close();
    trackQualityChannel?.close();
  }
}

extension ParticipantSFUPublic on ParticipantMediaState {
  Stream<AudioLevel>? get audioLevelStream => audioLevelController?.stream;

  Stream<RtcParticipantStats>? get webcamStatsStream =>
      webcamStatsController?.stream;

  Stream<RtcParticipantStats>? get screenStatsStream =>
      screenStatsController?.stream;
}
