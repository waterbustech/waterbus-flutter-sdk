import 'package:flutter/foundation.dart';

import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:waterbus_sdk/types/externals/models/participant_media_state.dart';

part 'call_state.freezed.dart';

@freezed
abstract class CallState with _$CallState {
  const factory CallState({
    ParticipantMediaState? mParticipant,
    required Map<String, ParticipantMediaState> participants,
  }) = _CallState;
}
