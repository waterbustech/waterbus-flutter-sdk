import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:waterbus_sdk/types/externals/models/index.dart';

part "participant.freezed.dart";
part "participant.g.dart";

@freezed
abstract class Participant with _$Participant {
  const factory Participant({
    required int id,
    User? user,
    @Default(false) bool isMe,
  }) = _Participant;

  factory Participant.fromJson(Map<String, Object?> json) =>
      _$ParticipantFromJson(json);
}

extension ParticipantExtension on Participant {
  List<dynamic> get props {
    return [id, user, isMe];
  }
}
