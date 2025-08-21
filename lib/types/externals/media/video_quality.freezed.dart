// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'video_quality.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$VideoQuality {
  int get minHeight;
  int get minWidth;
  int get minFrameRate;

  /// Create a copy of VideoQuality
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $VideoQualityCopyWith<VideoQuality> get copyWith =>
      _$VideoQualityCopyWithImpl<VideoQuality>(
          this as VideoQuality, _$identity);

  /// Serializes this VideoQuality to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is VideoQuality &&
            (identical(other.minHeight, minHeight) ||
                other.minHeight == minHeight) &&
            (identical(other.minWidth, minWidth) ||
                other.minWidth == minWidth) &&
            (identical(other.minFrameRate, minFrameRate) ||
                other.minFrameRate == minFrameRate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, minHeight, minWidth, minFrameRate);

  @override
  String toString() {
    return 'VideoQuality(minHeight: $minHeight, minWidth: $minWidth, minFrameRate: $minFrameRate)';
  }
}

/// @nodoc
abstract mixin class $VideoQualityCopyWith<$Res> {
  factory $VideoQualityCopyWith(
          VideoQuality value, $Res Function(VideoQuality) _then) =
      _$VideoQualityCopyWithImpl;
  @useResult
  $Res call({int minHeight, int minWidth, int minFrameRate});
}

/// @nodoc
class _$VideoQualityCopyWithImpl<$Res> implements $VideoQualityCopyWith<$Res> {
  _$VideoQualityCopyWithImpl(this._self, this._then);

  final VideoQuality _self;
  final $Res Function(VideoQuality) _then;

  /// Create a copy of VideoQuality
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? minHeight = null,
    Object? minWidth = null,
    Object? minFrameRate = null,
  }) {
    return _then(_self.copyWith(
      minHeight: null == minHeight
          ? _self.minHeight
          : minHeight // ignore: cast_nullable_to_non_nullable
              as int,
      minWidth: null == minWidth
          ? _self.minWidth
          : minWidth // ignore: cast_nullable_to_non_nullable
              as int,
      minFrameRate: null == minFrameRate
          ? _self.minFrameRate
          : minFrameRate // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// Adds pattern-matching-related methods to [VideoQuality].
extension VideoQualityPatterns on VideoQuality {
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
    TResult Function(_VideoQuality value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _VideoQuality() when $default != null:
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
    TResult Function(_VideoQuality value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _VideoQuality():
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
    TResult? Function(_VideoQuality value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _VideoQuality() when $default != null:
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
    TResult Function(int minHeight, int minWidth, int minFrameRate)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _VideoQuality() when $default != null:
        return $default(_that.minHeight, _that.minWidth, _that.minFrameRate);
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
    TResult Function(int minHeight, int minWidth, int minFrameRate) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _VideoQuality():
        return $default(_that.minHeight, _that.minWidth, _that.minFrameRate);
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
    TResult? Function(int minHeight, int minWidth, int minFrameRate)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _VideoQuality() when $default != null:
        return $default(_that.minHeight, _that.minWidth, _that.minFrameRate);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _VideoQuality implements VideoQuality {
  const _VideoQuality(
      {required this.minHeight,
      required this.minWidth,
      required this.minFrameRate});
  factory _VideoQuality.fromJson(Map<String, dynamic> json) =>
      _$VideoQualityFromJson(json);

  @override
  final int minHeight;
  @override
  final int minWidth;
  @override
  final int minFrameRate;

  /// Create a copy of VideoQuality
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$VideoQualityCopyWith<_VideoQuality> get copyWith =>
      __$VideoQualityCopyWithImpl<_VideoQuality>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$VideoQualityToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _VideoQuality &&
            (identical(other.minHeight, minHeight) ||
                other.minHeight == minHeight) &&
            (identical(other.minWidth, minWidth) ||
                other.minWidth == minWidth) &&
            (identical(other.minFrameRate, minFrameRate) ||
                other.minFrameRate == minFrameRate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, minHeight, minWidth, minFrameRate);

  @override
  String toString() {
    return 'VideoQuality(minHeight: $minHeight, minWidth: $minWidth, minFrameRate: $minFrameRate)';
  }
}

/// @nodoc
abstract mixin class _$VideoQualityCopyWith<$Res>
    implements $VideoQualityCopyWith<$Res> {
  factory _$VideoQualityCopyWith(
          _VideoQuality value, $Res Function(_VideoQuality) _then) =
      __$VideoQualityCopyWithImpl;
  @override
  @useResult
  $Res call({int minHeight, int minWidth, int minFrameRate});
}

/// @nodoc
class __$VideoQualityCopyWithImpl<$Res>
    implements _$VideoQualityCopyWith<$Res> {
  __$VideoQualityCopyWithImpl(this._self, this._then);

  final _VideoQuality _self;
  final $Res Function(_VideoQuality) _then;

  /// Create a copy of VideoQuality
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? minHeight = null,
    Object? minWidth = null,
    Object? minFrameRate = null,
  }) {
    return _then(_VideoQuality(
      minHeight: null == minHeight
          ? _self.minHeight
          : minHeight // ignore: cast_nullable_to_non_nullable
              as int,
      minWidth: null == minWidth
          ? _self.minWidth
          : minWidth // ignore: cast_nullable_to_non_nullable
              as int,
      minFrameRate: null == minFrameRate
          ? _self.minFrameRate
          : minFrameRate // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

// dart format on
