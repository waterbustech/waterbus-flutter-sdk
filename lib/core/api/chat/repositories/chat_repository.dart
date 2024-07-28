import 'package:injectable/injectable.dart';

import 'package:waterbus_sdk/core/api/chat/datasources/chat_remote_datasource.dart';
import 'package:waterbus_sdk/types/index.dart';

abstract class ChatRepository {
  Future<List<Meeting>> getConversations({
    required int status,
    required int limit,
    required int skip,
  });
  Future<bool> deleteConversation(int meetingId);
  Future<Meeting?> leaveConversation({required int code});
  Future<Meeting?> addMember({required int code, required int userId});
  Future<Meeting?> deleteMember({required int code, required int userId});
  Future<Meeting?> acceptInvite({required int code});
}

@LazySingleton(as: ChatRepository)
class ChatRepositoryImpl extends ChatRepository {
  final ChatRemoteDataSource _remoteDataSource;

  ChatRepositoryImpl(
    this._remoteDataSource,
  );

  @override
  Future<List<Meeting>> getConversations({
    required int status,
    required limit,
    required skip,
  }) async {
    final List<Meeting> conversations =
        await _remoteDataSource.getConversations(
      skip: skip,
      limit: limit,
      status: status,
    );

    return conversations;
  }

  @override
  Future<bool> deleteConversation(int meetingId) async {
    final bool isSucceed = await _remoteDataSource.deleteConversation(
      meetingId: meetingId,
    );

    return isSucceed;
  }

  @override
  Future<Meeting?> leaveConversation({required int code}) async {
    final Meeting? meeting = await _remoteDataSource.leaveConversation(
      code: code,
    );

    return meeting;
  }

  @override
  Future<Meeting?> acceptInvite({required int code}) async {
    final Meeting? meeting = await _remoteDataSource.acceptInvite(
      code: code,
    );

    return meeting;
  }

  @override
  Future<Meeting?> addMember({required int code, required int userId}) async {
    final Meeting? member = await _remoteDataSource.addMember(
      code: code,
      userId: userId,
    );

    return member;
  }

  @override
  Future<Meeting?> deleteMember({
    required int code,
    required int userId,
  }) async {
    final Meeting? meeting = await _remoteDataSource.deleteMember(
      code: code,
      userId: userId,
    );

    return meeting;
  }
}
