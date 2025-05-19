// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:waterbus_sdk/types/externals/enums/index.dart';
import 'package:waterbus_sdk/types/externals/models/index.dart';
import 'package:waterbus_sdk/types/internals/models/int_converter.dart';

part 'message.freezed.dart';
part 'message.g.dart';

@freezed
abstract class Message with _$Message {
  const factory Message({
    required int id,
    required String data,
    @IntConverter() int? roomId,
    required User? createdBy,
    @Default(SendingStatusEnum.sent) SendingStatusEnum sendingStatus,
    required MessageStatusEnum status,
    required int type,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Message;

  factory Message.fromJson(Map<String, Object?> json) =>
      _$MessageFromJson(json);
}

extension MessageExtension on Message {
  bool get isDeleted => status == MessageStatusEnum.inactive;
}
