// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'participant_media_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ParticipantMediaState {
  String get ownerId;
  bool get isVideoEnabled;
  bool get isAudioEnabled;
  bool get isSharingScreen;
  bool get isE2eeEnabled;
  bool get isSpeakerPhoneEnabled;
  bool get isHandRaising;
  CameraType get cameraType;
  RTCPeerConnection get peerConnection;
  Function()? get onFirstFrameRendered;
  RTCVideoCodec get videoCodec;
  AudioLevel get audioLevel;
  MediaSource? get cameraSource;
  MediaSource? get screenSource;
  StreamController<AudioLevel>? get audioLevelController;
  StreamController<RtcParticipantStats>? get webcamStatsController;
  StreamController<RtcParticipantStats>? get screenStatsController;
  String? get screenTrackId;
  ConnectionType
      get connectionType; // ==== Backup variables for migrate case ====
  RTCPeerConnection? get backupPc;

  /// Create a copy of ParticipantMediaState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ParticipantMediaStateCopyWith<ParticipantMediaState> get copyWith =>
      _$ParticipantMediaStateCopyWithImpl<ParticipantMediaState>(
          this as ParticipantMediaState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ParticipantMediaState &&
            (identical(other.ownerId, ownerId) || other.ownerId == ownerId) &&
            (identical(other.isVideoEnabled, isVideoEnabled) ||
                other.isVideoEnabled == isVideoEnabled) &&
            (identical(other.isAudioEnabled, isAudioEnabled) ||
                other.isAudioEnabled == isAudioEnabled) &&
            (identical(other.isSharingScreen, isSharingScreen) ||
                other.isSharingScreen == isSharingScreen) &&
            (identical(other.isE2eeEnabled, isE2eeEnabled) ||
                other.isE2eeEnabled == isE2eeEnabled) &&
            (identical(other.isSpeakerPhoneEnabled, isSpeakerPhoneEnabled) ||
                other.isSpeakerPhoneEnabled == isSpeakerPhoneEnabled) &&
            (identical(other.isHandRaising, isHandRaising) ||
                other.isHandRaising == isHandRaising) &&
            (identical(other.cameraType, cameraType) ||
                other.cameraType == cameraType) &&
            (identical(other.peerConnection, peerConnection) ||
                other.peerConnection == peerConnection) &&
            (identical(other.onFirstFrameRendered, onFirstFrameRendered) ||
                other.onFirstFrameRendered == onFirstFrameRendered) &&
            (identical(other.videoCodec, videoCodec) ||
                other.videoCodec == videoCodec) &&
            (identical(other.audioLevel, audioLevel) ||
                other.audioLevel == audioLevel) &&
            (identical(other.cameraSource, cameraSource) ||
                other.cameraSource == cameraSource) &&
            (identical(other.screenSource, screenSource) ||
                other.screenSource == screenSource) &&
            (identical(other.audioLevelController, audioLevelController) ||
                other.audioLevelController == audioLevelController) &&
            (identical(other.webcamStatsController, webcamStatsController) ||
                other.webcamStatsController == webcamStatsController) &&
            (identical(other.screenStatsController, screenStatsController) ||
                other.screenStatsController == screenStatsController) &&
            (identical(other.screenTrackId, screenTrackId) ||
                other.screenTrackId == screenTrackId) &&
            (identical(other.connectionType, connectionType) ||
                other.connectionType == connectionType) &&
            (identical(other.backupPc, backupPc) ||
                other.backupPc == backupPc));
  }

  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        ownerId,
        isVideoEnabled,
        isAudioEnabled,
        isSharingScreen,
        isE2eeEnabled,
        isSpeakerPhoneEnabled,
        isHandRaising,
        cameraType,
        peerConnection,
        onFirstFrameRendered,
        videoCodec,
        audioLevel,
        cameraSource,
        screenSource,
        audioLevelController,
        webcamStatsController,
        screenStatsController,
        screenTrackId,
        connectionType,
        backupPc
      ]);

  @override
  String toString() {
    return 'ParticipantMediaState(ownerId: $ownerId, isVideoEnabled: $isVideoEnabled, isAudioEnabled: $isAudioEnabled, isSharingScreen: $isSharingScreen, isE2eeEnabled: $isE2eeEnabled, isSpeakerPhoneEnabled: $isSpeakerPhoneEnabled, isHandRaising: $isHandRaising, cameraType: $cameraType, peerConnection: $peerConnection, onFirstFrameRendered: $onFirstFrameRendered, videoCodec: $videoCodec, audioLevel: $audioLevel, cameraSource: $cameraSource, screenSource: $screenSource, audioLevelController: $audioLevelController, webcamStatsController: $webcamStatsController, screenStatsController: $screenStatsController, screenTrackId: $screenTrackId, connectionType: $connectionType, backupPc: $backupPc)';
  }
}

