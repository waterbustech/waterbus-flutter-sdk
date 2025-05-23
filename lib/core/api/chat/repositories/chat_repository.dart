import 'package:injectable/injectable.dart';

import 'package:waterbus_sdk/core/api/chat/datasources/chat_remote_data_source.dart';
import 'package:waterbus_sdk/types/externals/models/index.dart';
import 'package:waterbus_sdk/types/result.dart';

abstract class ChatRepository {
  Future<Result<List<Room>>> getConversations({
    required int limit,
    required int skip,
  });
  Future<Result<List<Room>>> getArchivedConversations({
    required int skip,
    required int limit,
  });
  Future<Result<bool>> updateConversation({
    required Room room,
    String? password,
  });
  Future<Result<bool>> deleteConversation(int roomId);
  Future<Result<Room>> leaveConversation({required int roomId});
  Future<Result<Room>> addMember({required int roomId, required int userId});
  Future<Result<Room>> deleteMember({
    required int roomId,
    required int userId,
  });
  Future<Result<Room>> archivedConversation({required int roomId});
}

@Injectable(as: ChatRepository)
class ChatRepositoryImpl extends ChatRepository {
  final ChatRemoteDataSource _remoteDataSource;

  ChatRepositoryImpl(
    this._remoteDataSource,
  );

  @override
  Future<Result<List<Room>>> getConversations({
    required limit,
    required skip,
  }) async {
    final Result<List<Room>> conversations =
        await _remoteDataSource.getConversations(
      skip: skip,
      limit: limit,
    );

    return conversations;
  }

  @override
  Future<Result<List<Room>>> getArchivedConversations({
    required limit,
    required skip,
  }) async {
    final Result<List<Room>> archivedConversations =
        await _remoteDataSource.getArchivedConversations(
      skip: skip,
      limit: limit,
    );

    return archivedConversations;
  }

  @override
  Future<Result<bool>> deleteConversation(int roomId) async {
    final Result<bool> isSucceed = await _remoteDataSource.deleteConversation(
      roomId: roomId,
    );

    return isSucceed;
  }

  @override
  Future<Result<Room>> leaveConversation({required int roomId}) async {
    final Result<Room> room = await _remoteDataSource.leaveConversation(
      roomId: roomId,
    );

    return room;
  }

  @override
  Future<Result<Room>> addMember({
    required int roomId,
    required int userId,
  }) async {
    final Result<Room> member = await _remoteDataSource.addMember(
      roomId: roomId,
      userId: userId,
    );

    return member;
  }

  @override
  Future<Result<Room>> deleteMember({
    required int roomId,
    required int userId,
  }) async {
    final Result<Room> room = await _remoteDataSource.deleteMember(
      roomId: roomId,
      userId: userId,
    );

    return room;
  }

  @override
  Future<Result<bool>> updateConversation({
    required Room room,
    String? password,
  }) async {
    final Result<bool> isSucceed = await _remoteDataSource.updateConversation(
      room: room,
      password: password,
    );

    return isSucceed;
  }

  @override
  Future<Result<Room>> archivedConversation({required int roomId}) async {
    final Result<Room> room = await _remoteDataSource.archivedConversation(
      roomId: roomId,
    );

    return room;
  }
}
