import 'package:freezed_annotation/freezed_annotation.dart';

part 'subscribe_hls_payload.g.dart';
part 'subscribe_hls_payload.freezed.dart';

@freezed
abstract class SubscribeHlsPayload with _$SubscribeHlsPayload {
  const factory SubscribeHlsPayload({
    required String roomId,
    required String participantId,
    required String targetId,
  }) = _SubscribeHlsPayload;

  factory SubscribeHlsPayload.fromJson(Map<String, Object?> json) =>
      _$SubscribeHlsPayloadFromJson(json);
}
