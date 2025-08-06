import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:waterbus_sdk/types/externals/auth/user.dart';

part 'participant_info.freezed.dart';
part 'participant_info.g.dart';

@freezed
abstract class ParticipantInfo with _$ParticipantInfo {
  const factory ParticipantInfo({
    required int id,
    User? user,
    @Default(false) bool isMe,
  }) = _ParticipantInfo;

  factory ParticipantInfo.fromJson(Map<String, Object?> json) =>
      _$ParticipantInfoFromJson(json);
}

extension ParticipantInfoExtension on ParticipantInfo {
  List<dynamic> get props {
    return [id, user, isMe];
  }
}
