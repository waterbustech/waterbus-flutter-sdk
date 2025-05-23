import 'package:flutter/foundation.dart';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import 'package:waterbus_sdk/constants/endpoints.dart';
import 'package:waterbus_sdk/constants/status_code.dart';
import 'package:waterbus_sdk/core/api/base/base_remote_data.dart';
import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';
import 'package:waterbus_sdk/utils/encrypt/encrypt.dart';

abstract class ChatRemoteDataSource {
  Future<Result<List<Room>>> getConversations({
    required int skip,
    required int limit,
  });
  Future<Result<List<Room>>> getArchivedConversations({
    required int skip,
    required int limit,
  });
  Future<Result<bool>> deleteConversation({required int roomId});
  Future<Result<Room>> archivedConversation({required int roomId});
  Future<Result<Room>> leaveConversation({required int roomId});
  Future<Result<Room>> addMember({required int roomId, required int userId});
  Future<Result<Room>> deleteMember({
    required int roomId,
    required int userId,
  });
  Future<Result<bool>> updateConversation({
    required Room room,
    String? password,
  });
}

@Injectable(as: ChatRemoteDataSource)
class ChatRemoteDataSourceImpl extends ChatRemoteDataSource {
  final BaseRemoteData _remoteData;
  ChatRemoteDataSourceImpl(
    this._remoteData,
  );

  @override
  Future<Result<List<Room>>> getConversations({
    required int skip,
    required int limit,
  }) async {
    final Response response = await _remoteData.get(
      Endpoints.rooms,
      query: "limit=$limit&skip=$skip",
    );

    if ([StatusCode.ok, StatusCode.created].contains(response.statusCode)) {
      final Map<String, dynamic> message = {
        "conversations": (response.data['rooms'] as List)
            .map((room) => Room.fromJson(room))
            .toList(),
        "key": WaterbusSdk.messageEncryptionKey,
      };

      return Result.success(await compute(_handleDecryptLastMessage, message));
    }

    return Result.failure(response.data['message'].toString().toFailure);
  }

  @override
  Future<Result<List<Room>>> getArchivedConversations({
    required int skip,
    required int limit,
  }) async {
    final Response response = await _remoteData.get(
      Endpoints.inactive,
      query: "limit=$limit&skip=$skip",
    );

    if ([StatusCode.ok, StatusCode.created].contains(response.statusCode)) {
      final Map<String, dynamic> message = {
        "conversations": (response.data['rooms'] as List)
            .map((room) => Room.fromJson(room))
            .toList(),
        "key": WaterbusSdk.messageEncryptionKey,
      };

      return Result.success(await compute(_handleDecryptLastMessage, message));
    }

    return Result.failure(response.data['message'].toString().toFailure);
  }

  static Future<List<Room>> _handleDecryptLastMessage(
    Map<String, dynamic> map,
  ) async {
    final List<Room> conversations = map['conversations'];
    final String key = map['key'];
    final List<Room> conversationsDecrypt = [];
    for (final Room conversation in conversations) {
      if (conversation.latestMessage == null) {
        conversationsDecrypt.add(conversation);
        continue;
      }

      final String decrypt = await EncryptAES().decryptAES256(
        cipherText: conversation.latestMessage?.data ?? "",
        key: key,
      );

      conversationsDecrypt.add(
        conversation.copyWith(
          latestMessage: conversation.latestMessage?.copyWith(data: decrypt),
        ),
      );
    }

    return conversationsDecrypt;
  }

  @override
  Future<Result<bool>> updateConversation({
    required Room room,
    String? password,
  }) async {
    final Response response = await _remoteData.put(
      "${Endpoints.rooms}/${room.id}",
      room.toMapCreate(password: password),
    );

    if (response.statusCode == StatusCode.ok) {
      return Result.success(true);
    }

    return Result.failure(response.data['message'].toString().toFailure);
  }

  @override
  Future<Result<bool>> deleteConversation({required int roomId}) async {
    final response = await _remoteData.delete(
      "${Endpoints.chats}/${Endpoints.conversations}/$roomId",
    );

    if ([StatusCode.ok, StatusCode.created].contains(response.statusCode)) {
      return Result.success(true);
    }

    return Result.failure(response.data['message'].toString().toFailure);
  }

  @override
  Future<Result<Room>> leaveConversation({required int roomId}) async {
    final Response response = await _remoteData.delete(
      '${Endpoints.rooms}/$roomId',
    );

    if (response.statusCode == StatusCode.ok) {
      final Map<String, dynamic> message = {
        "conversations": [Room.fromJson(response.data)],
        "key": WaterbusSdk.messageEncryptionKey,
      };

      return Result.success(
        (await compute(_handleDecryptLastMessage, message)).first,
      );
    }

    return Result.failure(response.data['message'].toString().toFailure);
  }

  @override
  Future<Result<Room>> addMember({
    required int roomId,
    required int userId,
  }) async {
    final Response response = await _remoteData.post(
      '${Endpoints.rooms}/$roomId/${Endpoints.members}',
      body: {"userId": userId},
    );

    if ([StatusCode.ok, StatusCode.created].contains(response.statusCode)) {
      final Map<String, dynamic> message = {
        "conversations": [Room.fromJson(response.data)],
        "key": WaterbusSdk.messageEncryptionKey,
      };

      return Result.success(
        (await compute(_handleDecryptLastMessage, message)).first,
      );
    }

    return Result.failure(response.data['message'].toString().toFailure);
  }

  @override
  Future<Result<Room>> deleteMember({
    required int roomId,
    required int userId,
  }) async {
    final Response response = await _remoteData.delete(
      '${Endpoints.rooms}/$roomId/${Endpoints.members}',
      body: {"userId": userId},
    );

    if ([StatusCode.ok, StatusCode.created].contains(response.statusCode)) {
      final Map<String, dynamic> message = {
        "conversations": [Room.fromJson(response.data)],
        "key": WaterbusSdk.messageEncryptionKey,
      };

      return Result.success(
        (await compute(_handleDecryptLastMessage, message)).first,
      );
    }

    return Result.failure(response.data['message'].toString().toFailure);
  }

  @override
  Future<Result<Room>> archivedConversation({required int roomId}) async {
    final Response response = await _remoteData.post(
      '${Endpoints.rooms}/$roomId/${Endpoints.deactivate}',
    );

    if ([StatusCode.ok, StatusCode.created].contains(response.statusCode)) {
      final Map<String, dynamic> message = {
        "conversations": [Room.fromJson(response.data)],
        "key": WaterbusSdk.messageEncryptionKey,
      };

      return Result.success(
        (await compute(_handleDecryptLastMessage, message)).first,
      );
    }

    return Result.failure(response.data['message'].toString().toFailure);
  }
}
