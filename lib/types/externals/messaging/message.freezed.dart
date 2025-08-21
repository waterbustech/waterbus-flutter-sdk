// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'message.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Message {
  int get id;
  String get data;
  @IntConverter()
  int? get roomId;
  User? get createdBy;
  SendingStatusEnum get sendingStatus;
  MessageStatusEnum get status;
  int get type;
  DateTime get createdAt;
  DateTime get updatedAt;

  /// Create a copy of Message
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MessageCopyWith<Message> get copyWith =>
      _$MessageCopyWithImpl<Message>(this as Message, _$identity);

  /// Serializes this Message to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Message &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.data, data) || other.data == data) &&
            (identical(other.roomId, roomId) || other.roomId == roomId) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            (identical(other.sendingStatus, sendingStatus) ||
                other.sendingStatus == sendingStatus) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, data, roomId, createdBy,
      sendingStatus, status, type, createdAt, updatedAt);

  @override
  String toString() {
    return 'Message(id: $id, data: $data, roomId: $roomId, createdBy: $createdBy, sendingStatus: $sendingStatus, status: $status, type: $type, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class $MessageCopyWith<$Res> {
  factory $MessageCopyWith(Message value, $Res Function(Message) _then) =
      _$MessageCopyWithImpl;
  @useResult
  $Res call(
      {int id,
      String data,
      @IntConverter() int? roomId,
      User? createdBy,
      SendingStatusEnum sendingStatus,
      MessageStatusEnum status,
      int type,
      DateTime createdAt,
      DateTime updatedAt});

  $UserCopyWith<$Res>? get createdBy;
}

/// @nodoc
class _$MessageCopyWithImpl<$Res> implements $MessageCopyWith<$Res> {
  _$MessageCopyWithImpl(this._self, this._then);

  final Message _self;
  final $Res Function(Message) _then;

  /// Create a copy of Message
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? data = null,
    Object? roomId = freezed,
    Object? createdBy = freezed,
    Object? sendingStatus = null,
    Object? status = null,
    Object? type = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      data: null == data
          ? _self.data
          : data // ignore: cast_nullable_to_non_nullable
              as String,
      roomId: freezed == roomId
          ? _self.roomId
          : roomId // ignore: cast_nullable_to_non_nullable
              as int?,
      createdBy: freezed == createdBy
          ? _self.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as User?,
      sendingStatus: null == sendingStatus
          ? _self.sendingStatus
          : sendingStatus // ignore: cast_nullable_to_non_nullable
              as SendingStatusEnum,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as MessageStatusEnum,
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }

  /// Create a copy of Message
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserCopyWith<$Res>? get createdBy {
    if (_self.createdBy == null) {
      return null;
    }

    return $UserCopyWith<$Res>(_self.createdBy!, (value) {
      return _then(_self.copyWith(createdBy: value));
    });
  }
}

/// Adds pattern-matching-related methods to [Message].
extension MessagePatterns on Message {
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
    TResult Function(_Message value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Message() when $default != null:
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
    TResult Function(_Message value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Message():
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
    TResult? Function(_Message value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Message() when $default != null:
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
            int id,
            String data,
            @IntConverter() int? roomId,
            User? createdBy,
            SendingStatusEnum sendingStatus,
            MessageStatusEnum status,
            int type,
            DateTime createdAt,
            DateTime updatedAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Message() when $default != null:
        return $default(
            _that.id,
            _that.data,
            _that.roomId,
            _that.createdBy,
            _that.sendingStatus,
            _that.status,
            _that.type,
            _that.createdAt,
            _that.updatedAt);
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
            int id,
            String data,
            @IntConverter() int? roomId,
            User? createdBy,
            SendingStatusEnum sendingStatus,
            MessageStatusEnum status,
            int type,
            DateTime createdAt,
            DateTime updatedAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Message():
        return $default(
            _that.id,
            _that.data,
            _that.roomId,
            _that.createdBy,
            _that.sendingStatus,
            _that.status,
            _that.type,
            _that.createdAt,
            _that.updatedAt);
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
            int id,
            String data,
            @IntConverter() int? roomId,
            User? createdBy,
            SendingStatusEnum sendingStatus,
            MessageStatusEnum status,
            int type,
            DateTime createdAt,
            DateTime updatedAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Message() when $default != null:
        return $default(
            _that.id,
            _that.data,
            _that.roomId,
            _that.createdBy,
            _that.sendingStatus,
            _that.status,
            _that.type,
            _that.createdAt,
            _that.updatedAt);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _Message implements Message {
  const _Message(
      {required this.id,
      required this.data,
      @IntConverter() this.roomId,
      required this.createdBy,
      this.sendingStatus = SendingStatusEnum.sent,
      required this.status,
      required this.type,
      required this.createdAt,
      required this.updatedAt});
  factory _Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(json);

  @override
  final int id;
  @override
  final String data;
  @override
  @IntConverter()
  final int? roomId;
  @override
  final User? createdBy;
  @override
  @JsonKey()
  final SendingStatusEnum sendingStatus;
  @override
  final MessageStatusEnum status;
  @override
  final int type;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  /// Create a copy of Message
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$MessageCopyWith<_Message> get copyWith =>
      __$MessageCopyWithImpl<_Message>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$MessageToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Message &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.data, data) || other.data == data) &&
            (identical(other.roomId, roomId) || other.roomId == roomId) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            (identical(other.sendingStatus, sendingStatus) ||
                other.sendingStatus == sendingStatus) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, data, roomId, createdBy,
      sendingStatus, status, type, createdAt, updatedAt);

  @override
  String toString() {
    return 'Message(id: $id, data: $data, roomId: $roomId, createdBy: $createdBy, sendingStatus: $sendingStatus, status: $status, type: $type, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class _$MessageCopyWith<$Res> implements $MessageCopyWith<$Res> {
  factory _$MessageCopyWith(_Message value, $Res Function(_Message) _then) =
      __$MessageCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int id,
      String data,
      @IntConverter() int? roomId,
      User? createdBy,
      SendingStatusEnum sendingStatus,
      MessageStatusEnum status,
      int type,
      DateTime createdAt,
      DateTime updatedAt});

  @override
  $UserCopyWith<$Res>? get createdBy;
}

/// @nodoc
class __$MessageCopyWithImpl<$Res> implements _$MessageCopyWith<$Res> {
  __$MessageCopyWithImpl(this._self, this._then);

  final _Message _self;
  final $Res Function(_Message) _then;

  /// Create a copy of Message
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? data = null,
    Object? roomId = freezed,
    Object? createdBy = freezed,
    Object? sendingStatus = null,
    Object? status = null,
    Object? type = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_Message(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      data: null == data
          ? _self.data
          : data // ignore: cast_nullable_to_non_nullable
              as String,
      roomId: freezed == roomId
          ? _self.roomId
          : roomId // ignore: cast_nullable_to_non_nullable
              as int?,
      createdBy: freezed == createdBy
          ? _self.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as User?,
      sendingStatus: null == sendingStatus
          ? _self.sendingStatus
          : sendingStatus // ignore: cast_nullable_to_non_nullable
              as SendingStatusEnum,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as MessageStatusEnum,
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }

  /// Create a copy of Message
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserCopyWith<$Res>? get createdBy {
    if (_self.createdBy == null) {
      return null;
    }

    return $UserCopyWith<$Res>(_self.createdBy!, (value) {
      return _then(_self.copyWith(createdBy: value));
    });
  }
}

// dart format on
