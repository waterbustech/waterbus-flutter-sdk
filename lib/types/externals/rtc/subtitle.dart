import 'package:freezed_annotation/freezed_annotation.dart';

part 'subtitle.freezed.dart';
part 'subtitle.g.dart';

@freezed
abstract class Subtitle with _$Subtitle {
  const factory Subtitle({
    required String participant,
    required String content,
  }) = _Subtitle;

  factory Subtitle.fromJson(Map<String, Object?> json) =>
      _$SubtitleFromJson(json);
}
