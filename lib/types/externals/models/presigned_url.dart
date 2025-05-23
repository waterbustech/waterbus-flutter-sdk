import 'package:freezed_annotation/freezed_annotation.dart';

part "presigned_url.freezed.dart";
part "presigned_url.g.dart";

@freezed
abstract class PresignedUrl with _$PresignedUrl {
  const factory PresignedUrl({
    required String presignedUrl,
    required String sourceUrl,
  }) = _PresignedUrl;

  factory PresignedUrl.fromJson(Map<String, Object?> json) =>
      _$PresignedUrlFromJson(json);
}
