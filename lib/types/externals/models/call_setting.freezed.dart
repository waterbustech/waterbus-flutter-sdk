// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'call_setting.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CallSetting implements DiagnosticableTreeMixin {
  bool get isLowBandwidthMode;
  bool get isAudioMuted;
  bool get echoCancellationEnabled;
  bool get noiseSuppressionEnabled;
  bool get agcEnabled;
  bool get isVideoMuted;
  bool get e2eeEnabled;
  RTCVideoCodec get preferedCodec;
  VideoQuality get videoQuality;

  /// Create a copy of CallSetting
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CallSettingCopyWith<CallSetting> get copyWith =>
      _$CallSettingCopyWithImpl<CallSetting>(this as CallSetting, _$identity);

  /// Serializes this CallSetting to a JSON map.
  Map<String, dynamic> toJson();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
      ..add(DiagnosticsProperty('type', 'CallSetting'))
      ..add(DiagnosticsProperty('isLowBandwidthMode', isLowBandwidthMode))
      ..add(DiagnosticsProperty('isAudioMuted', isAudioMuted))
      ..add(DiagnosticsProperty(
          'echoCancellationEnabled', echoCancellationEnabled))
      ..add(DiagnosticsProperty(
          'noiseSuppressionEnabled', noiseSuppressionEnabled))
      ..add(DiagnosticsProperty('agcEnabled', agcEnabled))
      ..add(DiagnosticsProperty('isVideoMuted', isVideoMuted))
      ..add(DiagnosticsProperty('e2eeEnabled', e2eeEnabled))
      ..add(DiagnosticsProperty('preferedCodec', preferedCodec))
      ..add(DiagnosticsProperty('videoQuality', videoQuality));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CallSetting &&
            (identical(other.isLowBandwidthMode, isLowBandwidthMode) ||
                other.isLowBandwidthMode == isLowBandwidthMode) &&
            (identical(other.isAudioMuted, isAudioMuted) ||
                other.isAudioMuted == isAudioMuted) &&
            (identical(
                    other.echoCancellationEnabled, echoCancellationEnabled) ||
                other.echoCancellationEnabled == echoCancellationEnabled) &&
            (identical(
                    other.noiseSuppressionEnabled, noiseSuppressionEnabled) ||
                other.noiseSuppressionEnabled == noiseSuppressionEnabled) &&
            (identical(other.agcEnabled, agcEnabled) ||
                other.agcEnabled == agcEnabled) &&
            (identical(other.isVideoMuted, isVideoMuted) ||
                other.isVideoMuted == isVideoMuted) &&
            (identical(other.e2eeEnabled, e2eeEnabled) ||
                other.e2eeEnabled == e2eeEnabled) &&
            (identical(other.preferedCodec, preferedCodec) ||
                other.preferedCodec == preferedCodec) &&
            (identical(other.videoQuality, videoQuality) ||
                other.videoQuality == videoQuality));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      isLowBandwidthMode,
      isAudioMuted,
      echoCancellationEnabled,
      noiseSuppressionEnabled,
      agcEnabled,
      isVideoMuted,
      e2eeEnabled,
      preferedCodec,
      videoQuality);

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'CallSetting(isLowBandwidthMode: $isLowBandwidthMode, isAudioMuted: $isAudioMuted, echoCancellationEnabled: $echoCancellationEnabled, noiseSuppressionEnabled: $noiseSuppressionEnabled, agcEnabled: $agcEnabled, isVideoMuted: $isVideoMuted, e2eeEnabled: $e2eeEnabled, preferedCodec: $preferedCodec, videoQuality: $videoQuality)';
  }
}

/// @nodoc
abstract mixin class $CallSettingCopyWith<$Res> {
  factory $CallSettingCopyWith(
          CallSetting value, $Res Function(CallSetting) _then) =
      _$CallSettingCopyWithImpl;
  @useResult
  $Res call(
      {bool isLowBandwidthMode,
      bool isAudioMuted,
      bool echoCancellationEnabled,
      bool noiseSuppressionEnabled,
      bool agcEnabled,
      bool isVideoMuted,
      bool e2eeEnabled,
      RTCVideoCodec preferedCodec,
      VideoQuality videoQuality});
}

/// @nodoc
class _$CallSettingCopyWithImpl<$Res> implements $CallSettingCopyWith<$Res> {
  _$CallSettingCopyWithImpl(this._self, this._then);

