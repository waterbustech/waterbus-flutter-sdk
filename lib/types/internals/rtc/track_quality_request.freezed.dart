// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'track_quality_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TrackQualityRequest {
  String get trackId;
  TrackQuality get quality;

  /// Create a copy of TrackQualityRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TrackQualityRequestCopyWith<TrackQualityRequest> get copyWith =>
      _$TrackQualityRequestCopyWithImpl<TrackQualityRequest>(
          this as TrackQualityRequest, _$identity);

  /// Serializes this TrackQualityRequest to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TrackQualityRequest &&
            (identical(other.trackId, trackId) || other.trackId == trackId) &&
            (identical(other.quality, quality) || other.quality == quality));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, trackId, quality);

  @override
  String toString() {
    return 'TrackQualityRequest(trackId: $trackId, quality: $quality)';
  }
}

/// @nodoc
abstract mixin class $TrackQualityRequestCopyWith<$Res> {
  factory $TrackQualityRequestCopyWith(
          TrackQualityRequest value, $Res Function(TrackQualityRequest) _then) =
      _$TrackQualityRequestCopyWithImpl;
  @useResult
  $Res call({String trackId, TrackQuality quality});
}

/// @nodoc
class _$TrackQualityRequestCopyWithImpl<$Res>
    implements $TrackQualityRequestCopyWith<$Res> {
  _$TrackQualityRequestCopyWithImpl(this._self, this._then);

  final TrackQualityRequest _self;
  final $Res Function(TrackQualityRequest) _then;

  /// Create a copy of TrackQualityRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? trackId = null,
    Object? quality = null,
  }) {
    return _then(_self.copyWith(
      trackId: null == trackId
          ? _self.trackId
          : trackId // ignore: cast_nullable_to_non_nullable
              as String,
      quality: null == quality
          ? _self.quality
          : quality // ignore: cast_nullable_to_non_nullable
              as TrackQuality,
    ));
  }
}

/// Adds pattern-matching-related methods to [TrackQualityRequest].
extension TrackQualityRequestPatterns on TrackQualityRequest {
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
    TResult Function(_TrackQualityRequest value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _TrackQualityRequest() when $default != null:
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
    TResult Function(_TrackQualityRequest value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TrackQualityRequest():
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
    TResult? Function(_TrackQualityRequest value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TrackQualityRequest() when $default != null:
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
    TResult Function(String trackId, TrackQuality quality)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _TrackQualityRequest() when $default != null:
        return $default(_that.trackId, _that.quality);
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
    TResult Function(String trackId, TrackQuality quality) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TrackQualityRequest():
        return $default(_that.trackId, _that.quality);
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
    TResult? Function(String trackId, TrackQuality quality)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TrackQualityRequest() when $default != null:
        return $default(_that.trackId, _that.quality);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _TrackQualityRequest implements TrackQualityRequest {
  const _TrackQualityRequest({required this.trackId, required this.quality});
  factory _TrackQualityRequest.fromJson(Map<String, dynamic> json) =>
      _$TrackQualityRequestFromJson(json);

  @override
  final String trackId;
  @override
  final TrackQuality quality;

  /// Create a copy of TrackQualityRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$TrackQualityRequestCopyWith<_TrackQualityRequest> get copyWith =>
      __$TrackQualityRequestCopyWithImpl<_TrackQualityRequest>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$TrackQualityRequestToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _TrackQualityRequest &&
            (identical(other.trackId, trackId) || other.trackId == trackId) &&
            (identical(other.quality, quality) || other.quality == quality));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, trackId, quality);

  @override
  String toString() {
    return 'TrackQualityRequest(trackId: $trackId, quality: $quality)';
  }
}

/// @nodoc
abstract mixin class _$TrackQualityRequestCopyWith<$Res>
    implements $TrackQualityRequestCopyWith<$Res> {
  factory _$TrackQualityRequestCopyWith(_TrackQualityRequest value,
          $Res Function(_TrackQualityRequest) _then) =
      __$TrackQualityRequestCopyWithImpl;
  @override
  @useResult
  $Res call({String trackId, TrackQuality quality});
}

/// @nodoc
class __$TrackQualityRequestCopyWithImpl<$Res>
    implements _$TrackQualityRequestCopyWith<$Res> {
  __$TrackQualityRequestCopyWithImpl(this._self, this._then);

  final _TrackQualityRequest _self;
  final $Res Function(_TrackQualityRequest) _then;

  /// Create a copy of TrackQualityRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? trackId = null,
    Object? quality = null,
  }) {
    return _then(_TrackQualityRequest(
      trackId: null == trackId
          ? _self.trackId
          : trackId // ignore: cast_nullable_to_non_nullable
              as String,
      quality: null == quality
          ? _self.quality
          : quality // ignore: cast_nullable_to_non_nullable
              as TrackQuality,
    ));
  }
}

// dart format on
