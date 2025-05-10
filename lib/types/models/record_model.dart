import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';

part 'record_model.freezed.dart';
part 'record_model.g.dart';

@freezed
sealed class RecordModel with _$RecordModel {
  const factory RecordModel({
    required int id,
    required Meeting meeting,
    required String urlToVideo,
    required String thumbnail,
    required int duration,
    required DateTime createdAt,
  }) = _RecordModel;

  factory RecordModel.fromJson(Map<String, Object?> json) =>
      _$RecordModelFromJson(json);
  // RecordModel copyWith({
  //   int? id,
  //   Meeting? meeting,
  //   String? urlToVideo,
  //   String? thumbnail,
  //   int? duration,
  //   DateTime? createdAt,
  // }) {
  //   return RecordModel(
  //     id: id ?? this.id,
  //     meeting: meeting ?? this.meeting,
  //     urlToVideo: urlToVideo ?? this.urlToVideo,
  //     thumbnail: thumbnail ?? this.thumbnail,
  //     duration: duration ?? this.duration,
  //     createdAt: createdAt ?? this.createdAt,
  //   );
  // }

  // Map<String, dynamic> toMap() {
  //   return <String, dynamic>{
  //     'id': id,
  //     'meeting': meeting.toJson,
  //     'urlToVideo': urlToVideo,
  //     'thumbnail': thumbnail,
  //     'duration': duration,
  //     'createdAt': createdAt.toString(),
  //   };
  // }

  // factory RecordModel.fromMap(Map<String, dynamic> map) {
  //   return RecordModel(
  //     id: map['id'] as int,
  //     meeting: Meeting.fromJson(map['meeting'] as Map<String, dynamic>),
  //     urlToVideo: map['urlToVideo'] ?? '',
  //     thumbnail: map['thumbnail'] ?? '',
  //     duration: map['duration'] ?? 0,
  //     createdAt: DateTime.parse(map['createdAt']).toLocal(),
  //   );
  // }

  // String toJson() => json.encode(toMap());

  // factory RecordModel.fromJson(String source) =>
  //     RecordModel.fromMap(json.decode(source) as Map<String, dynamic>);

  // @override
  // String toString() {
  //   return 'RecordModel(id: $id, meeting: $meeting, urlToVideo: $urlToVideo, thumbnail: $thumbnail, duration: $duration, createdAt: $createdAt)';
  // }

  // @override
  // bool operator ==(covariant RecordModel other) {
  //   if (identical(this, other)) return true;

  //   return other.id == id &&
  //       other.meeting == meeting &&
  //       other.urlToVideo == urlToVideo &&
  //       other.thumbnail == thumbnail &&
  //       other.duration == duration &&
  //       other.createdAt == createdAt;
  // }

  // @override
  // int get hashCode {
  //   return id.hashCode ^
  //       meeting.hashCode ^
  //       urlToVideo.hashCode ^
  //       thumbnail.hashCode ^
  //       duration.hashCode ^
  //       createdAt.hashCode;
  // }
}
