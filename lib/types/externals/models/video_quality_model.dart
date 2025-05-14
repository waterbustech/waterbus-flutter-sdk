import 'package:freezed_annotation/freezed_annotation.dart';

part 'video_quality_model.freezed.dart';
part 'video_quality_model.g.dart';

@freezed
abstract class VideoQualityModel with _$VideoQualityModel {
  const factory VideoQualityModel({
    required int minHeight,
    required int minWidth,
    required int minFrameRate,
  }) = _VideoQualityModel;

  factory VideoQualityModel.fromJson(Map<String, Object?> json) =>
      _$VideoQualityModelFromJson(json);
}
