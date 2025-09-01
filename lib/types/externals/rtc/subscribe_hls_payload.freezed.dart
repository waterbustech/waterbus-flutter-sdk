// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'subscribe_hls_payload.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SubscribeHlsPayload {
  String get roomId;
  String get participantId;
  String get targetId;

  /// Create a copy of SubscribeHlsPayload
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SubscribeHlsPayloadCopyWith<SubscribeHlsPayload> get copyWith =>
      _$SubscribeHlsPayloadCopyWithImpl<SubscribeHlsPayload>(
          this as SubscribeHlsPayload, _$identity);

  /// Serializes this SubscribeHlsPayload to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SubscribeHlsPayload &&
            (identical(other.roomId, roomId) || other.roomId == roomId) &&
            (identical(other.participantId, participantId) ||
                other.participantId == participantId) &&
            (identical(other.targetId, targetId) ||
                other.targetId == targetId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, roomId, participantId, targetId);

  @override
  String toString() {
    return 'SubscribeHlsPayload(roomId: $roomId, participantId: $participantId, targetId: $targetId)';
  }
}

/// @nodoc
abstract mixin class $SubscribeHlsPayloadCopyWith<$Res> {
  factory $SubscribeHlsPayloadCopyWith(
          SubscribeHlsPayload value, $Res Function(SubscribeHlsPayload) _then) =
      _$SubscribeHlsPayloadCopyWithImpl;
  @useResult
  $Res call({String roomId, String participantId, String targetId});
}

/// @nodoc
class _$SubscribeHlsPayloadCopyWithImpl<$Res>
    implements $SubscribeHlsPayloadCopyWith<$Res> {
  _$SubscribeHlsPayloadCopyWithImpl(this._self, this._then);

  final SubscribeHlsPayload _self;
  final $Res Function(SubscribeHlsPayload) _then;

  /// Create a copy of SubscribeHlsPayload
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? roomId = null,
    Object? participantId = null,
    Object? targetId = null,
  }) {
    return _then(_self.copyWith(
      roomId: null == roomId
          ? _self.roomId
          : roomId // ignore: cast_nullable_to_non_nullable
              as String,
      participantId: null == participantId
          ? _self.participantId
          : participantId // ignore: cast_nullable_to_non_nullable
              as String,
      targetId: null == targetId
          ? _self.targetId
          : targetId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// Adds pattern-matching-related methods to [SubscribeHlsPayload].
extension SubscribeHlsPayloadPatterns on SubscribeHlsPayload {
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
    TResult Function(_SubscribeHlsPayload value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SubscribeHlsPayload() when $default != null:
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
    TResult Function(_SubscribeHlsPayload value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SubscribeHlsPayload():
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
    TResult? Function(_SubscribeHlsPayload value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SubscribeHlsPayload() when $default != null:
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
    TResult Function(String roomId, String participantId, String targetId)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SubscribeHlsPayload() when $default != null:
        return $default(_that.roomId, _that.participantId, _that.targetId);
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
    TResult Function(String roomId, String participantId, String targetId)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SubscribeHlsPayload():
        return $default(_that.roomId, _that.participantId, _that.targetId);
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
    TResult? Function(String roomId, String participantId, String targetId)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SubscribeHlsPayload() when $default != null:
        return $default(_that.roomId, _that.participantId, _that.targetId);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _SubscribeHlsPayload implements SubscribeHlsPayload {
  const _SubscribeHlsPayload(
      {required this.roomId,
      required this.participantId,
      required this.targetId});
  factory _SubscribeHlsPayload.fromJson(Map<String, dynamic> json) =>
      _$SubscribeHlsPayloadFromJson(json);

  @override
  final String roomId;
  @override
  final String participantId;
  @override
  final String targetId;

  /// Create a copy of SubscribeHlsPayload
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$SubscribeHlsPayloadCopyWith<_SubscribeHlsPayload> get copyWith =>
      __$SubscribeHlsPayloadCopyWithImpl<_SubscribeHlsPayload>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$SubscribeHlsPayloadToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SubscribeHlsPayload &&
            (identical(other.roomId, roomId) || other.roomId == roomId) &&
            (identical(other.participantId, participantId) ||
                other.participantId == participantId) &&
            (identical(other.targetId, targetId) ||
                other.targetId == targetId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, roomId, participantId, targetId);

  @override
  String toString() {
    return 'SubscribeHlsPayload(roomId: $roomId, participantId: $participantId, targetId: $targetId)';
  }
}

/// @nodoc
abstract mixin class _$SubscribeHlsPayloadCopyWith<$Res>
    implements $SubscribeHlsPayloadCopyWith<$Res> {
  factory _$SubscribeHlsPayloadCopyWith(_SubscribeHlsPayload value,
          $Res Function(_SubscribeHlsPayload) _then) =
      __$SubscribeHlsPayloadCopyWithImpl;
  @override
  @useResult
  $Res call({String roomId, String participantId, String targetId});
}

/// @nodoc
class __$SubscribeHlsPayloadCopyWithImpl<$Res>
    implements _$SubscribeHlsPayloadCopyWith<$Res> {
  __$SubscribeHlsPayloadCopyWithImpl(this._self, this._then);

  final _SubscribeHlsPayload _self;
  final $Res Function(_SubscribeHlsPayload) _then;

  /// Create a copy of SubscribeHlsPayload
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? roomId = null,
    Object? participantId = null,
    Object? targetId = null,
  }) {
    return _then(_SubscribeHlsPayload(
      roomId: null == roomId
          ? _self.roomId
          : roomId // ignore: cast_nullable_to_non_nullable
              as String,
      participantId: null == participantId
          ? _self.participantId
          : participantId // ignore: cast_nullable_to_non_nullable
              as String,
      targetId: null == targetId
          ? _self.targetId
          : targetId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
