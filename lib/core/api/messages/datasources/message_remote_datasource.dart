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
  Future<bool> editMessage({
    required int meetingId,
    required String data,
  });
  Future<bool> deleteMessage({required int meetingId});
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
      final List rawList = response.data;
      return rawList.map((message) => MessageModel.fromMap(message)).toList();
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
  Future<bool> editMessage({
    required int meetingId,
    required String data,
  }) async {
    final Response response = await _remoteData.putRoute(
      "${ApiEndpoints.chats}/$meetingId",
      {"data": data},
    );

    if ([StatusCode.ok, StatusCode.created].contains(response.statusCode)) {
      return true;
    }

    return false;
  }

  @override
  Future<bool> deleteMessage({required int meetingId}) async {
    final Response response = await _remoteData.deleteRoute(
      "${ApiEndpoints.chats}/$meetingId",
    );

    if ([StatusCode.ok, StatusCode.created].contains(response.statusCode)) {
      return true;
    }

    return false;
  }
}
