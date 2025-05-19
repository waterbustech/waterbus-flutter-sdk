import 'package:freezed_annotation/freezed_annotation.dart';

part 'beauty_filters.freezed.dart';

@freezed
abstract class BeautyFilters with _$BeautyFilters {
  const factory BeautyFilters({
    @Default(0) double smoothValue,
    @Default(0) double whiteValue,
    @Default(0) double thinFaceValue,
    @Default(0) double bigEyeValue,
    @Default(0) double lipstickValue,
    @Default(0) double blusherValue,
  }) = _BeautyFilters;
}
