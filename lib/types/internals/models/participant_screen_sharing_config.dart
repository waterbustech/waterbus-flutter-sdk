import 'package:freezed_annotation/freezed_annotation.dart';

part 'participant_screen_sharing_config.freezed.dart';
part 'participant_screen_sharing_config.g.dart';

@freezed
abstract class ParticipantScreenSharingConfig
    with _$ParticipantScreenSharingConfig {
  const factory ParticipantScreenSharingConfig({
    required String participantId,
    required bool isSharing,
    String? screenTrackId,
  }) = _ParticipantScreenSharingConfig;

  factory ParticipantScreenSharingConfig.fromJson(Map<String, Object?> json) =>
      _$ParticipantScreenSharingConfigFromJson(json);
}
