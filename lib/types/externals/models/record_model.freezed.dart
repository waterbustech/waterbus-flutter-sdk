// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'record_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RecordModel {
  int get id;
  Meeting get meeting;
  String get urlToVideo;
  String get thumbnail;
  int get duration;
  DateTime get createdAt;

  /// Create a copy of RecordModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $RecordModelCopyWith<RecordModel> get copyWith =>
      _$RecordModelCopyWithImpl<RecordModel>(this as RecordModel, _$identity);

  /// Serializes this RecordModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is RecordModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.meeting, meeting) || other.meeting == meeting) &&
            (identical(other.urlToVideo, urlToVideo) ||
                other.urlToVideo == urlToVideo) &&
            (identical(other.thumbnail, thumbnail) ||
                other.thumbnail == thumbnail) &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, meeting, urlToVideo, thumbnail, duration, createdAt);

  @override
  String toString() {
    return 'RecordModel(id: $id, meeting: $meeting, urlToVideo: $urlToVideo, thumbnail: $thumbnail, duration: $duration, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class $RecordModelCopyWith<$Res> {
  factory $RecordModelCopyWith(
          RecordModel value, $Res Function(RecordModel) _then) =
      _$RecordModelCopyWithImpl;
  @useResult
  $Res call(
      {int id,
      Meeting meeting,
      String urlToVideo,
      String thumbnail,
      int duration,
      DateTime createdAt});

  $MeetingCopyWith<$Res> get meeting;
}

/// @nodoc
class _$RecordModelCopyWithImpl<$Res> implements $RecordModelCopyWith<$Res> {
  _$RecordModelCopyWithImpl(this._self, this._then);

  final RecordModel _self;
  final $Res Function(RecordModel) _then;

  /// Create a copy of RecordModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? meeting = null,
    Object? urlToVideo = null,
    Object? thumbnail = null,
    Object? duration = null,
    Object? createdAt = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      meeting: null == meeting
          ? _self.meeting
          : meeting // ignore: cast_nullable_to_non_nullable
              as Meeting,
      urlToVideo: null == urlToVideo
          ? _self.urlToVideo
          : urlToVideo // ignore: cast_nullable_to_non_nullable
              as String,
      thumbnail: null == thumbnail
          ? _self.thumbnail
          : thumbnail // ignore: cast_nullable_to_non_nullable
              as String,
      duration: null == duration
          ? _self.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }

  /// Create a copy of RecordModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MeetingCopyWith<$Res> get meeting {
    return $MeetingCopyWith<$Res>(_self.meeting, (value) {
      return _then(_self.copyWith(meeting: value));
    });
  }
}

/// @nodoc
@JsonSerializable()
class _RecordModel implements RecordModel {
  const _RecordModel(
      {required this.id,
      required this.meeting,
      required this.urlToVideo,
      required this.thumbnail,
      required this.duration,
      required this.createdAt});
  factory _RecordModel.fromJson(Map<String, dynamic> json) =>
      _$RecordModelFromJson(json);

  @override
  final int id;
  @override
  final Meeting meeting;
  @override
  final String urlToVideo;
  @override
  final String thumbnail;
  @override
  final int duration;
  @override
  final DateTime createdAt;

  /// Create a copy of RecordModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$RecordModelCopyWith<_RecordModel> get copyWith =>
      __$RecordModelCopyWithImpl<_RecordModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$RecordModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _RecordModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.meeting, meeting) || other.meeting == meeting) &&
            (identical(other.urlToVideo, urlToVideo) ||
                other.urlToVideo == urlToVideo) &&
            (identical(other.thumbnail, thumbnail) ||
                other.thumbnail == thumbnail) &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, meeting, urlToVideo, thumbnail, duration, createdAt);

  @override
  String toString() {
    return 'RecordModel(id: $id, meeting: $meeting, urlToVideo: $urlToVideo, thumbnail: $thumbnail, duration: $duration, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class _$RecordModelCopyWith<$Res>
    implements $RecordModelCopyWith<$Res> {
  factory _$RecordModelCopyWith(
          _RecordModel value, $Res Function(_RecordModel) _then) =
      __$RecordModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int id,
      Meeting meeting,
      String urlToVideo,
      String thumbnail,
      int duration,
      DateTime createdAt});

  @override
  $MeetingCopyWith<$Res> get meeting;
}

/// @nodoc
class __$RecordModelCopyWithImpl<$Res> implements _$RecordModelCopyWith<$Res> {
  __$RecordModelCopyWithImpl(this._self, this._then);

  final _RecordModel _self;
  final $Res Function(_RecordModel) _then;

  /// Create a copy of RecordModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? meeting = null,
    Object? urlToVideo = null,
    Object? thumbnail = null,
    Object? duration = null,
    Object? createdAt = null,
  }) {
    return _then(_RecordModel(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      meeting: null == meeting
          ? _self.meeting
          : meeting // ignore: cast_nullable_to_non_nullable
              as Meeting,
      urlToVideo: null == urlToVideo
          ? _self.urlToVideo
          : urlToVideo // ignore: cast_nullable_to_non_nullable
              as String,
      thumbnail: null == thumbnail
          ? _self.thumbnail
          : thumbnail // ignore: cast_nullable_to_non_nullable
              as String,
      duration: null == duration
          ? _self.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }

  /// Create a copy of RecordModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MeetingCopyWith<$Res> get meeting {
    return $MeetingCopyWith<$Res>(_self.meeting, (value) {
      return _then(_self.copyWith(meeting: value));
    });
  }
}

// dart format on
