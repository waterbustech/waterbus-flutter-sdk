import 'package:injectable/injectable.dart';

import 'package:waterbus_sdk/core/api/rooms/datasources/room_remote_data_source.dart';
import 'package:waterbus_sdk/types/externals/models/index.dart';
import 'package:waterbus_sdk/types/externals/models/join_room_params.dart';
import 'package:waterbus_sdk/types/result.dart';

abstract class RoomRepository {
  Future<Result<Room>> createRoom(RoomParams params);
  Future<Result<bool>> updateRoom(RoomParams params);
  Future<Result<Room>> joinRoom(JoinRoomParams params);
  Future<Result<Room>> getInfoRoom(String code);
}

@LazySingleton(as: RoomRepository)
class RoomRepositoryImpl extends RoomRepository {
  final RoomRemoteDataSource _remoteDataSource;

  RoomRepositoryImpl(this._remoteDataSource);

  @override
  Future<Result<Room>> createRoom(RoomParams params) async {
    Result<Room> result = await _remoteDataSource.createRoom(params: params);

    if (result.isFailure) return result;

    result = Result.success(
      findMyParticipantObject(result.value!, userId: params.userId),
    );

    return result;
  }

  @override
  Future<Result<Room>> getInfoRoom(String code) async {
    final Result<Room> room = await _remoteDataSource.getInfoRoom(code);

    return room;
  }

  @override
  Future<Result<Room>> joinRoom(JoinRoomParams params) async {
    Result<Room> result = await _remoteDataSource.joinRoom(params: params);

    if (result.isFailure) return result;

    result = Result.success(
      findMyParticipantObject(result.value!, userId: params.userId),
    );

    return result;
  }

  @override
  Future<Result<bool>> updateRoom(RoomParams params) async {
    final Result<bool> isUpdateSucceed =
        await _remoteDataSource.updateRoom(params: params);

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
