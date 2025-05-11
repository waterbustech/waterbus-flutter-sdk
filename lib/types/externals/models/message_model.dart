// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:waterbus_sdk/types/externals/enums/index.dart';
import 'package:waterbus_sdk/types/externals/models/index.dart';
import 'package:waterbus_sdk/types/internals/models/int_converter.dart';

part 'message_model.freezed.dart';
part 'message_model.g.dart';

@freezed
abstract class MessageModel with _$MessageModel {
  const factory MessageModel({
    required int id,
    required String data,
    @IntConverter() int? meeting,
    required User? createdBy,
    @Default(SendingStatusEnum.sent) SendingStatusEnum sendingStatus,
    required MessageStatusEnum status,
    required int type,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _MessageModel;

  factory MessageModel.fromJson(Map<String, Object?> json) =>
      _$MessageModelFromJson(json);
}

extension MessageModelExtension on MessageModel {
  bool get isDeleted => status == MessageStatusEnum.inactive;
}
