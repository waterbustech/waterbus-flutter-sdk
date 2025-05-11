import 'package:injectable/injectable.dart';

import 'package:waterbus_sdk/core/api/messages/datasources/message_remote_datasource.dart';
import 'package:waterbus_sdk/types/result.dart';
import 'package:waterbus_sdk/types/externals/models/index.dart';

abstract class MessageRepository {
  Future<Result<List<MessageModel>>> getMessageByRoom({
    required int meetingId,
    required int limit,
    required int skip,
  });

  Future<Result<MessageModel>> sendMessage({
    required int meetingId,
    required String data,
  });
  Future<Result<MessageModel>> editMessage({
    required int messageId,
    required String data,
  });
  Future<Result<MessageModel>> deleteMessage({required int messageId});
}

@Injectable(as: MessageRepository)
class MessageRepositoryImpl extends MessageRepository {
  final MessageRemoteDataSource _remoteDataSource;

  MessageRepositoryImpl(
    this._remoteDataSource,
  );

  @override
  Future<Result<MessageModel>> deleteMessage({required int messageId}) async {
    final Result<MessageModel> messageModel =
        await _remoteDataSource.deleteMessage(messageId: messageId);

    return messageModel;
  }

  @override
  Future<Result<MessageModel>> editMessage({
    required int messageId,
    required String data,
  }) async {
    final Result<MessageModel> messageModel =
        await _remoteDataSource.editMessage(messageId: messageId, data: data);

    return messageModel;
  }

  @override
  Future<Result<List<MessageModel>>> getMessageByRoom({
    required int meetingId,
    required int limit,
    required int skip,
  }) async {
    final Result<List<MessageModel>> result =
        await _remoteDataSource.getMessageByRoom(
      meetingId: meetingId,
      skip: skip,
      limit: limit,
    );

    return result;
  }

  @override
  Future<Result<MessageModel>> sendMessage({
    required int meetingId,
    required String data,
  }) async {
    final Result<MessageModel> message =
        await _remoteDataSource.sendMessage(meetingId: meetingId, data: data);

    return message;
  }
}
