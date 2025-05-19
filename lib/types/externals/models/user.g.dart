// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_User _$UserFromJson(Map<String, dynamic> json) => _User(
      id: (json['id'] as num).toInt(),
      fullName: json['fullName'] as String,
      userName: json['userName'] as String,
      externalId: json['externalId'] as String,
      bio: json['bio'] as String?,
      avatar: json['avatar'] as String?,
    );

Map<String, dynamic> _$UserToJson(_User instance) => <String, dynamic>{
      'id': instance.id,
      'fullName': instance.fullName,
      'userName': instance.userName,
      'externalId': instance.externalId,
      'bio': instance.bio,
      'avatar': instance.avatar,
    };
