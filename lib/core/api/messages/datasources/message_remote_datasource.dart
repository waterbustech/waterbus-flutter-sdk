import 'package:flutter/foundation.dart';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import 'package:waterbus_sdk/constants/endpoints.dart';
import 'package:waterbus_sdk/constants/status_code.dart';
import 'package:waterbus_sdk/core/api/base/base_remote_data.dart';
import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';
import 'package:waterbus_sdk/utils/encrypt/encrypt.dart';

abstract class MessageRemoteDataSource {
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

@Injectable(as: MessageRemoteDataSource)
class MessageRemoteDataSourceImpl extends MessageRemoteDataSource {
  final BaseRemoteData _remoteData;

  MessageRemoteDataSourceImpl(
    this._remoteData,
  );

  @override
  Future<Result<List<MessageModel>>> getMessageByRoom({
    required int meetingId,
    required int limit,
    required int skip,
  }) async {
    final Response response = await _remoteData.get(
      "${Endpoints.chats}/$meetingId",
      query: "limit=$limit&skip=$skip",
    );

    if ([StatusCode.ok, StatusCode.created].contains(response.statusCode)) {
      final List<MessageModel> messages = (response.data as List)
          .map((message) => MessageModel.fromJson(message))
          .toList();

      return Result.success(
        await compute(_handleDecryptMessages, {
          "messages": messages,
          "key": WaterbusSdk.messageEncryptionKey,
        }),
      );
    }

    return Result.failure(
      (response.data['message'] as String).toFailure,
    );
  }

  static Future<List<MessageModel>> _handleDecryptMessages(
    Map<String, dynamic> map,
  ) async {
    final List<MessageModel> messages = map['messages'];
    final String key = map['key'];

    final List<MessageModel> messagesDecrypt = [];
    for (final MessageModel messageModel in messages) {
      final String data = await EncryptAES()
          .decryptAES256(cipherText: messageModel.data, key: key);

      messagesDecrypt.add(messageModel.copyWith(data: data));
    }

    return messagesDecrypt;
  }

  @override
  Future<Result<MessageModel>> sendMessage({
    required int meetingId,
    required String data,
  }) async {
    final String messageData =
        await EncryptAES().encryptAES256(cleartext: data);

    final Response response = await _remoteData.post(
      "${Endpoints.chats}/$meetingId",
      body: {"data": messageData},
    );

    if ([StatusCode.ok, StatusCode.created].contains(response.statusCode)) {
      return Result.success(
        MessageModel.fromJson(response.data).copyWith(data: data),
      );
    }

    return Result.failure(
      (response.data['message'] as String).toFailure,
    );
  }

  @override
  Future<Result<MessageModel>> editMessage({
    required int messageId,
    required String data,
  }) async {
    final String messageData =
        await EncryptAES().encryptAES256(cleartext: data);
    final Response response = await _remoteData.put(
      "${Endpoints.chats}/$messageId",
      {"data": messageData},
    );

    if ([StatusCode.ok, StatusCode.created].contains(response.statusCode)) {
      return Result.success(
        MessageModel.fromJson(response.data).copyWith(data: data),
      );
    }

    return Result.failure(
      (response.data['message'] as String).toFailure,
    );
  }

  @override
  Future<Result<MessageModel>> deleteMessage({
    required int messageId,
  }) async {
    final Response response = await _remoteData.delete(
      "${Endpoints.chats}/$messageId",
    );

    if ([StatusCode.ok, StatusCode.created].contains(response.statusCode)) {
      return Result.success(MessageModel.fromJson(response.data));
    }

    return Result.failure(
      (response.data['message'] as String).toFailure,
    );
  }
}
