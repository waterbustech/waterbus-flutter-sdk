import 'package:freezed_annotation/freezed_annotation.dart';

part 'video_quality.freezed.dart';
part 'video_quality.g.dart';

@freezed
abstract class VideoQuality with _$VideoQuality {
  const factory VideoQuality({
    required int minHeight,
    required int minWidth,
    required int minFrameRate,
  }) = _VideoQuality;

  factory VideoQuality.fromJson(Map<String, Object?> json) =>
      _$VideoQualityFromJson(json);
}