/// @nodoc
abstract mixin class $ParticipantMediaStateCopyWith<$Res> {
  factory $ParticipantMediaStateCopyWith(ParticipantMediaState value,
          $Res Function(ParticipantMediaState) _then) =
      _$ParticipantMediaStateCopyWithImpl;
  @useResult
  $Res call(
      {String ownerId,
      bool isVideoEnabled,
      bool isAudioEnabled,
      bool isSharingScreen,
      bool isE2eeEnabled,
      bool isSpeakerPhoneEnabled,
      bool isHandRaising,
      CameraType cameraType,
      RTCPeerConnection peerConnection,
      Function()? onFirstFrameRendered,
      RTCVideoCodec videoCodec,
      AudioLevel audioLevel,
      MediaSource? cameraSource,
      MediaSource? screenSource,
      StreamController<AudioLevel>? audioLevelController,
      StreamController<RtcParticipantStats>? webcamStatsController,
      StreamController<RtcParticipantStats>? screenStatsController,
      String? screenTrackId,
      ConnectionType connectionType,
      RTCPeerConnection? backupPc});
}

/// @nodoc
class _$ParticipantMediaStateCopyWithImpl<$Res>
    implements $ParticipantMediaStateCopyWith<$Res> {
  _$ParticipantMediaStateCopyWithImpl(this._self, this._then);

  final ParticipantMediaState _self;
  final $Res Function(ParticipantMediaState) _then;

  /// Create a copy of ParticipantMediaState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? ownerId = null,
    Object? isVideoEnabled = null,
    Object? isAudioEnabled = null,
    Object? isSharingScreen = null,
    Object? isE2eeEnabled = null,
    Object? isSpeakerPhoneEnabled = null,
    Object? isHandRaising = null,
    Object? cameraType = null,
    Object? peerConnection = null,
    Object? onFirstFrameRendered = freezed,
    Object? videoCodec = null,
    Object? audioLevel = null,
    Object? cameraSource = freezed,
    Object? screenSource = freezed,
    Object? audioLevelController = freezed,
    Object? webcamStatsController = freezed,
    Object? screenStatsController = freezed,
    Object? screenTrackId = freezed,
    Object? connectionType = null,
    Object? backupPc = freezed,
  }) {
    return _then(_self.copyWith(
      ownerId: null == ownerId
          ? _self.ownerId
          : ownerId // ignore: cast_nullable_to_non_nullable
              as String,
      isVideoEnabled: null == isVideoEnabled
          ? _self.isVideoEnabled
          : isVideoEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      isAudioEnabled: null == isAudioEnabled
          ? _self.isAudioEnabled
          : isAudioEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      isSharingScreen: null == isSharingScreen
          ? _self.isSharingScreen
          : isSharingScreen // ignore: cast_nullable_to_non_nullable
              as bool,
      isE2eeEnabled: null == isE2eeEnabled
          ? _self.isE2eeEnabled
          : isE2eeEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      isSpeakerPhoneEnabled: null == isSpeakerPhoneEnabled
          ? _self.isSpeakerPhoneEnabled
          : isSpeakerPhoneEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      isHandRaising: null == isHandRaising
          ? _self.isHandRaising
          : isHandRaising // ignore: cast_nullable_to_non_nullable
              as bool,
      cameraType: null == cameraType
          ? _self.cameraType
          : cameraType // ignore: cast_nullable_to_non_nullable
              as CameraType,
      peerConnection: null == peerConnection
          ? _self.peerConnection
          : peerConnection // ignore: cast_nullable_to_non_nullable
              as RTCPeerConnection,
      onFirstFrameRendered: freezed == onFirstFrameRendered
          ? _self.onFirstFrameRendered
          : onFirstFrameRendered // ignore: cast_nullable_to_non_nullable
              as Function()?,
      videoCodec: null == videoCodec
          ? _self.videoCodec
          : videoCodec // ignore: cast_nullable_to_non_nullable
              as RTCVideoCodec,
      audioLevel: null == audioLevel
          ? _self.audioLevel
          : audioLevel // ignore: cast_nullable_to_non_nullable
              as AudioLevel,
      cameraSource: freezed == cameraSource
          ? _self.cameraSource
          : cameraSource // ignore: cast_nullable_to_non_nullable
              as MediaSource?,
      screenSource: freezed == screenSource
          ? _self.screenSource
          : screenSource // ignore: cast_nullable_to_non_nullable
              as MediaSource?,
      audioLevelController: freezed == audioLevelController
          ? _self.audioLevelController
          : audioLevelController // ignore: cast_nullable_to_non_nullable
              as StreamController<AudioLevel>?,
      webcamStatsController: freezed == webcamStatsController
          ? _self.webcamStatsController
          : webcamStatsController // ignore: cast_nullable_to_non_nullable
              as StreamController<RtcParticipantStats>?,
      screenStatsController: freezed == screenStatsController
          ? _self.screenStatsController
          : screenStatsController // ignore: cast_nullable_to_non_nullable
              as StreamController<RtcParticipantStats>?,
      screenTrackId: freezed == screenTrackId
          ? _self.screenTrackId
          : screenTrackId // ignore: cast_nullable_to_non_nullable
              as String?,
      connectionType: null == connectionType
          ? _self.connectionType
          : connectionType // ignore: cast_nullable_to_non_nullable
              as ConnectionType,
      backupPc: freezed == backupPc
          ? _self.backupPc
          : backupPc // ignore: cast_nullable_to_non_nullable
              as RTCPeerConnection?,
    ));
  }
}

