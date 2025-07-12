import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:waterbus_sdk/types/internals/models/track_quality.dart';

part 'track_quality_request.freezed.dart';
part 'track_quality_request.g.dart';

@freezed
abstract class TrackQualityRequest with _$TrackQualityRequest {
  const factory TrackQualityRequest({
    required String trackId,
    required TrackQuality quality,
  }) = _TrackQualityRequest;

  factory TrackQualityRequest.fromJson(Map<String, Object?> json) =>
      _$TrackQualityRequestFromJson(json);
}
