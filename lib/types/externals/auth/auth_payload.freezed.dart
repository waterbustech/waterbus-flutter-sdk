// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_payload.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AuthPayload {
  String get fullName;
  String get externalId;

  /// Create a copy of AuthPayload
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AuthPayloadCopyWith<AuthPayload> get copyWith =>
      _$AuthPayloadCopyWithImpl<AuthPayload>(this as AuthPayload, _$identity);

  /// Serializes this AuthPayload to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AuthPayload &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName) &&
            (identical(other.externalId, externalId) ||
                other.externalId == externalId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, fullName, externalId);

  @override
  String toString() {
    return 'AuthPayload(fullName: $fullName, externalId: $externalId)';
  }
}

/// @nodoc
abstract mixin class $AuthPayloadCopyWith<$Res> {
  factory $AuthPayloadCopyWith(
          AuthPayload value, $Res Function(AuthPayload) _then) =
      _$AuthPayloadCopyWithImpl;
  @useResult
  $Res call({String fullName, String externalId});
}

/// @nodoc
class _$AuthPayloadCopyWithImpl<$Res> implements $AuthPayloadCopyWith<$Res> {
  _$AuthPayloadCopyWithImpl(this._self, this._then);

  final AuthPayload _self;
  final $Res Function(AuthPayload) _then;

  /// Create a copy of AuthPayload
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fullName = null,
    Object? externalId = null,
  }) {
    return _then(_self.copyWith(
      fullName: null == fullName
          ? _self.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String,
      externalId: null == externalId
          ? _self.externalId
          : externalId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// Adds pattern-matching-related methods to [AuthPayload].
extension AuthPayloadPatterns on AuthPayload {
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
    TResult Function(_AuthPayload value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AuthPayload() when $default != null:
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
    TResult Function(_AuthPayload value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AuthPayload():
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
    TResult? Function(_AuthPayload value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AuthPayload() when $default != null:
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
    TResult Function(String fullName, String externalId)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AuthPayload() when $default != null:
        return $default(_that.fullName, _that.externalId);
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
    TResult Function(String fullName, String externalId) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AuthPayload():
        return $default(_that.fullName, _that.externalId);
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
    TResult? Function(String fullName, String externalId)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AuthPayload() when $default != null:
        return $default(_that.fullName, _that.externalId);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _AuthPayload implements AuthPayload {
  const _AuthPayload({required this.fullName, required this.externalId});
  factory _AuthPayload.fromJson(Map<String, dynamic> json) =>
      _$AuthPayloadFromJson(json);

  @override
  final String fullName;
  @override
  final String externalId;

  /// Create a copy of AuthPayload
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$AuthPayloadCopyWith<_AuthPayload> get copyWith =>
      __$AuthPayloadCopyWithImpl<_AuthPayload>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$AuthPayloadToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _AuthPayload &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName) &&
            (identical(other.externalId, externalId) ||
                other.externalId == externalId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, fullName, externalId);

  @override
  String toString() {
    return 'AuthPayload(fullName: $fullName, externalId: $externalId)';
  }
}

/// @nodoc
abstract mixin class _$AuthPayloadCopyWith<$Res>
    implements $AuthPayloadCopyWith<$Res> {
  factory _$AuthPayloadCopyWith(
          _AuthPayload value, $Res Function(_AuthPayload) _then) =
      __$AuthPayloadCopyWithImpl;
  @override
  @useResult
  $Res call({String fullName, String externalId});
}

/// @nodoc
class __$AuthPayloadCopyWithImpl<$Res> implements _$AuthPayloadCopyWith<$Res> {
  __$AuthPayloadCopyWithImpl(this._self, this._then);

  final _AuthPayload _self;
  final $Res Function(_AuthPayload) _then;

  /// Create a copy of AuthPayload
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? fullName = null,
    Object? externalId = null,
  }) {
    return _then(_AuthPayload(
      fullName: null == fullName
          ? _self.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String,
      externalId: null == externalId
          ? _self.externalId
          : externalId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