  final CallSetting _self;
  final $Res Function(CallSetting) _then;

  /// Create a copy of CallSetting
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLowBandwidthMode = null,
    Object? isAudioMuted = null,
    Object? echoCancellationEnabled = null,
    Object? noiseSuppressionEnabled = null,
    Object? agcEnabled = null,
    Object? isVideoMuted = null,
    Object? e2eeEnabled = null,
    Object? preferedCodec = null,
    Object? videoQuality = null,
  }) {
    return _then(_self.copyWith(
      isLowBandwidthMode: null == isLowBandwidthMode
          ? _self.isLowBandwidthMode
          : isLowBandwidthMode // ignore: cast_nullable_to_non_nullable
              as bool,
      isAudioMuted: null == isAudioMuted
          ? _self.isAudioMuted
          : isAudioMuted // ignore: cast_nullable_to_non_nullable
              as bool,
      echoCancellationEnabled: null == echoCancellationEnabled
          ? _self.echoCancellationEnabled
          : echoCancellationEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      noiseSuppressionEnabled: null == noiseSuppressionEnabled
          ? _self.noiseSuppressionEnabled
          : noiseSuppressionEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      agcEnabled: null == agcEnabled
          ? _self.agcEnabled
          : agcEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      isVideoMuted: null == isVideoMuted
          ? _self.isVideoMuted
          : isVideoMuted // ignore: cast_nullable_to_non_nullable
              as bool,
      e2eeEnabled: null == e2eeEnabled
          ? _self.e2eeEnabled
          : e2eeEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      preferedCodec: null == preferedCodec
          ? _self.preferedCodec
          : preferedCodec // ignore: cast_nullable_to_non_nullable
              as RTCVideoCodec,
      videoQuality: null == videoQuality
          ? _self.videoQuality
          : videoQuality // ignore: cast_nullable_to_non_nullable
              as VideoQuality,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _CallSetting with DiagnosticableTreeMixin implements CallSetting {
  const _CallSetting(
      {this.isLowBandwidthMode = false,
      this.isAudioMuted = false,
      this.echoCancellationEnabled = true,
      this.noiseSuppressionEnabled = true,
      this.agcEnabled = true,
      this.isVideoMuted = false,
      this.e2eeEnabled = false,
      this.preferedCodec = RTCVideoCodec.h264,
      this.videoQuality = VideoQuality.high});
  factory _CallSetting.fromJson(Map<String, dynamic> json) =>
      _$CallSettingFromJson(json);

  @override
  @JsonKey()
  final bool isLowBandwidthMode;
  @override
  @JsonKey()
  final bool isAudioMuted;
  @override
  @JsonKey()
  final bool echoCancellationEnabled;
  @override
  @JsonKey()
  final bool noiseSuppressionEnabled;
  @override
  @JsonKey()
  final bool agcEnabled;
  @override
  @JsonKey()
  final bool isVideoMuted;
  @override
  @JsonKey()
  final bool e2eeEnabled;
  @override
  @JsonKey()
  final RTCVideoCodec preferedCodec;
  @override
  @JsonKey()
  final VideoQuality videoQuality;

  /// Create a copy of CallSetting
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$CallSettingCopyWith<_CallSetting> get copyWith =>
      __$CallSettingCopyWithImpl<_CallSetting>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$CallSettingToJson(
      this,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
      ..add(DiagnosticsProperty('type', 'CallSetting'))
      ..add(DiagnosticsProperty('isLowBandwidthMode', isLowBandwidthMode))
      ..add(DiagnosticsProperty('isAudioMuted', isAudioMuted))
      ..add(DiagnosticsProperty(
          'echoCancellationEnabled', echoCancellationEnabled))
      ..add(DiagnosticsProperty(
          'noiseSuppressionEnabled', noiseSuppressionEnabled))
      ..add(DiagnosticsProperty('agcEnabled', agcEnabled))
      ..add(DiagnosticsProperty('isVideoMuted', isVideoMuted))
      ..add(DiagnosticsProperty('e2eeEnabled', e2eeEnabled))
      ..add(DiagnosticsProperty('preferedCodec', preferedCodec))
      ..add(DiagnosticsProperty('videoQuality', videoQuality));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _CallSetting &&
            (identical(other.isLowBandwidthMode, isLowBandwidthMode) ||
                other.isLowBandwidthMode == isLowBandwidthMode) &&
            (identical(other.isAudioMuted, isAudioMuted) ||
                other.isAudioMuted == isAudioMuted) &&
            (identical(
                    other.echoCancellationEnabled, echoCancellationEnabled) ||
                other.echoCancellationEnabled == echoCancellationEnabled) &&
            (identical(
                    other.noiseSuppressionEnabled, noiseSuppressionEnabled) ||
                other.noiseSuppressionEnabled == noiseSuppressionEnabled) &&
            (identical(other.agcEnabled, agcEnabled) ||
                other.agcEnabled == agcEnabled) &&
            (identical(other.isVideoMuted, isVideoMuted) ||
                other.isVideoMuted == isVideoMuted) &&
            (identical(other.e2eeEnabled, e2eeEnabled) ||
                other.e2eeEnabled == e2eeEnabled) &&
            (identical(other.preferedCodec, preferedCodec) ||
                other.preferedCodec == preferedCodec) &&
            (identical(other.videoQuality, videoQuality) ||
                other.videoQuality == videoQuality));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      isLowBandwidthMode,
      isAudioMuted,
      echoCancellationEnabled,
      noiseSuppressionEnabled,
      agcEnabled,
      isVideoMuted,
      e2eeEnabled,
      preferedCodec,
      videoQuality);

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'CallSetting(isLowBandwidthMode: $isLowBandwidthMode, isAudioMuted: $isAudioMuted, echoCancellationEnabled: $echoCancellationEnabled, noiseSuppressionEnabled: $noiseSuppressionEnabled, agcEnabled: $agcEnabled, isVideoMuted: $isVideoMuted, e2eeEnabled: $e2eeEnabled, preferedCodec: $preferedCodec, videoQuality: $videoQuality)';
  }
}

/// @nodoc
abstract mixin class _$CallSettingCopyWith<$Res>
    implements $CallSettingCopyWith<$Res> {
  factory _$CallSettingCopyWith(
          _CallSetting value, $Res Function(_CallSetting) _then) =
      __$CallSettingCopyWithImpl;
  @override
  @useResult
  $Res call(
      {bool isLowBandwidthMode,
      bool isAudioMuted,
      bool echoCancellationEnabled,
      bool noiseSuppressionEnabled,
      bool agcEnabled,
      bool isVideoMuted,
      bool e2eeEnabled,
      RTCVideoCodec preferedCodec,
      VideoQuality videoQuality});
}

/// @nodoc
class __$CallSettingCopyWithImpl<$Res> implements _$CallSettingCopyWith<$Res> {
  __$CallSettingCopyWithImpl(this._self, this._then);

  final _CallSetting _self;
  final $Res Function(_CallSetting) _then;

  /// Create a copy of CallSetting
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? isLowBandwidthMode = null,
    Object? isAudioMuted = null,
    Object? echoCancellationEnabled = null,
    Object? noiseSuppressionEnabled = null,
    Object? agcEnabled = null,
    Object? isVideoMuted = null,
    Object? e2eeEnabled = null,
    Object? preferedCodec = null,
    Object? videoQuality = null,
  }) {
    return _then(_CallSetting(
      isLowBandwidthMode: null == isLowBandwidthMode
          ? _self.isLowBandwidthMode
          : isLowBandwidthMode // ignore: cast_nullable_to_non_nullable
              as bool,
      isAudioMuted: null == isAudioMuted
          ? _self.isAudioMuted
          : isAudioMuted // ignore: cast_nullable_to_non_nullable
              as bool,
      echoCancellationEnabled: null == echoCancellationEnabled
          ? _self.echoCancellationEnabled
          : echoCancellationEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      noiseSuppressionEnabled: null == noiseSuppressionEnabled
          ? _self.noiseSuppressionEnabled
          : noiseSuppressionEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      agcEnabled: null == agcEnabled
          ? _self.agcEnabled
          : agcEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      isVideoMuted: null == isVideoMuted
          ? _self.isVideoMuted
          : isVideoMuted // ignore: cast_nullable_to_non_nullable
              as bool,
      e2eeEnabled: null == e2eeEnabled
          ? _self.e2eeEnabled
          : e2eeEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      preferedCodec: null == preferedCodec
          ? _self.preferedCodec
          : preferedCodec // ignore: cast_nullable_to_non_nullable
              as RTCVideoCodec,
      videoQuality: null == videoQuality
          ? _self.videoQuality
          : videoQuality // ignore: cast_nullable_to_non_nullable
              as VideoQuality,
    ));
  }
}

// dart format on
