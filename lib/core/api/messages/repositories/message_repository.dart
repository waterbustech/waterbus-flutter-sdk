import 'package:injectable/injectable.dart';

import 'package:waterbus_sdk/core/api/messages/datasources/message_remote_datasource.dart';
import 'package:waterbus_sdk/types/models/message_model.dart';

abstract class MessageRepository {
  Future<List<MessageModel>> getMessageByRoom({
    required int meetingId,
    required int limit,
    required int skip,
  });

  Future<MessageModel?> sendMessage({
    required int meetingId,
    required String data,
  });
  Future<bool> editMessage({required int meetingId, required String data});
  Future<bool> deleteMessage({required int meetingId});
}

@LazySingleton(as: MessageRepository)
class MessageRepositoryImpl extends MessageRepository {
  final MessageRemoteDataSource _remoteDataSource;

  MessageRepositoryImpl(
    this._remoteDataSource,
  );

  @override
  Future<bool> deleteMessage({required int meetingId}) async {
    final bool isSucceed =
        await _remoteDataSource.deleteMessage(meetingId: meetingId);

    return isSucceed;
  }

  @override
  Future<bool> editMessage({
    required int meetingId,
    required String data,
  }) async {
    final bool isSucceed =
        await _remoteDataSource.editMessage(meetingId: meetingId, data: data);

    return isSucceed;
  }

  @override
  Future<List<MessageModel>> getMessageByRoom({
    required int meetingId,
    required int limit,
    required int skip,
  }) async {
    final List<MessageModel> messages =
        await _remoteDataSource.getMessageByRoom(
      meetingId: meetingId,
      skip: skip,
      limit: limit,
    );

    return messages;
  }

  @override
  Future<MessageModel?> sendMessage({
    required int meetingId,
    required String data,
  }) async {
    final MessageModel? message =
        await _remoteDataSource.sendMessage(meetingId: meetingId, data: data);

    return message;
  }
}
