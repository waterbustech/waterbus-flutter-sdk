// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'meeting_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Meeting {
  int get id;
  String get title;
  List<Participant> get participants;
  List<Member> get members;
  int get code;
  DateTime? get createdAt;
  DateTime? get latestJoinedAt;
  MeetingStatus get status;
  MessageModel? get latestMessage;
  String? get avatar;

  /// Create a copy of Meeting
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MeetingCopyWith<Meeting> get copyWith =>
      _$MeetingCopyWithImpl<Meeting>(this as Meeting, _$identity);

  /// Serializes this Meeting to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Meeting &&
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
            (identical(other.avatar, avatar) || other.avatar == avatar));
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
      avatar);

  @override
  String toString() {
    return 'Meeting(id: $id, title: $title, participants: $participants, members: $members, code: $code, createdAt: $createdAt, latestJoinedAt: $latestJoinedAt, status: $status, latestMessage: $latestMessage, avatar: $avatar)';
  }
}

/// @nodoc
abstract mixin class $MeetingCopyWith<$Res> {
  factory $MeetingCopyWith(Meeting value, $Res Function(Meeting) _then) =
      _$MeetingCopyWithImpl;
  @useResult
  $Res call(
      {int id,
      String title,
      List<Participant> participants,
      List<Member> members,
      int code,
      DateTime? createdAt,
      DateTime? latestJoinedAt,
      MeetingStatus status,
      MessageModel? latestMessage,
      String? avatar});

  $MessageModelCopyWith<$Res>? get latestMessage;
}

/// @nodoc
class _$MeetingCopyWithImpl<$Res> implements $MeetingCopyWith<$Res> {
  _$MeetingCopyWithImpl(this._self, this._then);

  final Meeting _self;
  final $Res Function(Meeting) _then;

  /// Create a copy of Meeting
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? participants = null,
    Object? members = null,
    Object? code = null,
    Object? createdAt = freezed,
    Object? latestJoinedAt = freezed,
    Object? status = null,
    Object? latestMessage = freezed,
    Object? avatar = freezed,
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
              as List<Participant>,
      members: null == members
          ? _self.members
          : members // ignore: cast_nullable_to_non_nullable
              as List<Member>,
      code: null == code
          ? _self.code
          : code // ignore: cast_nullable_to_non_nullable
              as int,
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
              as MeetingStatus,
      latestMessage: freezed == latestMessage
          ? _self.latestMessage
          : latestMessage // ignore: cast_nullable_to_non_nullable
              as MessageModel?,
      avatar: freezed == avatar
          ? _self.avatar
          : avatar // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }

  /// Create a copy of Meeting
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MessageModelCopyWith<$Res>? get latestMessage {
    if (_self.latestMessage == null) {
      return null;
    }

    return $MessageModelCopyWith<$Res>(_self.latestMessage!, (value) {
      return _then(_self.copyWith(latestMessage: value));
    });
  }
}

/// @nodoc
@JsonSerializable()
class _Meeting implements Meeting {
  const _Meeting(
      {this.id = -1,
      required this.title,
      final List<Participant> participants = const [],
      final List<Member> members = const [],
      this.code = -1,
      this.createdAt,
      this.latestJoinedAt,
      this.status = MeetingStatus.active,
      this.latestMessage,
      this.avatar})
      : _participants = participants,
        _members = members;
  factory _Meeting.fromJson(Map<String, dynamic> json) =>
      _$MeetingFromJson(json);

  @override
  @JsonKey()
  final int id;
  @override
  final String title;
  final List<Participant> _participants;
  @override
  @JsonKey()
  List<Participant> get participants {
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
  @JsonKey()
  final int code;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? latestJoinedAt;
  @override
  @JsonKey()
  final MeetingStatus status;
  @override
  final MessageModel? latestMessage;
  @override
  final String? avatar;

  /// Create a copy of Meeting
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$MeetingCopyWith<_Meeting> get copyWith =>
      __$MeetingCopyWithImpl<_Meeting>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$MeetingToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Meeting &&
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
            (identical(other.avatar, avatar) || other.avatar == avatar));
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
      avatar);

  @override
  String toString() {
    return 'Meeting(id: $id, title: $title, participants: $participants, members: $members, code: $code, createdAt: $createdAt, latestJoinedAt: $latestJoinedAt, status: $status, latestMessage: $latestMessage, avatar: $avatar)';
  }
}

/// @nodoc
abstract mixin class _$MeetingCopyWith<$Res> implements $MeetingCopyWith<$Res> {
  factory _$MeetingCopyWith(_Meeting value, $Res Function(_Meeting) _then) =
      __$MeetingCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int id,
      String title,
      List<Participant> participants,
      List<Member> members,
      int code,
      DateTime? createdAt,
      DateTime? latestJoinedAt,
      MeetingStatus status,
      MessageModel? latestMessage,
      String? avatar});

  @override
  $MessageModelCopyWith<$Res>? get latestMessage;
}

/// @nodoc
class __$MeetingCopyWithImpl<$Res> implements _$MeetingCopyWith<$Res> {
  __$MeetingCopyWithImpl(this._self, this._then);

  final _Meeting _self;
  final $Res Function(_Meeting) _then;

  /// Create a copy of Meeting
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? participants = null,
    Object? members = null,
    Object? code = null,
    Object? createdAt = freezed,
    Object? latestJoinedAt = freezed,
    Object? status = null,
    Object? latestMessage = freezed,
    Object? avatar = freezed,
  }) {
    return _then(_Meeting(
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
              as List<Participant>,
      members: null == members
          ? _self._members
          : members // ignore: cast_nullable_to_non_nullable
              as List<Member>,
      code: null == code
          ? _self.code
          : code // ignore: cast_nullable_to_non_nullable
              as int,
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
              as MeetingStatus,
      latestMessage: freezed == latestMessage
          ? _self.latestMessage
          : latestMessage // ignore: cast_nullable_to_non_nullable
              as MessageModel?,
      avatar: freezed == avatar
          ? _self.avatar
          : avatar // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }

  /// Create a copy of Meeting
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MessageModelCopyWith<$Res>? get latestMessage {
    if (_self.latestMessage == null) {
      return null;
    }

    return $MessageModelCopyWith<$Res>(_self.latestMessage!, (value) {
      return _then(_self.copyWith(latestMessage: value));
    });
  }
}

// dart format on
