// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'participant_screen_sharing_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ParticipantScreenSharingConfig _$ParticipantScreenSharingConfigFromJson(
        Map<String, dynamic> json) =>
    _ParticipantScreenSharingConfig(
      participantId: json['participantId'] as String,
      isSharing: json['isSharing'] as bool,
      screenTrackId: json['screenTrackId'] as String?,
    );

Map<String, dynamic> _$ParticipantScreenSharingConfigToJson(
        _ParticipantScreenSharingConfig instance) =>
    <String, dynamic>{
      'participantId': instance.participantId,
      'isSharing': instance.isSharing,
      'screenTrackId': instance.screenTrackId,
    };
