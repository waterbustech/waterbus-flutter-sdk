import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:waterbus_sdk/types/externals/enums/index.dart';
import 'package:waterbus_sdk/types/externals/models/index.dart';

part 'callback_payload.freezed.dart';

@freezed
abstract class CallbackPayload with _$CallbackPayload {
  const factory CallbackPayload({
    required CallbackEvents event,
    required CallState callState,
    String? participantId,
    Participant? newParticipant,
  }) = _CallbackPayload;
}
