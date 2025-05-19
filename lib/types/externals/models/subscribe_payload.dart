import 'package:freezed_annotation/freezed_annotation.dart';

part 'subscribe_payload.g.dart';
part 'subscribe_payload.freezed.dart';

@freezed
abstract class SubscribePayload with _$SubscribePayload {
  const factory SubscribePayload({
    required String roomId,
    required String participantId,
    required String targetId,
  }) = _SubscribePayload;

  factory SubscribePayload.fromJson(Map<String, Object?> json) =>
      _$SubscribePayloadFromJson(json);
}
