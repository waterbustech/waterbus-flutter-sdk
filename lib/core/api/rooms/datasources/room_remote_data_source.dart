import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import 'package:waterbus_sdk/constants/endpoints.dart';
import 'package:waterbus_sdk/constants/status_code.dart';
import 'package:waterbus_sdk/core/api/base/base_remote_data.dart';
import 'package:waterbus_sdk/types/error/app_exception.dart';
import 'package:waterbus_sdk/types/externals/models/index.dart';
import 'package:waterbus_sdk/types/externals/models/join_room_params.dart';
import 'package:waterbus_sdk/types/result.dart';

abstract class RoomRemoteDataSource {
  Future<Result<Room>> createRoom({required RoomParams params});
  Future<Result<bool>> updateRoom({required RoomParams params});
  Future<Result<Room>> joinRoom({required JoinRoomParams params});

  Future<Result<Room>> getInfoRoom(String code);
}

@LazySingleton(as: RoomRemoteDataSource)
class RoomRemoteDataSourceImpl extends RoomRemoteDataSource {
  final BaseRemoteData _remoteData;
  RoomRemoteDataSourceImpl(
    this._remoteData,
  );

  @override
  Future<Result<Room>> createRoom({required RoomParams params}) async {
    final Response response = await _remoteData.post(
      Endpoints.rooms,
      body: params.room.toMapCreate(password: params.password),
    );

    if (response.statusCode == StatusCode.created) {
      final Map<String, dynamic> rawData = response.data;
      return Result.success(Room.fromJson(rawData));
    }

    return Result.failure(response.data['message'].toString().toFailure);
  }

  @override
  Future<Result<Room>> getInfoRoom(String code) async {
    final Response response = await _remoteData.get(
      '${Endpoints.rooms}/$code',
    );

    if (response.statusCode == StatusCode.ok &&
        response.data.toString().isNotEmpty) {
      final Map<String, dynamic> rawData = response.data;
      return Result.success(Room.fromJson(rawData));
    }

    return Result.failure(response.data['message'].toString().toFailure);
  }

  @override
  Future<Result<Room>> joinRoom({required JoinRoomParams params}) async {
    final Response response = await _remoteData.post(
      '${Endpoints.rooms}/${params.roomId}/${Endpoints.join}',
      body: params.password.isEmpty ? {} : {'password': params.password},
    );

    if (response.statusCode == StatusCode.created) {
      final Map<String, dynamic> rawData = response.data;
      return Result.success(
        Room.fromJson(rawData).copyWith(
          latestJoinedAt: DateTime.now(),
        ),
      );
    }

    return Result.failure(response.data['message'].toString().toFailure);
  }

  @override
  Future<Result<bool>> updateRoom({required RoomParams params}) async {
    final Response response = await _remoteData.put(
      Endpoints.rooms,
      params.room.toMapCreate(password: params.password),
    );

    if (response.statusCode == StatusCode.ok) {
      return Result.success(true);
    }

    return Result.failure(response.data['message'].toString().toFailure);
  }
}
