import 'dart:async';

import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';
import 'package:waterbus_sdk/utils/logger/logger.dart';

part 'participant_sfu.freezed.dart';

@freezed
abstract class ParticipantSFU with _$ParticipantSFU {
  const factory ParticipantSFU({
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
  }) = _ParticipantSFU;

  factory ParticipantSFU.init({
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
  }) {
    final hasCustomSources = cameraSource != null || screenSource != null;

    return ParticipantSFU(
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
    );
  }
}

extension ParticipantSFUX on ParticipantSFU {
  ParticipantSFU sinkAudioLevel(AudioLevel level) {
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
      await peerConnection.addCandidate(candidate);
    } catch (error) {
      WaterbusLogger.instance.bug("====> E: ${error.toString()}");
    }
  }

  Future<void> setRemoteDescription(RTCSessionDescription description) async {
    try {
      await peerConnection.setRemoteDescription(description);
    } catch (error) {
      WaterbusLogger.instance.bug(error.toString());
    }
  }

  ParticipantSFU get switchCamera {
    if (cameraType == CameraType.front) {
      return copyWith(cameraType: CameraType.rear);
    } else {
      return copyWith(cameraType: CameraType.front);
    }
  }

  Future<TrackType?> setSrcObject(
    MediaStream stream, {
    String? trackId,
    bool isDisplayStream = false,
  }) async {
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

  Future<ParticipantSFU> setScreenSharing(
    bool isSharing, {
    String? screenTrackId,
  }) async {
    ParticipantSFU participantSFU =
        copyWith(isSharingScreen: isSharing, screenTrackId: screenTrackId);

    if (!isSharing) {
      await screenSource?.dispose();
      participantSFU = copyWith(
        screenSource: MediaSource(onFirstFrameRendered: onFirstFrameRendered),
      );
    }

    return participantSFU;
  }

  Future<ParticipantSFU> setHandRaising(bool isRaising) async {
    return copyWith(isHandRaising: isRaising);
  }

  Future<void> dispose() async {
    setScreenSharing(false);
    cameraSource?.dispose();
    peerConnection.close();
    audioLevelController?.close();
    webcamStatsController?.close();
    screenStatsController?.close();
  }
}

extension ParticipantSFUPublic on ParticipantSFU {
  Stream<AudioLevel>? get audioLevelStream => audioLevelController?.stream;

  Stream<RtcParticipantStats>? get webcamStatsStream =>
      webcamStatsController?.stream;

  Stream<RtcParticipantStats>? get screenStatsStream =>
      screenStatsController?.stream;
}
