// ignore_for_file: public_member_api_docs, sort_constructors_first

// Package imports:
import 'package:equatable/equatable.dart';

// Project imports:
import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';
import 'package:waterbus_sdk/helpers/extensions/peer_extensions.dart';
import 'package:waterbus_sdk/helpers/stats/webrtc_audio_stats.dart';
import 'package:waterbus_sdk/helpers/stats/webrtc_stats.dart';
import 'package:waterbus_sdk/models/enums/audio_level.dart';

// ignore: must_be_immutable
class ParticipantSFU extends Equatable {
  bool isVideoEnabled;
  bool isAudioEnabled;
  bool isE2eeEnabled;
  bool isSpeakerPhoneEnabled;
  bool isSharingScreen;
  bool hasFirstFrameRendered;
  CameraType cameraType;
  AudioLevel audioLevel;
  RTCVideoRenderer? renderer;
  final RTCPeerConnection peerConnection;
  final WebRTCCodec videoCodec;
  final Function() onChanged;
  ParticipantSFU({
    this.isVideoEnabled = true,
    this.isAudioEnabled = true,
    this.isSharingScreen = false,
    this.hasFirstFrameRendered = false,
    this.isE2eeEnabled = false,
    this.isSpeakerPhoneEnabled = true,
    this.cameraType = CameraType.front,
    this.audioLevel = AudioLevel.kSilence,
    this.renderer,
    required this.peerConnection,
    required this.onChanged,
    required this.videoCodec,
    // use only one time
    WebRTCStatsUtility? stats,
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

  ParticipantSFU copyWith({
    String? participantId,
    bool? isAudioEnabled,
    bool? isVideoEnabled,
    bool? isSharingScreen,
    bool? isE2eeEnabled,
    RTCPeerConnection? peerConnection,
    RTCVideoRenderer? renderer,
    WebRTCCodec? videoCodec,
  }) {
    return ParticipantSFU(
      isVideoEnabled: isAudioEnabled ?? this.isVideoEnabled,
      isAudioEnabled: isVideoEnabled ?? this.isAudioEnabled,
      isSharingScreen: isSharingScreen ?? this.isSharingScreen,
      peerConnection: peerConnection ?? this.peerConnection,
      renderer: renderer ?? this.renderer,
      onChanged: onChanged,
      videoCodec: videoCodec ?? this.videoCodec,
      isE2eeEnabled: isE2eeEnabled ?? this.isE2eeEnabled,
    );
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
    await peerConnection.setRemoteDescription(description);
  }

  void switchCamera() {
    if (cameraType == CameraType.front) {
      cameraType = CameraType.rear;
    } else {
      cameraType = CameraType.front;
    }
  }

  // ignore: use_setters_to_change_properties
  void setSrcObject(MediaStream stream) {
    renderer?.srcObject = stream;
  }

  Future<void> _initialRenderer() async {
    if (renderer != null) return;

    renderer = RTCVideoRenderer();
    await renderer?.initialize();

    renderer?.onFirstFrameRendered = () {
      hasFirstFrameRendered = true;

      onChanged.call();
    };
  }
}
