import 'package:freezed_annotation/freezed_annotation.dart';

part 'video_quality_model.freezed.dart';

@freezed
abstract class VideoQualityModel with _$VideoQualityModel {
  const factory VideoQualityModel({
    required int minHeight,
    required int minWidth,
    required int minFrameRate,
    int? frameRate,
    int? height,
    int? width,
  }) = _VideoQualityModel;

  factory VideoQualityModel.k1080() {
    return VideoQualityModel(
      minHeight: 1080,
      minWidth: 1920,
      minFrameRate: 30,
    );
  }
  factory VideoQualityModel.k720() {
    return VideoQualityModel(
      minHeight: 720,
      minWidth: 1280,
      minFrameRate: 25,
    );
  }
  factory VideoQualityModel.k360() {
    return VideoQualityModel(
      minHeight: 360,
      minWidth: 640,
      minFrameRate: 15,
    );
  }
}
