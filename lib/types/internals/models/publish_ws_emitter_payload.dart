import 'package:freezed_annotation/freezed_annotation.dart';

part 'publish_ws_emitter_payload.g.dart';
part 'publish_ws_emitter_payload.freezed.dart';

@freezed
abstract class PublishWsEmitterPayLoad with _$PublishWsEmitterPayLoad {
  const factory PublishWsEmitterPayLoad({
    required String sdp,
    required String roomId,
    required String participantId,
    required bool isVideoEnabled,
    required bool isAudioEnabled,
    required bool isE2eeEnabled,
    required int totalTracks,
  }) = _PublishWsEmitterPayLoad;

  factory PublishWsEmitterPayLoad.fromJson(Map<String, Object?> json) =>
      _$PublishWsEmitterPayLoadFromJson(json);
}
