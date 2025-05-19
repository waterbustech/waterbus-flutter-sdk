import 'package:injectable/injectable.dart';

import 'package:waterbus_sdk/core/api/rooms/datasources/room_remote_datesource.dart';
import 'package:waterbus_sdk/types/externals/models/index.dart';
import 'package:waterbus_sdk/types/internals/models/create_room_params.dart';
import 'package:waterbus_sdk/types/result.dart';

abstract class RoomRepository {
  Future<Result<Room>> createRoom(CreateRoomParams params);
  Future<Result<bool>> updateRoom(CreateRoomParams params);
  Future<Result<Room>> joinRoomWithPassword(CreateRoomParams params);
  Future<Result<Room>> joinRoomWithoutPassword(CreateRoomParams params);
  Future<Result<Room>> getInfoRoom(int code);
}

@LazySingleton(as: RoomRepository)
class RoomRepositoryImpl extends RoomRepository {
  final RoomRemoteDataSource _remoteDataSource;

  RoomRepositoryImpl(this._remoteDataSource);

  @override
  Future<Result<Room>> createRoom(CreateRoomParams params) async {
    Result<Room> result = await _remoteDataSource.createRoom(
      room: params.room,
      password: params.password,
    );

    if (result.isFailure) return result;

    result = Result.success(
      findMyParticipantObject(result.value!, userId: params.userId),
    );

    return result;
  }

  @override
  Future<Result<Room>> getInfoRoom(int code) async {
    final Result<Room> room = await _remoteDataSource.getInfoRoom(code);

    return room;
  }

  @override
  Future<Result<Room>> joinRoomWithPassword(
    CreateRoomParams params,
  ) async {
    Result<Room> result = await _remoteDataSource.joinRoomWithPassword(
      room: params.room,
      password: params.password,
    );

    if (result.isFailure) return result;

    result = Result.success(
      findMyParticipantObject(result.value!, userId: params.userId),
    );

    return result;
  }

  @override
  Future<Result<Room>> joinRoomWithoutPassword(CreateRoomParams params) async {
    Result<Room> result = await _remoteDataSource.joinRoomWithoutPassword(
      room: params.room,
    );

    if (result.isFailure) return result;

    result = Result.success(
      findMyParticipantObject(
        result.value!,
        userId: params.userId,
      ),
    );

    return result;
  }

  @override
  Future<Result<bool>> updateRoom(CreateRoomParams params) async {
    final Result<bool> isUpdateSucceed = await _remoteDataSource.updateRoom(
      room: params.room,
      password: params.password,
    );

    return isUpdateSucceed;
  }

  // MARK: private
  Room findMyParticipantObject(
    Room room, {
    int? userId,
    int? participantId,
  }) {
    final List<Participant> participants =
        room.participants.map((e) => e).toList();

    final int indexOfMyParticipant = participants.lastIndexWhere(
      (participant) => participantId != null
          ? participant.id == participantId
          : participant.user?.id == userId,
    );

    if (indexOfMyParticipant == -1) return room;

    participants.add(participants[indexOfMyParticipant].copyWith(isMe: true));
    participants.removeAt(indexOfMyParticipant);

    return room.copyWith(participants: participants);
  }
}
