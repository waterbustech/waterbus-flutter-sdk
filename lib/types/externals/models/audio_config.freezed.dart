// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'audio_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AudioConfig implements DiagnosticableTreeMixin {
  String? get deviceId;
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
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
      ..add(DiagnosticsProperty('type', 'AudioConfig'))
      ..add(DiagnosticsProperty('deviceId', deviceId))
      ..add(DiagnosticsProperty('isLowBandwidthMode', isLowBandwidthMode))
      ..add(DiagnosticsProperty('isAudioMuted', isAudioMuted))
      ..add(DiagnosticsProperty(
          'echoCancellationEnabled', echoCancellationEnabled))
      ..add(DiagnosticsProperty(
          'noiseSuppressionEnabled', noiseSuppressionEnabled))
      ..add(DiagnosticsProperty('agcEnabled', agcEnabled));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AudioConfig &&
            (identical(other.deviceId, deviceId) ||
                other.deviceId == deviceId) &&
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
  int get hashCode => Object.hash(
      runtimeType,
      deviceId,
      isLowBandwidthMode,
      isAudioMuted,
      echoCancellationEnabled,
      noiseSuppressionEnabled,
      agcEnabled);

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'AudioConfig(deviceId: $deviceId, isLowBandwidthMode: $isLowBandwidthMode, isAudioMuted: $isAudioMuted, echoCancellationEnabled: $echoCancellationEnabled, noiseSuppressionEnabled: $noiseSuppressionEnabled, agcEnabled: $agcEnabled)';
  }
}

/// @nodoc
abstract mixin class $AudioConfigCopyWith<$Res> {
  factory $AudioConfigCopyWith(
          AudioConfig value, $Res Function(AudioConfig) _then) =
      _$AudioConfigCopyWithImpl;
  @useResult
  $Res call(
      {String? deviceId,
      bool isLowBandwidthMode,
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
    Object? deviceId = freezed,
    Object? isLowBandwidthMode = null,
    Object? isAudioMuted = null,
    Object? echoCancellationEnabled = null,
    Object? noiseSuppressionEnabled = null,
    Object? agcEnabled = null,
  }) {
    return _then(_self.copyWith(
      deviceId: freezed == deviceId
          ? _self.deviceId
          : deviceId // ignore: cast_nullable_to_non_nullable
              as String?,
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

/// Adds pattern-matching-related methods to [AudioConfig].
extension AudioConfigPatterns on AudioConfig {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_AudioConfig value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AudioConfig() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_AudioConfig value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AudioConfig():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_AudioConfig value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AudioConfig() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            String? deviceId,
            bool isLowBandwidthMode,
            bool isAudioMuted,
            bool echoCancellationEnabled,
            bool noiseSuppressionEnabled,
            bool agcEnabled)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AudioConfig() when $default != null:
        return $default(
            _that.deviceId,
            _that.isLowBandwidthMode,
            _that.isAudioMuted,
            _that.echoCancellationEnabled,
            _that.noiseSuppressionEnabled,
            _that.agcEnabled);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            String? deviceId,
            bool isLowBandwidthMode,
            bool isAudioMuted,
            bool echoCancellationEnabled,
            bool noiseSuppressionEnabled,
            bool agcEnabled)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AudioConfig():
        return $default(
            _that.deviceId,
            _that.isLowBandwidthMode,
            _that.isAudioMuted,
            _that.echoCancellationEnabled,
            _that.noiseSuppressionEnabled,
            _that.agcEnabled);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            String? deviceId,
            bool isLowBandwidthMode,
            bool isAudioMuted,
            bool echoCancellationEnabled,
            bool noiseSuppressionEnabled,
            bool agcEnabled)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AudioConfig() when $default != null:
        return $default(
            _that.deviceId,
            _that.isLowBandwidthMode,
            _that.isAudioMuted,
            _that.echoCancellationEnabled,
            _that.noiseSuppressionEnabled,
            _that.agcEnabled);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _AudioConfig with DiagnosticableTreeMixin implements AudioConfig {
  const _AudioConfig(
      {this.deviceId,
      this.isLowBandwidthMode = false,
      this.isAudioMuted = false,
      this.echoCancellationEnabled = true,
      this.noiseSuppressionEnabled = true,
      this.agcEnabled = true});
  factory _AudioConfig.fromJson(Map<String, dynamic> json) =>
      _$AudioConfigFromJson(json);

  @override
  final String? deviceId;
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
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
      ..add(DiagnosticsProperty('type', 'AudioConfig'))
      ..add(DiagnosticsProperty('deviceId', deviceId))
      ..add(DiagnosticsProperty('isLowBandwidthMode', isLowBandwidthMode))
      ..add(DiagnosticsProperty('isAudioMuted', isAudioMuted))
      ..add(DiagnosticsProperty(
          'echoCancellationEnabled', echoCancellationEnabled))
      ..add(DiagnosticsProperty(
          'noiseSuppressionEnabled', noiseSuppressionEnabled))
      ..add(DiagnosticsProperty('agcEnabled', agcEnabled));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _AudioConfig &&
            (identical(other.deviceId, deviceId) ||
                other.deviceId == deviceId) &&
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
  int get hashCode => Object.hash(
      runtimeType,
      deviceId,
      isLowBandwidthMode,
      isAudioMuted,
      echoCancellationEnabled,
      noiseSuppressionEnabled,
      agcEnabled);

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'AudioConfig(deviceId: $deviceId, isLowBandwidthMode: $isLowBandwidthMode, isAudioMuted: $isAudioMuted, echoCancellationEnabled: $echoCancellationEnabled, noiseSuppressionEnabled: $noiseSuppressionEnabled, agcEnabled: $agcEnabled)';
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
      {String? deviceId,
      bool isLowBandwidthMode,
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
    Object? deviceId = freezed,
    Object? isLowBandwidthMode = null,
    Object? isAudioMuted = null,
    Object? echoCancellationEnabled = null,
    Object? noiseSuppressionEnabled = null,
    Object? agcEnabled = null,
  }) {
    return _then(_AudioConfig(
      deviceId: freezed == deviceId
          ? _self.deviceId
          : deviceId // ignore: cast_nullable_to_non_nullable
              as String?,
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
