// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'participant_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ParticipantInfo {
  int get id;
  User? get user;
  bool get isMe;

  /// Create a copy of ParticipantInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ParticipantInfoCopyWith<ParticipantInfo> get copyWith =>
      _$ParticipantInfoCopyWithImpl<ParticipantInfo>(
          this as ParticipantInfo, _$identity);

  /// Serializes this ParticipantInfo to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ParticipantInfo &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.isMe, isMe) || other.isMe == isMe));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, user, isMe);

  @override
  String toString() {
    return 'ParticipantInfo(id: $id, user: $user, isMe: $isMe)';
  }
}

/// @nodoc
abstract mixin class $ParticipantInfoCopyWith<$Res> {
  factory $ParticipantInfoCopyWith(
          ParticipantInfo value, $Res Function(ParticipantInfo) _then) =
      _$ParticipantInfoCopyWithImpl;
  @useResult
  $Res call({int id, User? user, bool isMe});

  $UserCopyWith<$Res>? get user;
}

/// @nodoc
class _$ParticipantInfoCopyWithImpl<$Res>
    implements $ParticipantInfoCopyWith<$Res> {
  _$ParticipantInfoCopyWithImpl(this._self, this._then);

  final ParticipantInfo _self;
  final $Res Function(ParticipantInfo) _then;

  /// Create a copy of ParticipantInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? user = freezed,
    Object? isMe = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      user: freezed == user
          ? _self.user
          : user // ignore: cast_nullable_to_non_nullable
              as User?,
      isMe: null == isMe
          ? _self.isMe
          : isMe // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }

  /// Create a copy of ParticipantInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserCopyWith<$Res>? get user {
    if (_self.user == null) {
      return null;
    }

    return $UserCopyWith<$Res>(_self.user!, (value) {
      return _then(_self.copyWith(user: value));
    });
  }
}

/// Adds pattern-matching-related methods to [ParticipantInfo].
extension ParticipantInfoPatterns on ParticipantInfo {
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
    TResult Function(_ParticipantInfo value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ParticipantInfo() when $default != null:
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
    TResult Function(_ParticipantInfo value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ParticipantInfo():
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
    TResult? Function(_ParticipantInfo value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ParticipantInfo() when $default != null:
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
    TResult Function(int id, User? user, bool isMe)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ParticipantInfo() when $default != null:
        return $default(_that.id, _that.user, _that.isMe);
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
    TResult Function(int id, User? user, bool isMe) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ParticipantInfo():
        return $default(_that.id, _that.user, _that.isMe);
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
    TResult? Function(int id, User? user, bool isMe)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ParticipantInfo() when $default != null:
        return $default(_that.id, _that.user, _that.isMe);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _ParticipantInfo implements ParticipantInfo {
  const _ParticipantInfo({required this.id, this.user, this.isMe = false});
  factory _ParticipantInfo.fromJson(Map<String, dynamic> json) =>
      _$ParticipantInfoFromJson(json);

  @override
  final int id;
  @override
  final User? user;
  @override
  @JsonKey()
  final bool isMe;

  /// Create a copy of ParticipantInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ParticipantInfoCopyWith<_ParticipantInfo> get copyWith =>
      __$ParticipantInfoCopyWithImpl<_ParticipantInfo>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ParticipantInfoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ParticipantInfo &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.isMe, isMe) || other.isMe == isMe));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, user, isMe);

  @override
  String toString() {
    return 'ParticipantInfo(id: $id, user: $user, isMe: $isMe)';
  }
}

/// @nodoc
abstract mixin class _$ParticipantInfoCopyWith<$Res>
    implements $ParticipantInfoCopyWith<$Res> {
  factory _$ParticipantInfoCopyWith(
          _ParticipantInfo value, $Res Function(_ParticipantInfo) _then) =
      __$ParticipantInfoCopyWithImpl;
  @override
  @useResult
  $Res call({int id, User? user, bool isMe});

  @override
  $UserCopyWith<$Res>? get user;
}

/// @nodoc
class __$ParticipantInfoCopyWithImpl<$Res>
    implements _$ParticipantInfoCopyWith<$Res> {
  __$ParticipantInfoCopyWithImpl(this._self, this._then);

  final _ParticipantInfo _self;
  final $Res Function(_ParticipantInfo) _then;

  /// Create a copy of ParticipantInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? user = freezed,
    Object? isMe = null,
  }) {
    return _then(_ParticipantInfo(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      user: freezed == user
          ? _self.user
          : user // ignore: cast_nullable_to_non_nullable
              as User?,
      isMe: null == isMe
          ? _self.isMe
          : isMe // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }

  /// Create a copy of ParticipantInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserCopyWith<$Res>? get user {
    if (_self.user == null) {
      return null;
    }

    return $UserCopyWith<$Res>(_self.user!, (value) {
      return _then(_self.copyWith(user: value));
    });
  }
}

// dart format on
