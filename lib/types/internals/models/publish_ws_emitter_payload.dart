import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:waterbus_sdk/types/externals/enums/streaming_protocol.dart';
import 'package:waterbus_sdk/types/internals/enums/connection_type.dart';

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
    required ConnectionType connectionType,
    required StreamingProtocol streamingProtocol,
    @Default(false) bool isIpv6Supported,
  }) = _PublishWsEmitterPayLoad;

  factory PublishWsEmitterPayLoad.fromJson(Map<String, Object?> json) =>
      _$PublishWsEmitterPayLoadFromJson(json);
}
