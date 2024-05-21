// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/foundation.dart';

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
  bool hasFirstFrameRendered;
  CameraType cameraType;
  AudioLevel audioLevel;
  RTCVideoRenderer? renderer;
  RTCVideoRenderer? screenShareRenderer;
  MediaStream? mediaStream;
  final RTCPeerConnection peerConnection;
  final WebRTCCodec videoCodec;
  final Function() onChanged;
  ParticipantSFU({
    required this.ownerId,
    this.isVideoEnabled = true,
    this.isAudioEnabled = true,
    this.isSharingScreen = false,
    this.hasFirstFrameRendered = false,
    this.isE2eeEnabled = false,
    this.isSpeakerPhoneEnabled = true,
    this.cameraType = CameraType.front,
    this.audioLevel = AudioLevel.kSilence,
    this.mediaStream,
    this.renderer,
    this.screenShareRenderer,
    required this.peerConnection,
    required this.onChanged,
    required this.videoCodec,
    // use only one time
    WebRTCVideoStats? stats,
    WebRTCAudioStats? audioStats,
    bool isMe = false,
  }) {
    _initialRenderer();

    if (stats != null && audioStats != null) {
      peerConnection.monitorStats(
        stats,
        isMe: isMe,
        id: peerConnection.peerConnectionId,
        audioStats: audioStats,
        onLevelChanged: (level) {
          if (level == audioLevel) return;

          audioLevel = level;
          onChanged();
        },
      );
    }
  }

  @override
  String toString() {
    return 'ParticipantSFU(isMicEnabled: $isVideoEnabled, isCamEnabled: $isAudioEnabled, isSharingScreen: $isSharingScreen, peerConnection: $peerConnection, renderer: $renderer)';
  }

  @override
  bool operator ==(covariant ParticipantSFU other) {
    if (identical(this, other)) return true;

    return other.isVideoEnabled == isVideoEnabled &&
        other.isAudioEnabled == isAudioEnabled &&
        other.isSharingScreen == isSharingScreen &&
        other.peerConnection == peerConnection &&
        other.hasFirstFrameRendered == hasFirstFrameRendered &&
        other.renderer == renderer;
  }

  @override
  int get hashCode {
    return isVideoEnabled.hashCode ^
        isAudioEnabled.hashCode ^
        isSharingScreen.hashCode ^
        hasFirstFrameRendered.hashCode ^
        peerConnection.hashCode ^
        renderer.hashCode;
  }

  @override
  List<Object> get props {
    return [
      isVideoEnabled,
      isAudioEnabled,
      isE2eeEnabled,
      isSpeakerPhoneEnabled,
      isSharingScreen,
      hasFirstFrameRendered,
      cameraType,
      audioLevel,
      peerConnection,
      videoCodec,
      onChanged,
    ];
  }

  ParticipantSFU copyWith({
    String? ownerId,
    bool? isVideoEnabled,
    bool? isAudioEnabled,
    bool? isE2eeEnabled,
    bool? isSpeakerPhoneEnabled,
    bool? isSharingScreen,
    bool? hasFirstFrameRendered,
    CameraType? cameraType,
    AudioLevel? audioLevel,
    RTCVideoRenderer? renderer,
    RTCVideoRenderer? screenShareRenderer,
    RTCPeerConnection? peerConnection,
    WebRTCCodec? videoCodec,
    Function()? onChanged,
  }) {
    return ParticipantSFU(
      ownerId: ownerId ?? this.ownerId,
      isVideoEnabled: isVideoEnabled ?? this.isVideoEnabled,
      isAudioEnabled: isAudioEnabled ?? this.isAudioEnabled,
      isE2eeEnabled: isE2eeEnabled ?? this.isE2eeEnabled,
      isSpeakerPhoneEnabled:
          isSpeakerPhoneEnabled ?? this.isSpeakerPhoneEnabled,
      isSharingScreen: isSharingScreen ?? this.isSharingScreen,
      hasFirstFrameRendered:
          hasFirstFrameRendered ?? this.hasFirstFrameRendered,
      cameraType: cameraType ?? this.cameraType,
      audioLevel: audioLevel ?? this.audioLevel,
      renderer: renderer ?? this.renderer,
      screenShareRenderer: screenShareRenderer ?? this.screenShareRenderer,
      peerConnection: peerConnection ?? this.peerConnection,
      videoCodec: videoCodec ?? this.videoCodec,
      onChanged: onChanged ?? this.onChanged,
    );
  }
}

extension ParticipantSFUX on ParticipantSFU {
  Future<void> dispose() async {
    renderer?.dispose();
    peerConnection.close();
  }

  Future<void> addCandidate(RTCIceCandidate candidate) async {
    await peerConnection.addCandidate(candidate);
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

  Future<void> setSrcObject(MediaStream stream) async {
    if (ownerId == kIsMine) {
      renderer?.srcObject = stream;
      onChanged.call();
      return;
    }

    if (renderer?.srcObject?.getVideoTracks().isEmpty ?? true) {
      renderer?.srcObject = stream;
    } else {
      await setScreenSrcObject(stream);
    }

    onChanged.call();
  }

  Future<void> setScreenSrcObject(MediaStream stream, {String? trackId}) async {
    if (screenShareRenderer == null) {
      screenShareRenderer = RTCVideoRenderer();
      await screenShareRenderer?.initialize();
    }

    screenShareRenderer?.srcObject = stream;
  }

  Future<void> _initialRenderer() async {
    if (renderer != null) return;

    renderer = RTCVideoRenderer();

    await renderer?.initialize();

    if (kIsWeb) {
      hasFirstFrameRendered = true;

      onChanged.call();
    }

    renderer?.onFirstFrameRendered = () {
      hasFirstFrameRendered = true;

      onChanged.call();
    };
  }
}