/// @nodoc

class _ParticipantMediaState implements ParticipantMediaState {
  const _ParticipantMediaState(
      {required this.ownerId,
      this.isVideoEnabled = true,
      this.isAudioEnabled = true,
      this.isSharingScreen = false,
      this.isE2eeEnabled = false,
      this.isSpeakerPhoneEnabled = true,
      this.isHandRaising = false,
      this.cameraType = CameraType.front,
      required this.peerConnection,
      required this.onFirstFrameRendered,
      required this.videoCodec,
      this.audioLevel = AudioLevel.kSilence,
      this.cameraSource,
      this.screenSource,
      this.audioLevelController,
      this.webcamStatsController,
      this.screenStatsController,
      this.screenTrackId,
      required this.connectionType,
      this.backupPc});

  @override
  final String ownerId;
  @override
  @JsonKey()
  final bool isVideoEnabled;
  @override
  @JsonKey()
  final bool isAudioEnabled;
  @override
  @JsonKey()
  final bool isSharingScreen;
  @override
  @JsonKey()
  final bool isE2eeEnabled;
  @override
  @JsonKey()
  final bool isSpeakerPhoneEnabled;
  @override
  @JsonKey()
  final bool isHandRaising;
  @override
  @JsonKey()
  final CameraType cameraType;
  @override
  final RTCPeerConnection peerConnection;
  @override
  final Function()? onFirstFrameRendered;
  @override
  final RTCVideoCodec videoCodec;
  @override
  @JsonKey()
  final AudioLevel audioLevel;
  @override
  final MediaSource? cameraSource;
  @override
  final MediaSource? screenSource;
  @override
  final StreamController<AudioLevel>? audioLevelController;
  @override
  final StreamController<RtcParticipantStats>? webcamStatsController;
  @override
  final StreamController<RtcParticipantStats>? screenStatsController;
  @override
  final String? screenTrackId;
  @override
  final ConnectionType connectionType;
// ==== Backup variables for migrate case ====
  @override
  final RTCPeerConnection? backupPc;

