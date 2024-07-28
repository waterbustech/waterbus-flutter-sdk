import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import 'package:waterbus_sdk/constants/api_enpoints.dart';
import 'package:waterbus_sdk/constants/http_status_code.dart';
import 'package:waterbus_sdk/core/api/base/base_remote_data.dart';
import 'package:waterbus_sdk/types/index.dart';

abstract class ChatRemoteDataSource {
  Future<List<Meeting>> getConversations({
    required int skip,
    required int limit,
    required int status,
  });
  Future<bool> deleteConversation({required int meetingId});
  Future<Meeting?> leaveConversation({required int code});
  Future<Meeting?> addMember({required int code, required int userId});
  Future<Meeting?> deleteMember({required int code, required int userId});
  Future<Meeting?> acceptInvite({required int code});
}

@LazySingleton(as: ChatRemoteDataSource)
class ChatRemoteDataSourceImpl extends ChatRemoteDataSource {
  final BaseRemoteData _remoteData;
  ChatRemoteDataSourceImpl(
    this._remoteData,
  );

  @override
  Future<List<Meeting>> getConversations({
    required int skip,
    required int limit,
    required int status,
  }) async {
    final Response response = await _remoteData.getRoute(
      "${ApiEndpoints.meetingConversations}/$status",
      query: "limit=$limit&skip=$skip",
    );

    if ([StatusCode.ok, StatusCode.created].contains(response.statusCode)) {
      final List list = response.data;
      return list.map((meeting) => Meeting.fromMap(meeting)).toList();
    }

    return [];
  }

  @override
  Future<bool> deleteConversation({required int meetingId}) async {
    final response = await _remoteData.deleteRoute(
      "${ApiEndpoints.chatsConversations}/$meetingId",
    );

    return [StatusCode.ok, StatusCode.created].contains(response.statusCode);
  }

  @override
  Future<Meeting?> leaveConversation({required int code}) async {
    final Response response = await _remoteData.deleteRoute(
      '${ApiEndpoints.meetings}/$code',
    );

    if (response.statusCode == StatusCode.ok) {
      final Map<String, dynamic> rawData = response.data;
      return Meeting.fromMap(rawData);
    }

    return null;
  }

  @override
  Future<Meeting?> acceptInvite({required int code}) async {
    final Response response = await _remoteData.postRoute(
      '${ApiEndpoints.acceptInvite}/$code',
    );

    if ([StatusCode.ok, StatusCode.created].contains(response.statusCode)) {
      return Meeting.fromMap(response.data);
    }

    return null;
  }

  @override
  Future<Meeting?> addMember({required int code, required int userId}) async {
    final Response response = await _remoteData.postRoute(
      '${ApiEndpoints.meetingMembers}/$code',
      body: {"userId": userId},
    );

    if ([StatusCode.ok, StatusCode.created].contains(response.statusCode)) {
      return Meeting.fromMap(response.data);
    }

    return null;
  }

  @override
  Future<Meeting?> deleteMember({
    required int code,
    required int userId,
  }) async {
    final Response response = await _remoteData.deleteRoute(
      '${ApiEndpoints.meetingMembers}/$code',
      body: {"userId": userId},
    );

    if ([StatusCode.ok, StatusCode.created].contains(response.statusCode)) {
      return Meeting.fromMap(response.data);
    }

    return null;
  }
}
