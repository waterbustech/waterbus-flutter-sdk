import 'package:equatable/equatable.dart';

import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';
import 'package:waterbus_sdk/stats/webrtc_audio_stats.dart';
import 'package:waterbus_sdk/stats/webrtc_video_stats.dart';
import 'package:waterbus_sdk/types/enums/audio_level.dart';
import 'package:waterbus_sdk/utils/extensions/peer_extensions.dart';
import 'package:waterbus_sdk/utils/logger/logger.dart';

// ignore: must_be_immutable
class ParticipantSFU extends Equatable {
  final String ownerId;
  bool isVideoEnabled;
  bool isAudioEnabled;
  bool isE2eeEnabled;
  bool isSpeakerPhoneEnabled;
  bool isSharingScreen;
  bool isHandRaising;
  CameraType cameraType;
  AudioLevel audioLevel;
  MediaSource? cameraSource;
  MediaSource? screenSource;
  RTCPeerConnection peerConnection;
  final WebRTCCodec videoCodec;
  final Function()? onFirstFrameRendered;
  ParticipantSFU({
    required this.ownerId,
    this.isVideoEnabled = true,
    this.isAudioEnabled = true,
    this.isSharingScreen = false,
    this.isE2eeEnabled = false,
    this.isSpeakerPhoneEnabled = true,
    this.isHandRaising = false,
    this.cameraType = CameraType.front,
    this.audioLevel = AudioLevel.kSilence,
    required this.peerConnection,
    required this.onFirstFrameRendered,
    required this.videoCodec,
    // use only one time
    WebRTCVideoStats? stats,
    WebRTCAudioStats? audioStats,
    bool isMe = false,
    this.cameraSource,
    this.screenSource,
  }) {
    if (cameraSource != null || screenSource != null) return;

    cameraSource = MediaSource(onFirstFrameRendered: onFirstFrameRendered);
    screenSource = MediaSource(onFirstFrameRendered: onFirstFrameRendered);

    if (stats != null && audioStats != null) {
      peerConnection.monitorStats(
        stats,
        isMe: isMe,
        id: peerConnection.peerConnectionId,
        audioStats: audioStats,
        onLevelChanged: (level) {
          if (level == audioLevel) return;

          audioLevel = level;
          onFirstFrameRendered?.call();
        },
      );
    }
  }

  @override
  String toString() {
    return 'ParticipantSFU(isMicEnabled: $isVideoEnabled, isCamEnabled: $isAudioEnabled, isSharingScreen: $isSharingScreen, peerConnection: $peerConnection)';
  }

  @override
  bool operator ==(covariant ParticipantSFU other) {
    if (identical(this, other)) return true;

    return other.isVideoEnabled == isVideoEnabled &&
        other.isAudioEnabled == isAudioEnabled &&
        other.isHandRaising == isHandRaising &&
        other.isSharingScreen == isSharingScreen &&
        other.peerConnection == peerConnection &&
        other.cameraSource == cameraSource &&
        other.screenSource == screenSource;
  }

  @override
  int get hashCode {
    return isVideoEnabled.hashCode ^
        isAudioEnabled.hashCode ^
        isHandRaising.hashCode ^
        isSharingScreen.hashCode ^
        peerConnection.hashCode ^
        cameraSource.hashCode ^
        screenSource.hashCode;
  }

  @override
  List<Object> get props {
    return [
      isVideoEnabled,
      isAudioEnabled,
      isHandRaising,
      isE2eeEnabled,
      isSpeakerPhoneEnabled,
      isSharingScreen,
      cameraType,
      audioLevel,
      peerConnection,
      videoCodec,
    ];
  }

  ParticipantSFU copyWith({
    String? ownerId,
    bool? isVideoEnabled,
    bool? isAudioEnabled,
    bool? isHandRaising,
    bool? isE2eeEnabled,
    bool? isSpeakerPhoneEnabled,
    bool? isSharingScreen,
    CameraType? cameraType,
    AudioLevel? audioLevel,
    RTCPeerConnection? peerConnection,
    WebRTCCodec? videoCodec,
    Function()? onFirstFrameRendered,
    MediaSource? cameraSource,
    MediaSource? screenSource,
  }) {
    return ParticipantSFU(
      ownerId: ownerId ?? this.ownerId,
      isVideoEnabled: isVideoEnabled ?? this.isVideoEnabled,
      isAudioEnabled: isAudioEnabled ?? this.isAudioEnabled,
      isHandRaising: isHandRaising ?? this.isHandRaising,
      isE2eeEnabled: isE2eeEnabled ?? this.isE2eeEnabled,
      isSpeakerPhoneEnabled:
          isSpeakerPhoneEnabled ?? this.isSpeakerPhoneEnabled,
      isSharingScreen: isSharingScreen ?? this.isSharingScreen,
      cameraType: cameraType ?? this.cameraType,
      audioLevel: audioLevel ?? this.audioLevel,
      peerConnection: peerConnection ?? this.peerConnection,
      videoCodec: videoCodec ?? this.videoCodec,
      onFirstFrameRendered: onFirstFrameRendered ?? this.onFirstFrameRendered,
      cameraSource: cameraSource ?? this.cameraSource,
      screenSource: screenSource ?? this.screenSource,
    );
  }
}

extension ParticipantSFUX on ParticipantSFU {
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

  void switchCamera() {
    if (cameraType == CameraType.front) {
      cameraType = CameraType.rear;
    } else {
      cameraType = CameraType.front;
    }
  }

  Future<void> setSrcObject(
    MediaStream stream, {
    bool isDisplayStream = false,
  }) async {
    if (ownerId == kIsMine) {
      if (isDisplayStream) {
        screenSource?.setSrcObject(stream);
      } else {
        cameraSource?.setSrcObject(stream);
      }
      return;
    }

    final videoTrackExists = cameraSource?.stream?.getVideoTracks().firstOrNull;
    final isSameStreamId =
        cameraSource != null && cameraSource?.streamId == stream.id;

    if (videoTrackExists == null || isSameStreamId) {
      // Set src camera
      cameraSource?.setSrcObject(stream);
    } else {
      // Set src screen
      screenSource?.setSrcObject(stream);
    }
  }

  Future<void> setScreenSharing(bool isSharing) async {
    isSharingScreen = isSharing;

    if (!isSharing) {
      await screenSource?.dispose();
      screenSource = MediaSource(onFirstFrameRendered: onFirstFrameRendered);
    }
  }

  Future<void> setHandRaising(bool isRaising) async {
    isHandRaising = isRaising;
  }

  Future<void> dispose() async {
    setScreenSharing(false);
    cameraSource?.dispose();
    peerConnection.close();
  }
}
