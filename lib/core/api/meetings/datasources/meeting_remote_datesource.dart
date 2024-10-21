import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import 'package:waterbus_sdk/constants/api_enpoints.dart';
import 'package:waterbus_sdk/constants/http_status_code.dart';
import 'package:waterbus_sdk/core/api/base/base_remote_data.dart';
import 'package:waterbus_sdk/types/models/meeting_model.dart';
import 'package:waterbus_sdk/types/models/record_model.dart';

abstract class MeetingRemoteDataSource {
  Future<Meeting?> createMeeting({
    required Meeting meeting,
    required String password,
  });
  Future<bool> updateMeeting({
    required Meeting meeting,
    required String password,
  });
  Future<Meeting?> joinMeetingWithPassword({
    required Meeting meeting,
    required String password,
  });
  Future<Meeting?> joinMeetingWithoutPassword({
    required Meeting meeting,
  });
  Future<Meeting?> getInfoMeeting(int code);
  Future<List<RecordModel>> getRecords({required int skip, required int limit});
  Future<int?> startRecord(int roomId);
  Future<bool> stopRecord(int roomId);
}

@LazySingleton(as: MeetingRemoteDataSource)
class MeetingRemoteDataSourceImpl extends MeetingRemoteDataSource {
  final BaseRemoteData _remoteData;
  MeetingRemoteDataSourceImpl(
    this._remoteData,
  );

  @override
  Future<Meeting?> createMeeting({
    required Meeting meeting,
    required String password,
  }) async {
    final Response response = await _remoteData.postRoute(
      ApiEndpoints.meetings,
      body: meeting.toMapCreate(password: password),
    );

    if (response.statusCode == StatusCode.created) {
      final Map<String, dynamic> rawData = response.data;
      return Meeting.fromMap(rawData);
    }

    return null;
  }

  @override
  Future<Meeting?> getInfoMeeting(int code) async {
    final Response response = await _remoteData.getRoute(
      '${ApiEndpoints.meetings}/$code',
    );

    if (response.statusCode == StatusCode.ok &&
        response.data.toString().isNotEmpty) {
      final Map<String, dynamic> rawData = response.data;
      return Meeting.fromMap(rawData);
    }

    return null;
  }

  @override
  Future<Meeting?> joinMeetingWithPassword({
    required Meeting meeting,
    required String password,
  }) async {
    final Response response = await _remoteData.postRoute(
      '${ApiEndpoints.joinWithPassword}/${meeting.code}',
      body: {'password': password},
    );

    if (response.statusCode == StatusCode.created) {
      final Map<String, dynamic> rawData = response.data;
      return Meeting.fromMap(rawData).copyWith(
        latestJoinedAt: DateTime.now(),
      );
    }

    return null;
  }

  @override
  Future<Meeting?> joinMeetingWithoutPassword({
    required Meeting meeting,
  }) async {
    final Response response = await _remoteData.postRoute(
      '${ApiEndpoints.joinWithoutPassword}/${meeting.code}',
    );

    if (response.statusCode == StatusCode.created) {
      final Map<String, dynamic> rawData = response.data;
      return Meeting.fromMap(rawData).copyWith(
        latestJoinedAt: DateTime.now(),
      );
    }

    return null;
  }

  @override
  Future<bool> updateMeeting({
    required Meeting meeting,
    required String password,
  }) async {
    final Response response = await _remoteData.putRoute(
      ApiEndpoints.meetings,
      meeting.toMapCreate(password: password),
    );

    return response.statusCode == StatusCode.ok;
  }

  @override
  Future<List<RecordModel>> getRecords({
    required int skip,
    required int limit,
  }) async {
    final Response response = await _remoteData.getRoute(ApiEndpoints.records);

    if (response.statusCode == StatusCode.ok) {
      final List rawData = response.data;
      return rawData.map((data) => RecordModel.fromMap(data)).toList();
    }

    return [];
  }

  @override
  Future<int?> startRecord(int roomId) async {
    final Response response = await _remoteData.postRoute(
      ApiEndpoints.startRecord,
      queryParameters: {"code": roomId},
    );

    if (response.statusCode == StatusCode.created) {
      return response.data['id'];
    }

    return null;
  }

  @override
  Future<bool> stopRecord(int roomId) async {
    final Response response = await _remoteData.postRoute(
      ApiEndpoints.stopRecord,
      queryParameters: {"code": roomId},
    );

    return response.statusCode == StatusCode.created;
  }
}
