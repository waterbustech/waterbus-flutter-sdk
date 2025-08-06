import 'package:flutter/foundation.dart';

import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:waterbus_sdk/types/externals/participant/local_participant.dart';
import 'package:waterbus_sdk/types/externals/participant/remote_participant.dart';

part 'room_state.freezed.dart';

@freezed
abstract class RoomState with _$RoomState {
  const factory RoomState({
    LocalParticipant? localParticipant,
    required Map<String, RemoteParticipant> remoteParticipants,
  }) = _RoomState;
}
