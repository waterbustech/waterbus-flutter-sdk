// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'media_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MediaConfig implements DiagnosticableTreeMixin {
  AudioConfig get audioConfig;
  VideoConfig get videoConfig;
  bool get e2eeEnabled;

  /// Create a copy of MediaConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MediaConfigCopyWith<MediaConfig> get copyWith =>
      _$MediaConfigCopyWithImpl<MediaConfig>(this as MediaConfig, _$identity);

  /// Serializes this MediaConfig to a JSON map.
  Map<String, dynamic> toJson();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
      ..add(DiagnosticsProperty('type', 'MediaConfig'))
      ..add(DiagnosticsProperty('audioConfig', audioConfig))
      ..add(DiagnosticsProperty('videoConfig', videoConfig))
      ..add(DiagnosticsProperty('e2eeEnabled', e2eeEnabled));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MediaConfig &&
            (identical(other.audioConfig, audioConfig) ||
                other.audioConfig == audioConfig) &&
            (identical(other.videoConfig, videoConfig) ||
                other.videoConfig == videoConfig) &&
            (identical(other.e2eeEnabled, e2eeEnabled) ||
                other.e2eeEnabled == e2eeEnabled));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, audioConfig, videoConfig, e2eeEnabled);

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'MediaConfig(audioConfig: $audioConfig, videoConfig: $videoConfig, e2eeEnabled: $e2eeEnabled)';
  }
}

/// @nodoc
abstract mixin class $MediaConfigCopyWith<$Res> {
  factory $MediaConfigCopyWith(
          MediaConfig value, $Res Function(MediaConfig) _then) =
      _$MediaConfigCopyWithImpl;
  @useResult
  $Res call(
      {AudioConfig audioConfig, VideoConfig videoConfig, bool e2eeEnabled});

  $AudioConfigCopyWith<$Res> get audioConfig;
  $VideoConfigCopyWith<$Res> get videoConfig;
}

/// @nodoc
class _$MediaConfigCopyWithImpl<$Res> implements $MediaConfigCopyWith<$Res> {
  _$MediaConfigCopyWithImpl(this._self, this._then);

  final MediaConfig _self;
  final $Res Function(MediaConfig) _then;

  /// Create a copy of MediaConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? audioConfig = null,
    Object? videoConfig = null,
    Object? e2eeEnabled = null,
  }) {
    return _then(_self.copyWith(
      audioConfig: null == audioConfig
          ? _self.audioConfig
          : audioConfig // ignore: cast_nullable_to_non_nullable
              as AudioConfig,
      videoConfig: null == videoConfig
          ? _self.videoConfig
          : videoConfig // ignore: cast_nullable_to_non_nullable
              as VideoConfig,
      e2eeEnabled: null == e2eeEnabled
          ? _self.e2eeEnabled
          : e2eeEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }

  /// Create a copy of MediaConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AudioConfigCopyWith<$Res> get audioConfig {
    return $AudioConfigCopyWith<$Res>(_self.audioConfig, (value) {
      return _then(_self.copyWith(audioConfig: value));
    });
  }

  /// Create a copy of MediaConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $VideoConfigCopyWith<$Res> get videoConfig {
    return $VideoConfigCopyWith<$Res>(_self.videoConfig, (value) {
      return _then(_self.copyWith(videoConfig: value));
    });
  }
}

