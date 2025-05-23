import 'package:flutter/foundation.dart';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import 'package:waterbus_sdk/constants/endpoints.dart';
import 'package:waterbus_sdk/constants/status_code.dart';
import 'package:waterbus_sdk/core/api/base/base_remote_data.dart';
import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';
import 'package:waterbus_sdk/utils/encrypt/encrypt.dart';

abstract class MessageRemoteDataSource {
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

@Injectable(as: MessageRemoteDataSource)
class MessageRemoteDataSourceImpl extends MessageRemoteDataSource {
  final BaseRemoteData _remoteData;

  MessageRemoteDataSourceImpl(
    this._remoteData,
  );

  @override
  Future<Result<List<Message>>> getMessageByRoom({
    required int roomId,
    required int limit,
    required int skip,
  }) async {
    final Response response = await _remoteData.get(
      "${Endpoints.chats}/$roomId",
      query: "limit=$limit&skip=$skip",
    );

    if ([StatusCode.ok, StatusCode.created].contains(response.statusCode)) {
      final List<Message> messages = (response.data['messages'] as List)
          .map((message) => Message.fromJson(message))
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

  static Future<List<Message>> _handleDecryptMessages(
    Map<String, dynamic> map,
  ) async {
    final List<Message> messages = map['messages'];
    final String key = map['key'];

    final List<Message> messagesDecrypt = [];
    for (final Message messageModel in messages) {
      final String data = await EncryptAES()
          .decryptAES256(cipherText: messageModel.data, key: key);

      messagesDecrypt.add(messageModel.copyWith(data: data));
    }

    return messagesDecrypt;
  }

  @override
  Future<Result<Message>> sendMessage({
    required int roomId,
    required String data,
  }) async {
    final String messageData =
        await EncryptAES().encryptAES256(cleartext: data);

    final Response response = await _remoteData.post(
      "${Endpoints.chats}/$roomId",
      body: {"data": messageData},
    );

    if ([StatusCode.ok, StatusCode.created].contains(response.statusCode)) {
      return Result.success(
        Message.fromJson(response.data).copyWith(data: data),
      );
    }

    return Result.failure(
      (response.data['message'] as String).toFailure,
    );
  }

  @override
  Future<Result<Message>> editMessage({
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
        Message.fromJson(response.data).copyWith(data: data),
      );
    }

    return Result.failure(
      (response.data['message'] as String).toFailure,
    );
  }

  @override
  Future<Result<Message>> deleteMessage({
    required int messageId,
  }) async {
    final Response response = await _remoteData.delete(
      "${Endpoints.chats}/$messageId",
    );

    if ([StatusCode.ok, StatusCode.created].contains(response.statusCode)) {
      return Result.success(Message.fromJson(response.data));
    }

    return Result.failure(
      (response.data['message'] as String).toFailure,
    );
  }
}
