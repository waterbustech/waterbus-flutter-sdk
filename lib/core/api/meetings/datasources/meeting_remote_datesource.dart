import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import 'package:waterbus_sdk/constants/endpoints.dart';
import 'package:waterbus_sdk/constants/status_code.dart';
import 'package:waterbus_sdk/core/api/base/base_remote_data.dart';
import 'package:waterbus_sdk/types/error/app_exception.dart';
import 'package:waterbus_sdk/types/models/meeting_model.dart';
import 'package:waterbus_sdk/types/models/record_model.dart';
import 'package:waterbus_sdk/types/result.dart';

abstract class MeetingRemoteDataSource {
  Future<Result<Meeting>> createMeeting({
    required Meeting meeting,
    required String password,
  });
  Future<Result<bool>> updateMeeting({
    required Meeting meeting,
    required String password,
  });
  Future<Result<Meeting>> joinMeetingWithPassword({
    required Meeting meeting,
    required String password,
  });
  Future<Result<Meeting>> joinMeetingWithoutPassword({
    required Meeting meeting,
  });
  Future<Result<Meeting>> getInfoMeeting(int code);
  Future<Result<List<RecordModel>>> getRecords({
    required int skip,
    required int limit,
  });
  Future<Result<int>> startRecord(int roomId);
  Future<Result<bool>> stopRecord(int roomId);
}

@LazySingleton(as: MeetingRemoteDataSource)
class MeetingRemoteDataSourceImpl extends MeetingRemoteDataSource {
  final BaseRemoteData _remoteData;
  MeetingRemoteDataSourceImpl(
    this._remoteData,
  );

  @override
  Future<Result<Meeting>> createMeeting({
    required Meeting meeting,
    required String password,
  }) async {
    final Response response = await _remoteData.post(
      Endpoints.meetings,
      body: meeting.toMapCreate(password: password),
    );

    if (response.statusCode == StatusCode.created) {
      final Map<String, dynamic> rawData = response.data;
      return Result.success(Meeting.fromJson(rawData));
    }

    return Result.failure(response.data['message'].toString().toFailure);
  }

  @override
  Future<Result<Meeting>> getInfoMeeting(int code) async {
    final Response response = await _remoteData.get(
      '${Endpoints.meetings}/$code',
    );

    if (response.statusCode == StatusCode.ok &&
        response.data.toString().isNotEmpty) {
      final Map<String, dynamic> rawData = response.data;
      return Result.success(Meeting.fromJson(rawData));
    }

    return Result.failure(response.data['message'].toString().toFailure);
  }

  @override
  Future<Result<Meeting>> joinMeetingWithPassword({
    required Meeting meeting,
    required String password,
  }) async {
    final Response response = await _remoteData.post(
      '${Endpoints.joinWithPassword}/${meeting.code}',
      body: {'password': password},
    );

    if (response.statusCode == StatusCode.created) {
      final Map<String, dynamic> rawData = response.data;
      return Result.success(
        Meeting.fromJson(rawData).copyWith(
          latestJoinedAt: DateTime.now(),
        ),
      );
    }

    return Result.failure(response.data['message'].toString().toFailure);
  }

  @override
  Future<Result<Meeting>> joinMeetingWithoutPassword({
    required Meeting meeting,
  }) async {
    final Response response = await _remoteData.post(
      '${Endpoints.joinWithoutPassword}/${meeting.code}',
    );

    if (response.statusCode == StatusCode.created) {
      final Map<String, dynamic> rawData = response.data;
      return Result.success(
        Meeting.fromJson(rawData).copyWith(
          latestJoinedAt: DateTime.now(),
        ),
      );
    }

    return Result.failure(response.data['message'].toString().toFailure);
  }

  @override
  Future<Result<bool>> updateMeeting({
    required Meeting meeting,
    required String password,
  }) async {
    final Response response = await _remoteData.put(
      Endpoints.meetings,
      meeting.toMapCreate(password: password),
    );

    if (response.statusCode == StatusCode.ok) {
      return Result.success(true);
    }

    return Result.failure(response.data['message'].toString().toFailure);
  }

  @override
  Future<Result<List<RecordModel>>> getRecords({
    required int skip,
    required int limit,
  }) async {
    return Result.success([]);
  }

  @override
  Future<Result<int>> startRecord(int roomId) async {
    // final Response response = await _remoteData.postRoute(
    //   ApiEndpoints.startRecord,
    //   queryParameters: {"code": roomId},
    // );

    // if (response.statusCode == StatusCode.created) {
    //   return Result.success(response.data['id']);
    // }

    // return Result.failure(response.data['message'].toString().toFailure);
    return Result.success(1);
  }

  @override
  Future<Result<bool>> stopRecord(int roomId) async {
    return Result.success(true);
  }
}
