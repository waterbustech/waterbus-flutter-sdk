import 'package:flutter/foundation.dart';

import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:waterbus_sdk/types/models/participant_sfu.dart';

part 'call_state.freezed.dart';

@freezed
abstract class CallState with _$CallState {
  const factory CallState({
    ParticipantSFU? mParticipant,
    required Map<String, ParticipantSFU> participants,
  }) = _CallState;
}
