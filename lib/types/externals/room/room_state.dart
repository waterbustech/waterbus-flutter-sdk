import 'package:flutter/foundation.dart';

import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:waterbus_sdk/types/index.dart';

part 'room_state.freezed.dart';

@freezed
abstract class RoomState with _$RoomState {
  const RoomState._();

  const factory RoomState({
    LocalParticipant? localParticipant,
    required Map<String, RemoteParticipant> remoteParticipants,
  }) = _RoomState;

  List<Participant> get participants {
    final list = <Participant>[];
    list.addAll(remoteParticipants.values);
    if (localParticipant != null) list.add(localParticipant!);
    return list;
  }
}
