// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'presigned_url.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PresignedUrl {
  String get presignedUrl;
  String get sourceUrl;

  /// Create a copy of PresignedUrl
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PresignedUrlCopyWith<PresignedUrl> get copyWith =>
      _$PresignedUrlCopyWithImpl<PresignedUrl>(
          this as PresignedUrl, _$identity);

  /// Serializes this PresignedUrl to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PresignedUrl &&
            (identical(other.presignedUrl, presignedUrl) ||
                other.presignedUrl == presignedUrl) &&
            (identical(other.sourceUrl, sourceUrl) ||
                other.sourceUrl == sourceUrl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, presignedUrl, sourceUrl);

  @override
  String toString() {
    return 'PresignedUrl(presignedUrl: $presignedUrl, sourceUrl: $sourceUrl)';
  }
}

/// @nodoc
abstract mixin class $PresignedUrlCopyWith<$Res> {
  factory $PresignedUrlCopyWith(
          PresignedUrl value, $Res Function(PresignedUrl) _then) =
      _$PresignedUrlCopyWithImpl;
  @useResult
  $Res call({String presignedUrl, String sourceUrl});
}

/// @nodoc
class _$PresignedUrlCopyWithImpl<$Res> implements $PresignedUrlCopyWith<$Res> {
  _$PresignedUrlCopyWithImpl(this._self, this._then);

  final PresignedUrl _self;
  final $Res Function(PresignedUrl) _then;

  /// Create a copy of PresignedUrl
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? presignedUrl = null,
    Object? sourceUrl = null,
  }) {
    return _then(_self.copyWith(
      presignedUrl: null == presignedUrl
          ? _self.presignedUrl
          : presignedUrl // ignore: cast_nullable_to_non_nullable
              as String,
      sourceUrl: null == sourceUrl
          ? _self.sourceUrl
          : sourceUrl // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// Adds pattern-matching-related methods to [PresignedUrl].
extension PresignedUrlPatterns on PresignedUrl {
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
    TResult Function(_PresignedUrl value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PresignedUrl() when $default != null:
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
    TResult Function(_PresignedUrl value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PresignedUrl():
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
    TResult? Function(_PresignedUrl value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PresignedUrl() when $default != null:
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
    TResult Function(String presignedUrl, String sourceUrl)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PresignedUrl() when $default != null:
        return $default(_that.presignedUrl, _that.sourceUrl);
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
    TResult Function(String presignedUrl, String sourceUrl) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PresignedUrl():
        return $default(_that.presignedUrl, _that.sourceUrl);
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
    TResult? Function(String presignedUrl, String sourceUrl)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PresignedUrl() when $default != null:
        return $default(_that.presignedUrl, _that.sourceUrl);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _PresignedUrl implements PresignedUrl {
  const _PresignedUrl({required this.presignedUrl, required this.sourceUrl});
  factory _PresignedUrl.fromJson(Map<String, dynamic> json) =>
      _$PresignedUrlFromJson(json);

  @override
  final String presignedUrl;
  @override
  final String sourceUrl;

  /// Create a copy of PresignedUrl
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$PresignedUrlCopyWith<_PresignedUrl> get copyWith =>
      __$PresignedUrlCopyWithImpl<_PresignedUrl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$PresignedUrlToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _PresignedUrl &&
            (identical(other.presignedUrl, presignedUrl) ||
                other.presignedUrl == presignedUrl) &&
            (identical(other.sourceUrl, sourceUrl) ||
                other.sourceUrl == sourceUrl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, presignedUrl, sourceUrl);

  @override
  String toString() {
    return 'PresignedUrl(presignedUrl: $presignedUrl, sourceUrl: $sourceUrl)';
  }
}

/// @nodoc
abstract mixin class _$PresignedUrlCopyWith<$Res>
    implements $PresignedUrlCopyWith<$Res> {
  factory _$PresignedUrlCopyWith(
          _PresignedUrl value, $Res Function(_PresignedUrl) _then) =
      __$PresignedUrlCopyWithImpl;
  @override
  @useResult
  $Res call({String presignedUrl, String sourceUrl});
}

/// @nodoc
class __$PresignedUrlCopyWithImpl<$Res>
    implements _$PresignedUrlCopyWith<$Res> {
  __$PresignedUrlCopyWithImpl(this._self, this._then);

  final _PresignedUrl _self;
  final $Res Function(_PresignedUrl) _then;

  /// Create a copy of PresignedUrl
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? presignedUrl = null,
    Object? sourceUrl = null,
  }) {
    return _then(_PresignedUrl(
      presignedUrl: null == presignedUrl
          ? _self.presignedUrl
          : presignedUrl // ignore: cast_nullable_to_non_nullable
              as String,
      sourceUrl: null == sourceUrl
          ? _self.sourceUrl
          : sourceUrl // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
