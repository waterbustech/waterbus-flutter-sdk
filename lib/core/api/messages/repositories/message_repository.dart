import 'package:injectable/injectable.dart';

import 'package:waterbus_sdk/core/api/messages/datasources/message_remote_data_source.dart';
import 'package:waterbus_sdk/types/index.dart';

abstract class MessageRepository {
  Future<Result<List<Message>>> getMessageByRoom({
    required int roomId,
    required int limit,
    required int skip,
  });

  Future<Result<Message>> sendMessage({
    required int roomId,
    required String data,
  });
  Future<Result<Message>> editMessage({
    required int messageId,
    required String data,
  });
  Future<Result<Message>> deleteMessage({required int messageId});
}

@Injectable(as: MessageRepository)
class MessageRepositoryImpl extends MessageRepository {
  final MessageRemoteDataSource _remoteDataSource;

  MessageRepositoryImpl(
    this._remoteDataSource,
  );

  @override
  Future<Result<Message>> deleteMessage({required int messageId}) async {
    final Result<Message> messageModel =
        await _remoteDataSource.deleteMessage(messageId: messageId);

    return messageModel;
  }

  @override
  Future<Result<Message>> editMessage({
    required int messageId,
    required String data,
  }) async {
    final Result<Message> messageModel =
        await _remoteDataSource.editMessage(messageId: messageId, data: data);

    return messageModel;
  }

  @override
  Future<Result<List<Message>>> getMessageByRoom({
    required int roomId,
    required int limit,
    required int skip,
  }) async {
    final Result<List<Message>> result =
        await _remoteDataSource.getMessageByRoom(
      roomId: roomId,
      skip: skip,
      limit: limit,
    );

    return result;
  }

  @override
  Future<Result<Message>> sendMessage({
    required int roomId,
    required String data,
  }) async {
    final Result<Message> message =
        await _remoteDataSource.sendMessage(roomId: roomId, data: data);

    return message;
  }
}
