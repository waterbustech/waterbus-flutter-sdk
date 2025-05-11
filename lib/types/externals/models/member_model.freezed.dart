// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'member_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Member {
  int get id;
  MeetingRole get role;
  User get user;
  bool get isMe;
  int? get meetingId;
  MemberStatusEnum get status;

  /// Create a copy of Member
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MemberCopyWith<Member> get copyWith =>
      _$MemberCopyWithImpl<Member>(this as Member, _$identity);

  /// Serializes this Member to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Member &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.isMe, isMe) || other.isMe == isMe) &&
            (identical(other.meetingId, meetingId) ||
                other.meetingId == meetingId) &&
            (identical(other.status, status) || other.status == status));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, role, user, isMe, meetingId, status);

  @override
  String toString() {
    return 'Member(id: $id, role: $role, user: $user, isMe: $isMe, meetingId: $meetingId, status: $status)';
  }
}

/// @nodoc
abstract mixin class $MemberCopyWith<$Res> {
  factory $MemberCopyWith(Member value, $Res Function(Member) _then) =
      _$MemberCopyWithImpl;
  @useResult
  $Res call(
      {int id,
      MeetingRole role,
      User user,
      bool isMe,
      int? meetingId,
      MemberStatusEnum status});

  $UserCopyWith<$Res> get user;
}

/// @nodoc
class _$MemberCopyWithImpl<$Res> implements $MemberCopyWith<$Res> {
  _$MemberCopyWithImpl(this._self, this._then);

  final Member _self;
  final $Res Function(Member) _then;

  /// Create a copy of Member
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? role = null,
    Object? user = null,
    Object? isMe = null,
    Object? meetingId = freezed,
    Object? status = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      role: null == role
          ? _self.role
          : role // ignore: cast_nullable_to_non_nullable
              as MeetingRole,
      user: null == user
          ? _self.user
          : user // ignore: cast_nullable_to_non_nullable
              as User,
      isMe: null == isMe
          ? _self.isMe
          : isMe // ignore: cast_nullable_to_non_nullable
              as bool,
      meetingId: freezed == meetingId
          ? _self.meetingId
          : meetingId // ignore: cast_nullable_to_non_nullable
              as int?,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as MemberStatusEnum,
    ));
  }

  /// Create a copy of Member
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserCopyWith<$Res> get user {
    return $UserCopyWith<$Res>(_self.user, (value) {
      return _then(_self.copyWith(user: value));
    });
  }
}

/// @nodoc
@JsonSerializable()
class _Member implements Member {
  const _Member(
      {required this.id,
      required this.role,
      required this.user,
      this.isMe = false,
      this.meetingId,
      this.status = MemberStatusEnum.joined});
  factory _Member.fromJson(Map<String, dynamic> json) => _$MemberFromJson(json);

  @override
  final int id;
  @override
  final MeetingRole role;
  @override
  final User user;
  @override
  @JsonKey()
  final bool isMe;
  @override
  final int? meetingId;
  @override
  @JsonKey()
  final MemberStatusEnum status;

  /// Create a copy of Member
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$MemberCopyWith<_Member> get copyWith =>
      __$MemberCopyWithImpl<_Member>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$MemberToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Member &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.isMe, isMe) || other.isMe == isMe) &&
            (identical(other.meetingId, meetingId) ||
                other.meetingId == meetingId) &&
            (identical(other.status, status) || other.status == status));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, role, user, isMe, meetingId, status);

  @override
  String toString() {
    return 'Member(id: $id, role: $role, user: $user, isMe: $isMe, meetingId: $meetingId, status: $status)';
  }
}

/// @nodoc
abstract mixin class _$MemberCopyWith<$Res> implements $MemberCopyWith<$Res> {
  factory _$MemberCopyWith(_Member value, $Res Function(_Member) _then) =
      __$MemberCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int id,
      MeetingRole role,
      User user,
      bool isMe,
      int? meetingId,
      MemberStatusEnum status});

  @override
  $UserCopyWith<$Res> get user;
}

/// @nodoc
class __$MemberCopyWithImpl<$Res> implements _$MemberCopyWith<$Res> {
  __$MemberCopyWithImpl(this._self, this._then);

  final _Member _self;
  final $Res Function(_Member) _then;

  /// Create a copy of Member
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? role = null,
    Object? user = null,
    Object? isMe = null,
    Object? meetingId = freezed,
    Object? status = null,
  }) {
    return _then(_Member(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      role: null == role
          ? _self.role
          : role // ignore: cast_nullable_to_non_nullable
              as MeetingRole,
      user: null == user
          ? _self.user
          : user // ignore: cast_nullable_to_non_nullable
              as User,
      isMe: null == isMe
          ? _self.isMe
          : isMe // ignore: cast_nullable_to_non_nullable
              as bool,
      meetingId: freezed == meetingId
          ? _self.meetingId
          : meetingId // ignore: cast_nullable_to_non_nullable
              as int?,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as MemberStatusEnum,
    ));
  }

  /// Create a copy of Member
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserCopyWith<$Res> get user {
    return $UserCopyWith<$Res>(_self.user, (value) {
      return _then(_self.copyWith(user: value));
    });
  }
}

// dart format on
