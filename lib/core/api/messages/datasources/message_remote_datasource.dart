import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import 'package:waterbus_sdk/constants/api_enpoints.dart';
import 'package:waterbus_sdk/constants/http_status_code.dart';
import 'package:waterbus_sdk/core/api/base/base_remote_data.dart';
import 'package:waterbus_sdk/types/models/message_model.dart';

abstract class MessageRemoteDataSource {
  Future<List<MessageModel>> getMessageByRoom({
    required int meetingId,
    required int limit,
    required int skip,
  });

  Future<MessageModel?> sendMessage({
    required int meetingId,
    required String data,
  });
  Future<MessageModel?> editMessage({
    required int messageId,
    required String data,
  });
  Future<MessageModel?> deleteMessage({required int messageId});
}

@LazySingleton(as: MessageRemoteDataSource)
class MessageRemoteDataSourceImpl extends MessageRemoteDataSource {
  final BaseRemoteData _remoteData;

  MessageRemoteDataSourceImpl(
    this._remoteData,
  );

  @override
  Future<List<MessageModel>> getMessageByRoom({
    required int meetingId,
    required int limit,
    required int skip,
  }) async {
    final Response response = await _remoteData.getRoute(
      "${ApiEndpoints.chats}/$meetingId",
      query: "limit=$limit&skip=$skip",
    );

    if ([StatusCode.ok, StatusCode.created].contains(response.statusCode)) {
      return (response.data as List)
          .map((message) => MessageModel.fromMap(message))
          .toList();
    }

    return [];
  }

  @override
  Future<MessageModel?> sendMessage({
    required int meetingId,
    required String data,
  }) async {
    final Response response = await _remoteData.postRoute(
      "${ApiEndpoints.chats}/$meetingId",
      body: {"data": data},
    );

    if ([StatusCode.ok, StatusCode.created].contains(response.statusCode)) {
      return MessageModel.fromMap(response.data);
    }

    return null;
  }

  @override
  Future<MessageModel?> editMessage({
    required int messageId,
    required String data,
  }) async {
    final Response response = await _remoteData.putRoute(
      "${ApiEndpoints.chats}/$messageId",
      {"data": data},
    );

    if ([StatusCode.ok, StatusCode.created].contains(response.statusCode)) {
      return MessageModel.fromMap(response.data);
    }

    return null;
  }

  @override
  Future<MessageModel?> deleteMessage({required int messageId}) async {
    final Response response = await _remoteData.deleteRoute(
      "${ApiEndpoints.chats}/$messageId",
    );

    if ([StatusCode.ok, StatusCode.created].contains(response.statusCode)) {
      return MessageModel.fromMap(response.data);
    }

    return null;
  }
}
