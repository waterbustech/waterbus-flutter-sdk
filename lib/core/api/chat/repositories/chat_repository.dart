import 'package:injectable/injectable.dart';

import 'package:waterbus_sdk/core/api/chat/datasources/chat_remote_datasource.dart';
import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';
import 'package:waterbus_sdk/types/result.dart';

abstract class ChatRepository {
  Future<Result<List<Meeting>>> getConversations({
    required int status,
    required int limit,
    required int skip,
  });
  Future<Result<List<Meeting>>> getArchivedConversations({
    required int skip,
    required int limit,
  });
  Future<Result<bool>> updateConversation({
    required Meeting meeting,
    String? password,
  });
  Future<Result<bool>> deleteConversation(int meetingId);
  Future<Result<Meeting>> leaveConversation({required int code});
  Future<Result<Meeting>> addMember({required int code, required int userId});
  Future<Result<Meeting>> deleteMember({
    required int code,
    required int userId,
  });
  Future<Result<Meeting>> acceptInvite({required int meetingId});
  Future<Result<Meeting>> archivedConversation({required int code});
}

@Injectable(as: ChatRepository)
class ChatRepositoryImpl extends ChatRepository {
  final ChatRemoteDataSource _remoteDataSource;

  ChatRepositoryImpl(
    this._remoteDataSource,
  );

  @override
  Future<Result<List<Meeting>>> getConversations({
    required int status,
    required limit,
    required skip,
  }) async {
    final Result<List<Meeting>> conversations =
        await _remoteDataSource.getConversations(
      skip: skip,
      limit: limit,
      status: status,
    );

    return conversations;
  }

  @override
  Future<Result<List<Meeting>>> getArchivedConversations({
    required limit,
    required skip,
  }) async {
    final Result<List<Meeting>> archivedConversations =
        await _remoteDataSource.getArchivedConversations(
      skip: skip,
      limit: limit,
    );

    return archivedConversations;
  }

  @override
  Future<Result<bool>> deleteConversation(int meetingId) async {
    final Result<bool> isSucceed = await _remoteDataSource.deleteConversation(
      meetingId: meetingId,
    );

    return isSucceed;
  }

  @override
  Future<Result<Meeting>> leaveConversation({required int code}) async {
    final Result<Meeting> meeting = await _remoteDataSource.leaveConversation(
      code: code,
    );

    return meeting;
  }

  @override
  Future<Result<Meeting>> acceptInvite({required int meetingId}) async {
    final Result<Meeting> meeting = await _remoteDataSource.acceptInvite(
      meetingId: meetingId,
    );

    return meeting;
  }

  @override
  Future<Result<Meeting>> addMember({
    required int code,
    required int userId,
  }) async {
    final Result<Meeting> member = await _remoteDataSource.addMember(
      code: code,
      userId: userId,
    );

    return member;
  }

  @override
  Future<Result<Meeting>> deleteMember({
    required int code,
    required int userId,
  }) async {
    final Result<Meeting> meeting = await _remoteDataSource.deleteMember(
      code: code,
      userId: userId,
    );

    return meeting;
  }

  @override
  Future<Result<bool>> updateConversation({
    required Meeting meeting,
    String? password,
  }) async {
    final Result<bool> isSucceed = await _remoteDataSource.updateConversation(
      meeting: meeting,
      password: password,
    );

    return isSucceed;
  }

  @override
  Future<Result<Meeting>> archivedConversation({required int code}) async {
    final Result<Meeting> meeting =
        await _remoteDataSource.archivedConversation(
      code: code,
    );

    return meeting;
  }
}