/// Adds pattern-matching-related methods to [MediaConfig].
extension MediaConfigPatterns on MediaConfig {
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
    TResult Function(_MediaConfig value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MediaConfig() when $default != null:
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
    TResult Function(_MediaConfig value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MediaConfig():
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
    TResult? Function(_MediaConfig value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MediaConfig() when $default != null:
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
            AudioConfig audioConfig, VideoConfig videoConfig, bool e2eeEnabled)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MediaConfig() when $default != null:
        return $default(
            _that.audioConfig, _that.videoConfig, _that.e2eeEnabled);
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
            AudioConfig audioConfig, VideoConfig videoConfig, bool e2eeEnabled)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MediaConfig():
        return $default(
            _that.audioConfig, _that.videoConfig, _that.e2eeEnabled);
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
            AudioConfig audioConfig, VideoConfig videoConfig, bool e2eeEnabled)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MediaConfig() when $default != null:
        return $default(
            _that.audioConfig, _that.videoConfig, _that.e2eeEnabled);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _MediaConfig with DiagnosticableTreeMixin implements MediaConfig {
  const _MediaConfig(
      {this.audioConfig = const AudioConfig(),
      this.videoConfig = const VideoConfig(),
      this.e2eeEnabled = false});
  factory _MediaConfig.fromJson(Map<String, dynamic> json) =>
      _$MediaConfigFromJson(json);

  @override
  @JsonKey()
  final AudioConfig audioConfig;
  @override
  @JsonKey()
  final VideoConfig videoConfig;
  @override
  @JsonKey()
  final bool e2eeEnabled;

  /// Create a copy of MediaConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$MediaConfigCopyWith<_MediaConfig> get copyWith =>
      __$MediaConfigCopyWithImpl<_MediaConfig>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$MediaConfigToJson(
      this,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
      ..add(DiagnosticsProperty('type', 'MediaConfig'))
      ..add(DiagnosticsProperty('audioConfig', audioConfig))
      ..add(DiagnosticsProperty('videoConfig', videoConfig))
      ..add(DiagnosticsProperty('e2eeEnabled', e2eeEnabled));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _MediaConfig &&
            (identical(other.audioConfig, audioConfig) ||
                other.audioConfig == audioConfig) &&
            (identical(other.videoConfig, videoConfig) ||
                other.videoConfig == videoConfig) &&
            (identical(other.e2eeEnabled, e2eeEnabled) ||
                other.e2eeEnabled == e2eeEnabled));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, audioConfig, videoConfig, e2eeEnabled);

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'MediaConfig(audioConfig: $audioConfig, videoConfig: $videoConfig, e2eeEnabled: $e2eeEnabled)';
  }
}

/// @nodoc
abstract mixin class _$MediaConfigCopyWith<$Res>
    implements $MediaConfigCopyWith<$Res> {
  factory _$MediaConfigCopyWith(
          _MediaConfig value, $Res Function(_MediaConfig) _then) =
      __$MediaConfigCopyWithImpl;
  @override
  @useResult
  $Res call(
      {AudioConfig audioConfig, VideoConfig videoConfig, bool e2eeEnabled});

  @override
  $AudioConfigCopyWith<$Res> get audioConfig;
  @override
  $VideoConfigCopyWith<$Res> get videoConfig;
}

/// @nodoc
class __$MediaConfigCopyWithImpl<$Res> implements _$MediaConfigCopyWith<$Res> {
  __$MediaConfigCopyWithImpl(this._self, this._then);

  final _MediaConfig _self;
  final $Res Function(_MediaConfig) _then;

  /// Create a copy of MediaConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? audioConfig = null,
    Object? videoConfig = null,
    Object? e2eeEnabled = null,
  }) {
    return _then(_MediaConfig(
      audioConfig: null == audioConfig
          ? _self.audioConfig
          : audioConfig // ignore: cast_nullable_to_non_nullable
              as AudioConfig,
      videoConfig: null == videoConfig
          ? _self.videoConfig
          : videoConfig // ignore: cast_nullable_to_non_nullable
              as VideoConfig,
      e2eeEnabled: null == e2eeEnabled
          ? _self.e2eeEnabled
          : e2eeEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }

  /// Create a copy of MediaConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AudioConfigCopyWith<$Res> get audioConfig {
    return $AudioConfigCopyWith<$Res>(_self.audioConfig, (value) {
      return _then(_self.copyWith(audioConfig: value));
    });
  }

  /// Create a copy of MediaConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $VideoConfigCopyWith<$Res> get videoConfig {
    return $VideoConfigCopyWith<$Res>(_self.videoConfig, (value) {
      return _then(_self.copyWith(videoConfig: value));
    });
  }
}

// dart format on