  /// Create a copy of ParticipantMediaState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ParticipantMediaStateCopyWith<_ParticipantMediaState> get copyWith =>
      __$ParticipantMediaStateCopyWithImpl<_ParticipantMediaState>(
          this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ParticipantMediaState &&
            (identical(other.ownerId, ownerId) || other.ownerId == ownerId) &&
            (identical(other.isVideoEnabled, isVideoEnabled) ||
                other.isVideoEnabled == isVideoEnabled) &&
            (identical(other.isAudioEnabled, isAudioEnabled) ||
                other.isAudioEnabled == isAudioEnabled) &&
            (identical(other.isSharingScreen, isSharingScreen) ||
                other.isSharingScreen == isSharingScreen) &&
            (identical(other.isE2eeEnabled, isE2eeEnabled) ||
                other.isE2eeEnabled == isE2eeEnabled) &&
            (identical(other.isSpeakerPhoneEnabled, isSpeakerPhoneEnabled) ||
                other.isSpeakerPhoneEnabled == isSpeakerPhoneEnabled) &&
            (identical(other.isHandRaising, isHandRaising) ||
                other.isHandRaising == isHandRaising) &&
            (identical(other.cameraType, cameraType) ||
                other.cameraType == cameraType) &&
            (identical(other.peerConnection, peerConnection) ||
                other.peerConnection == peerConnection) &&
            (identical(other.onFirstFrameRendered, onFirstFrameRendered) ||
                other.onFirstFrameRendered == onFirstFrameRendered) &&
            (identical(other.videoCodec, videoCodec) ||
                other.videoCodec == videoCodec) &&
            (identical(other.audioLevel, audioLevel) ||
                other.audioLevel == audioLevel) &&
            (identical(other.cameraSource, cameraSource) ||
                other.cameraSource == cameraSource) &&
            (identical(other.screenSource, screenSource) ||
                other.screenSource == screenSource) &&
            (identical(other.audioLevelController, audioLevelController) ||
                other.audioLevelController == audioLevelController) &&
            (identical(other.webcamStatsController, webcamStatsController) ||
                other.webcamStatsController == webcamStatsController) &&
            (identical(other.screenStatsController, screenStatsController) ||
                other.screenStatsController == screenStatsController) &&
            (identical(other.screenTrackId, screenTrackId) ||
                other.screenTrackId == screenTrackId) &&
            (identical(other.connectionType, connectionType) ||
                other.connectionType == connectionType) &&
            (identical(other.backupPc, backupPc) ||
                other.backupPc == backupPc));
  }

  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        ownerId,
        isVideoEnabled,
        isAudioEnabled,
        isSharingScreen,
        isE2eeEnabled,
        isSpeakerPhoneEnabled,
        isHandRaising,
        cameraType,
        peerConnection,
        onFirstFrameRendered,
        videoCodec,
        audioLevel,
        cameraSource,
        screenSource,
        audioLevelController,
        webcamStatsController,
        screenStatsController,
        screenTrackId,
        connectionType,
        backupPc
      ]);

  @override
  String toString() {
    return 'ParticipantMediaState(ownerId: $ownerId, isVideoEnabled: $isVideoEnabled, isAudioEnabled: $isAudioEnabled, isSharingScreen: $isSharingScreen, isE2eeEnabled: $isE2eeEnabled, isSpeakerPhoneEnabled: $isSpeakerPhoneEnabled, isHandRaising: $isHandRaising, cameraType: $cameraType, peerConnection: $peerConnection, onFirstFrameRendered: $onFirstFrameRendered, videoCodec: $videoCodec, audioLevel: $audioLevel, cameraSource: $cameraSource, screenSource: $screenSource, audioLevelController: $audioLevelController, webcamStatsController: $webcamStatsController, screenStatsController: $screenStatsController, screenTrackId: $screenTrackId, connectionType: $connectionType, backupPc: $backupPc)';
  }
}

/// @nodoc
abstract mixin class _$ParticipantMediaStateCopyWith<$Res>
    implements $ParticipantMediaStateCopyWith<$Res> {
  factory _$ParticipantMediaStateCopyWith(_ParticipantMediaState value,
          $Res Function(_ParticipantMediaState) _then) =
      __$ParticipantMediaStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String ownerId,
      bool isVideoEnabled,
      bool isAudioEnabled,
      bool isSharingScreen,
      bool isE2eeEnabled,
      bool isSpeakerPhoneEnabled,
      bool isHandRaising,
      CameraType cameraType,
      RTCPeerConnection peerConnection,
      Function()? onFirstFrameRendered,
      RTCVideoCodec videoCodec,
      AudioLevel audioLevel,
      MediaSource? cameraSource,
      MediaSource? screenSource,
      StreamController<AudioLevel>? audioLevelController,
      StreamController<RtcParticipantStats>? webcamStatsController,
      StreamController<RtcParticipantStats>? screenStatsController,
      String? screenTrackId,
      ConnectionType connectionType,
      RTCPeerConnection? backupPc});
}

