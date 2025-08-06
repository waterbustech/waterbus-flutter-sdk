// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'room.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Room {
  int get id;
  String get title;
  List<ParticipantInfo> get participants;
  List<Member> get members;
  String? get code;
  DateTime? get createdAt;
  DateTime? get latestJoinedAt;
  RoomStatus get status;
  Message? get latestMessage;
  String? get avatar;
  StreamingProtocol get streamingProtocol;
  RoomType get roomType;
  bool get isProtected; // Null is unlimited
  int? get capacity;

  /// Create a copy of Room
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $RoomCopyWith<Room> get copyWith =>
      _$RoomCopyWithImpl<Room>(this as Room, _$identity);

  /// Serializes this Room to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Room &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            const DeepCollectionEquality()
                .equals(other.participants, participants) &&
            const DeepCollectionEquality().equals(other.members, members) &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.latestJoinedAt, latestJoinedAt) ||
                other.latestJoinedAt == latestJoinedAt) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.latestMessage, latestMessage) ||
                other.latestMessage == latestMessage) &&
            (identical(other.avatar, avatar) || other.avatar == avatar) &&
            (identical(other.streamingProtocol, streamingProtocol) ||
                other.streamingProtocol == streamingProtocol) &&
            (identical(other.roomType, roomType) ||
                other.roomType == roomType) &&
            (identical(other.isProtected, isProtected) ||
                other.isProtected == isProtected) &&
            (identical(other.capacity, capacity) ||
                other.capacity == capacity));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      title,
      const DeepCollectionEquality().hash(participants),
      const DeepCollectionEquality().hash(members),
      code,
      createdAt,
      latestJoinedAt,
      status,
      latestMessage,
      avatar,
      streamingProtocol,
      roomType,
      isProtected,
      capacity);

  @override
  String toString() {
    return 'Room(id: $id, title: $title, participants: $participants, members: $members, code: $code, createdAt: $createdAt, latestJoinedAt: $latestJoinedAt, status: $status, latestMessage: $latestMessage, avatar: $avatar, streamingProtocol: $streamingProtocol, roomType: $roomType, isProtected: $isProtected, capacity: $capacity)';
  }
}

/// @nodoc
abstract mixin class $RoomCopyWith<$Res> {
  factory $RoomCopyWith(Room value, $Res Function(Room) _then) =
      _$RoomCopyWithImpl;
  @useResult
  $Res call(
      {int id,
      String title,
      List<ParticipantInfo> participants,
      List<Member> members,
      String? code,
      DateTime? createdAt,
      DateTime? latestJoinedAt,
      RoomStatus status,
      Message? latestMessage,
      String? avatar,
      StreamingProtocol streamingProtocol,
      RoomType roomType,
      bool isProtected,
      int? capacity});

  $MessageCopyWith<$Res>? get latestMessage;
}

/// @nodoc
class _$RoomCopyWithImpl<$Res> implements $RoomCopyWith<$Res> {
  _$RoomCopyWithImpl(this._self, this._then);

  final Room _self;
  final $Res Function(Room) _then;

  /// Create a copy of Room
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? participants = null,
    Object? members = null,
    Object? code = freezed,
    Object? createdAt = freezed,
    Object? latestJoinedAt = freezed,
    Object? status = null,
    Object? latestMessage = freezed,
    Object? avatar = freezed,
    Object? streamingProtocol = null,
    Object? roomType = null,
    Object? isProtected = null,
    Object? capacity = freezed,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      participants: null == participants
          ? _self.participants
          : participants // ignore: cast_nullable_to_non_nullable
              as List<ParticipantInfo>,
      members: null == members
          ? _self.members
          : members // ignore: cast_nullable_to_non_nullable
              as List<Member>,
      code: freezed == code
          ? _self.code
          : code // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      latestJoinedAt: freezed == latestJoinedAt
          ? _self.latestJoinedAt
          : latestJoinedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as RoomStatus,
      latestMessage: freezed == latestMessage
          ? _self.latestMessage
          : latestMessage // ignore: cast_nullable_to_non_nullable
              as Message?,
      avatar: freezed == avatar
          ? _self.avatar
          : avatar // ignore: cast_nullable_to_non_nullable
              as String?,
      streamingProtocol: null == streamingProtocol
          ? _self.streamingProtocol
          : streamingProtocol // ignore: cast_nullable_to_non_nullable
              as StreamingProtocol,
      roomType: null == roomType
          ? _self.roomType
          : roomType // ignore: cast_nullable_to_non_nullable
              as RoomType,
      isProtected: null == isProtected
          ? _self.isProtected
          : isProtected // ignore: cast_nullable_to_non_nullable
              as bool,
      capacity: freezed == capacity
          ? _self.capacity
          : capacity // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }

  /// Create a copy of Room
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MessageCopyWith<$Res>? get latestMessage {
    if (_self.latestMessage == null) {
      return null;
    }

    return $MessageCopyWith<$Res>(_self.latestMessage!, (value) {
      return _then(_self.copyWith(latestMessage: value));
    });
  }
}

/// @nodoc
@JsonSerializable()
class _Room implements Room {
  const _Room(
      {this.id = -1,
      required this.title,
      final List<ParticipantInfo> participants = const [],
      final List<Member> members = const [],
      this.code,
      this.createdAt,
      this.latestJoinedAt,
      this.status = RoomStatus.active,
      this.latestMessage,
      this.avatar,
      this.streamingProtocol = StreamingProtocol.sfu,
      this.roomType = RoomType.videoConferencing,
      this.isProtected = false,
      this.capacity})
      : _participants = participants,
        _members = members;
  factory _Room.fromJson(Map<String, dynamic> json) => _$RoomFromJson(json);

