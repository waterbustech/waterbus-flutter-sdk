// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'audio_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AudioConfig {
  bool get isLowBandwidthMode;
  bool get isAudioMuted;
  bool get echoCancellationEnabled;
  bool get noiseSuppressionEnabled;
  bool get agcEnabled;

  /// Create a copy of AudioConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AudioConfigCopyWith<AudioConfig> get copyWith =>
      _$AudioConfigCopyWithImpl<AudioConfig>(this as AudioConfig, _$identity);

  /// Serializes this AudioConfig to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AudioConfig &&
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
                other.agcEnabled == agcEnabled));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, isLowBandwidthMode, isAudioMuted,
      echoCancellationEnabled, noiseSuppressionEnabled, agcEnabled);

  @override
  String toString() {
    return 'AudioConfig(isLowBandwidthMode: $isLowBandwidthMode, isAudioMuted: $isAudioMuted, echoCancellationEnabled: $echoCancellationEnabled, noiseSuppressionEnabled: $noiseSuppressionEnabled, agcEnabled: $agcEnabled)';
  }
}

/// @nodoc
abstract mixin class $AudioConfigCopyWith<$Res> {
  factory $AudioConfigCopyWith(
          AudioConfig value, $Res Function(AudioConfig) _then) =
      _$AudioConfigCopyWithImpl;
  @useResult
  $Res call(
      {bool isLowBandwidthMode,
      bool isAudioMuted,
      bool echoCancellationEnabled,
      bool noiseSuppressionEnabled,
      bool agcEnabled});
}

/// @nodoc
class _$AudioConfigCopyWithImpl<$Res> implements $AudioConfigCopyWith<$Res> {
  _$AudioConfigCopyWithImpl(this._self, this._then);

  final AudioConfig _self;
  final $Res Function(AudioConfig) _then;

  /// Create a copy of AudioConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLowBandwidthMode = null,
    Object? isAudioMuted = null,
    Object? echoCancellationEnabled = null,
    Object? noiseSuppressionEnabled = null,
    Object? agcEnabled = null,
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
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _AudioConfig implements AudioConfig {
  const _AudioConfig(
      {this.isLowBandwidthMode = false,
      this.isAudioMuted = false,
      this.echoCancellationEnabled = true,
      this.noiseSuppressionEnabled = true,
      this.agcEnabled = true});
  factory _AudioConfig.fromJson(Map<String, dynamic> json) =>
      _$AudioConfigFromJson(json);

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

  /// Create a copy of AudioConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$AudioConfigCopyWith<_AudioConfig> get copyWith =>
      __$AudioConfigCopyWithImpl<_AudioConfig>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$AudioConfigToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _AudioConfig &&
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
                other.agcEnabled == agcEnabled));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, isLowBandwidthMode, isAudioMuted,
      echoCancellationEnabled, noiseSuppressionEnabled, agcEnabled);

  @override
  String toString() {
    return 'AudioConfig(isLowBandwidthMode: $isLowBandwidthMode, isAudioMuted: $isAudioMuted, echoCancellationEnabled: $echoCancellationEnabled, noiseSuppressionEnabled: $noiseSuppressionEnabled, agcEnabled: $agcEnabled)';
  }
}

/// @nodoc
abstract mixin class _$AudioConfigCopyWith<$Res>
    implements $AudioConfigCopyWith<$Res> {
  factory _$AudioConfigCopyWith(
          _AudioConfig value, $Res Function(_AudioConfig) _then) =
      __$AudioConfigCopyWithImpl;
  @override
  @useResult
  $Res call(
      {bool isLowBandwidthMode,
      bool isAudioMuted,
      bool echoCancellationEnabled,
      bool noiseSuppressionEnabled,
      bool agcEnabled});
}

/// @nodoc
class __$AudioConfigCopyWithImpl<$Res> implements _$AudioConfigCopyWith<$Res> {
  __$AudioConfigCopyWithImpl(this._self, this._then);

  final _AudioConfig _self;
  final $Res Function(_AudioConfig) _then;

  /// Create a copy of AudioConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? isLowBandwidthMode = null,
    Object? isAudioMuted = null,
    Object? echoCancellationEnabled = null,
    Object? noiseSuppressionEnabled = null,
    Object? agcEnabled = null,
  }) {
    return _then(_AudioConfig(
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
    ));
  }
}

// dart format on
