import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:waterbus_sdk/types/internals/models/track_quality.dart';

part 'track_subscribed_message.freezed.dart';
part 'track_subscribed_message.g.dart';

@freezed
abstract class TrackSubscribedMessage with _$TrackSubscribedMessage {
  const factory TrackSubscribedMessage({
    required String trackId,
    required int subscribedCount,
    required TrackQuality quality,
    required int timestamp,
  }) = _TrackSubscribedMessage;

  factory TrackSubscribedMessage.fromJson(Map<String, Object?> json) =>
      _$TrackSubscribedMessageFromJson(json);
}