/// @nodoc
class __$ParticipantMediaStateCopyWithImpl<$Res>
    implements _$ParticipantMediaStateCopyWith<$Res> {
  __$ParticipantMediaStateCopyWithImpl(this._self, this._then);

  final _ParticipantMediaState _self;
  final $Res Function(_ParticipantMediaState) _then;

  /// Create a copy of ParticipantMediaState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? ownerId = null,
    Object? isVideoEnabled = null,
    Object? isAudioEnabled = null,
    Object? isSharingScreen = null,
    Object? isE2eeEnabled = null,
    Object? isSpeakerPhoneEnabled = null,
    Object? isHandRaising = null,
    Object? cameraType = null,
    Object? peerConnection = null,
    Object? onFirstFrameRendered = freezed,
    Object? videoCodec = null,
    Object? audioLevel = null,
    Object? cameraSource = freezed,
    Object? screenSource = freezed,
    Object? audioLevelController = freezed,
    Object? webcamStatsController = freezed,
    Object? screenStatsController = freezed,
    Object? screenTrackId = freezed,
    Object? connectionType = null,
    Object? backupPc = freezed,
  }) {
    return _then(_ParticipantMediaState(
      ownerId: null == ownerId
          ? _self.ownerId
          : ownerId // ignore: cast_nullable_to_non_nullable
              as String,
      isVideoEnabled: null == isVideoEnabled
          ? _self.isVideoEnabled
          : isVideoEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      isAudioEnabled: null == isAudioEnabled
          ? _self.isAudioEnabled
          : isAudioEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      isSharingScreen: null == isSharingScreen
          ? _self.isSharingScreen
          : isSharingScreen // ignore: cast_nullable_to_non_nullable
              as bool,
      isE2eeEnabled: null == isE2eeEnabled
          ? _self.isE2eeEnabled
          : isE2eeEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      isSpeakerPhoneEnabled: null == isSpeakerPhoneEnabled
          ? _self.isSpeakerPhoneEnabled
          : isSpeakerPhoneEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      isHandRaising: null == isHandRaising
          ? _self.isHandRaising
          : isHandRaising // ignore: cast_nullable_to_non_nullable
              as bool,
      cameraType: null == cameraType
          ? _self.cameraType
          : cameraType // ignore: cast_nullable_to_non_nullable
              as CameraType,
      peerConnection: null == peerConnection
          ? _self.peerConnection
          : peerConnection // ignore: cast_nullable_to_non_nullable
              as RTCPeerConnection,
      onFirstFrameRendered: freezed == onFirstFrameRendered
          ? _self.onFirstFrameRendered
          : onFirstFrameRendered // ignore: cast_nullable_to_non_nullable
              as Function()?,
      videoCodec: null == videoCodec
          ? _self.videoCodec
          : videoCodec // ignore: cast_nullable_to_non_nullable
              as RTCVideoCodec,
      audioLevel: null == audioLevel
          ? _self.audioLevel
          : audioLevel // ignore: cast_nullable_to_non_nullable
              as AudioLevel,
      cameraSource: freezed == cameraSource
          ? _self.cameraSource
          : cameraSource // ignore: cast_nullable_to_non_nullable
              as MediaSource?,
      screenSource: freezed == screenSource
          ? _self.screenSource
          : screenSource // ignore: cast_nullable_to_non_nullable
              as MediaSource?,
      audioLevelController: freezed == audioLevelController
          ? _self.audioLevelController
          : audioLevelController // ignore: cast_nullable_to_non_nullable
              as StreamController<AudioLevel>?,
      webcamStatsController: freezed == webcamStatsController
          ? _self.webcamStatsController
          : webcamStatsController // ignore: cast_nullable_to_non_nullable
              as StreamController<RtcParticipantStats>?,
      screenStatsController: freezed == screenStatsController
          ? _self.screenStatsController
          : screenStatsController // ignore: cast_nullable_to_non_nullable
              as StreamController<RtcParticipantStats>?,
      screenTrackId: freezed == screenTrackId
          ? _self.screenTrackId
          : screenTrackId // ignore: cast_nullable_to_non_nullable
              as String?,
      connectionType: null == connectionType
          ? _self.connectionType
          : connectionType // ignore: cast_nullable_to_non_nullable
              as ConnectionType,
      backupPc: freezed == backupPc
          ? _self.backupPc
          : backupPc // ignore: cast_nullable_to_non_nullable
              as RTCPeerConnection?,
    ));
  }
}

// dart format on