  @override
  @JsonKey()
  final int id;
  @override
  final String title;
  final List<ParticipantInfo> _participants;
  @override
  @JsonKey()
  List<ParticipantInfo> get participants {
    if (_participants is EqualUnmodifiableListView) return _participants;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_participants);
  }

  final List<Member> _members;
  @override
  @JsonKey()
  List<Member> get members {
    if (_members is EqualUnmodifiableListView) return _members;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_members);
  }

  @override
  final String? code;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? latestJoinedAt;
  @override
  @JsonKey()
  final RoomStatus status;
  @override
  final Message? latestMessage;
  @override
  final String? avatar;
  @override
  @JsonKey()
  final StreamingProtocol streamingProtocol;
  @override
  @JsonKey()
  final RoomType roomType;
  @override
  @JsonKey()
  final bool isProtected;
// Null is unlimited
  @override
  final int? capacity;

  /// Create a copy of Room
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$RoomCopyWith<_Room> get copyWith =>
      __$RoomCopyWithImpl<_Room>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$RoomToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Room &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            const DeepCollectionEquality()
                .equals(other._participants, _participants) &&
            const DeepCollectionEquality().equals(other._members, _members) &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.latestJoinedAt, latestJoinedAt) ||
                other.latestJoinedAt == latestJoinedAt) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.latestMessage, latestMessage) ||
                other.latestMessage == latestMessage) &&
            (identical(other.avatar, avatar) || other.avatar == avatar) &&
            (identical(other.streamingProtocol, streamingProtocol) ||
                other.streamingProtocol == streamingProtocol) &&
            (identical(other.roomType, roomType) ||
                other.roomType == roomType) &&
            (identical(other.isProtected, isProtected) ||
                other.isProtected == isProtected) &&
            (identical(other.capacity, capacity) ||
                other.capacity == capacity));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      title,
      const DeepCollectionEquality().hash(_participants),
      const DeepCollectionEquality().hash(_members),
      code,
      createdAt,
      latestJoinedAt,
      status,
      latestMessage,
      avatar,
      streamingProtocol,
      roomType,
      isProtected,
      capacity);

  @override
  String toString() {
    return 'Room(id: $id, title: $title, participants: $participants, members: $members, code: $code, createdAt: $createdAt, latestJoinedAt: $latestJoinedAt, status: $status, latestMessage: $latestMessage, avatar: $avatar, streamingProtocol: $streamingProtocol, roomType: $roomType, isProtected: $isProtected, capacity: $capacity)';
  }
}

/// @nodoc
abstract mixin class _$RoomCopyWith<$Res> implements $RoomCopyWith<$Res> {
  factory _$RoomCopyWith(_Room value, $Res Function(_Room) _then) =
      __$RoomCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int id,
      String title,
      List<ParticipantInfo> participants,
      List<Member> members,
      String? code,
      DateTime? createdAt,
      DateTime? latestJoinedAt,
      RoomStatus status,
      Message? latestMessage,
      String? avatar,
      StreamingProtocol streamingProtocol,
      RoomType roomType,
      bool isProtected,
      int? capacity});

  @override
  $MessageCopyWith<$Res>? get latestMessage;
}

/// @nodoc
class __$RoomCopyWithImpl<$Res> implements _$RoomCopyWith<$Res> {
  __$RoomCopyWithImpl(this._self, this._then);

  final _Room _self;
  final $Res Function(_Room) _then;

  /// Create a copy of Room
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? participants = null,
    Object? members = null,
    Object? code = freezed,
    Object? createdAt = freezed,
    Object? latestJoinedAt = freezed,
    Object? status = null,
    Object? latestMessage = freezed,
    Object? avatar = freezed,
    Object? streamingProtocol = null,
    Object? roomType = null,
    Object? isProtected = null,
    Object? capacity = freezed,
  }) {
    return _then(_Room(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      participants: null == participants
          ? _self._participants
          : participants // ignore: cast_nullable_to_non_nullable
              as List<ParticipantInfo>,
      members: null == members
          ? _self._members
          : members // ignore: cast_nullable_to_non_nullable
              as List<Member>,
      code: freezed == code
          ? _self.code
          : code // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      latestJoinedAt: freezed == latestJoinedAt
          ? _self.latestJoinedAt
          : latestJoinedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as RoomStatus,
      latestMessage: freezed == latestMessage
          ? _self.latestMessage
          : latestMessage // ignore: cast_nullable_to_non_nullable
              as Message?,
      avatar: freezed == avatar
          ? _self.avatar
          : avatar // ignore: cast_nullable_to_non_nullable
              as String?,
      streamingProtocol: null == streamingProtocol
          ? _self.streamingProtocol
          : streamingProtocol // ignore: cast_nullable_to_non_nullable
              as StreamingProtocol,
      roomType: null == roomType
          ? _self.roomType
          : roomType // ignore: cast_nullable_to_non_nullable
              as RoomType,
      isProtected: null == isProtected
          ? _self.isProtected
          : isProtected // ignore: cast_nullable_to_non_nullable
              as bool,
      capacity: freezed == capacity
          ? _self.capacity
          : capacity // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }

  /// Create a copy of Room
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MessageCopyWith<$Res>? get latestMessage {
    if (_self.latestMessage == null) {
      return null;
    }

    return $MessageCopyWith<$Res>(_self.latestMessage!, (value) {
      return _then(_self.copyWith(latestMessage: value));
    });
  }
}

// dart format on
