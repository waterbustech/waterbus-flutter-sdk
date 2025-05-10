import 'package:injectable/injectable.dart';

import 'package:waterbus_sdk/core/api/meetings/datasources/meeting_remote_datesource.dart';
import 'package:waterbus_sdk/types/index.dart';
import 'package:waterbus_sdk/types/models/create_meeting_params.dart';
import 'package:waterbus_sdk/types/models/record_model.dart';
import 'package:waterbus_sdk/types/result.dart';

abstract class MeetingRepository {
  Future<Result<Meeting>> createMeeting(CreateMeetingParams params);
  Future<Result<bool>> updateMeeting(CreateMeetingParams params);
  Future<Result<Meeting>> joinMeetingWithPassword(
    CreateMeetingParams params,
  );
  Future<Result<Meeting>> joinMeetingWithoutPassword(
    CreateMeetingParams params,
  );
  Future<Result<Meeting>> getInfoMeeting(int code);
  Future<Result<List<RecordModel>>> getRecords({
    required int skip,
    required int limit,
  });
  Future<Result<int>> startRecord(int roomId);
  Future<Result<bool>> stopRecord(int roomId);
}

@LazySingleton(as: MeetingRepository)
class MeetingRepositoryImpl extends MeetingRepository {
  final MeetingRemoteDataSource _remoteDataSource;

  MeetingRepositoryImpl(this._remoteDataSource);

  @override
  Future<Result<Meeting>> createMeeting(
    CreateMeetingParams params,
  ) async {
    Result<Meeting> result = await _remoteDataSource.createMeeting(
      meeting: params.meeting,
      password: params.password,
    );

    if (result.isFailure) return result;

    result = Result.success(
      findMyParticipantObject(result.value!, userId: params.userId),
    );

    return result;
  }

  @override
  Future<Result<Meeting>> getInfoMeeting(int code) async {
    final Result<Meeting> meeting =
        await _remoteDataSource.getInfoMeeting(code);

    return meeting;
  }

  @override
  Future<Result<Meeting>> joinMeetingWithPassword(
    CreateMeetingParams params,
  ) async {
    Result<Meeting> result = await _remoteDataSource.joinMeetingWithPassword(
      meeting: params.meeting,
      password: params.password,
    );

    if (result.isFailure) return result;

    result = Result.success(
      findMyParticipantObject(result.value!, userId: params.userId),
    );

    return result;
  }

  @override
  Future<Result<Meeting>> joinMeetingWithoutPassword(
    CreateMeetingParams params,
  ) async {
    Result<Meeting> result = await _remoteDataSource.joinMeetingWithoutPassword(
      meeting: params.meeting,
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
  Future<Result<bool>> updateMeeting(
    CreateMeetingParams params,
  ) async {
    final Result<bool> isUpdateSucceed = await _remoteDataSource.updateMeeting(
      meeting: params.meeting,
      password: params.password,
    );

    return isUpdateSucceed;
  }

  // MARK: private
  Meeting findMyParticipantObject(
    Meeting meeting, {
    int? userId,
    int? participantId,
  }) {
    final List<Participant> participants =
        meeting.participants.map((e) => e).toList();

    final int indexOfMyParticipant = participants.lastIndexWhere(
      (participant) => participantId != null
          ? participant.id == participantId
          : participant.user?.id == userId,
    );

    if (indexOfMyParticipant == -1) return meeting;

    participants.add(participants[indexOfMyParticipant].copyWith(isMe: true));
    participants.removeAt(indexOfMyParticipant);

    return meeting.copyWith(participants: participants);
  }

  @override
  Future<Result<List<RecordModel>>> getRecords({
    required int skip,
    required int limit,
  }) async {
    return await _remoteDataSource.getRecords(skip: skip, limit: limit);
  }

  @override
  Future<Result<int>> startRecord(int roomId) async {
    return await _remoteDataSource.startRecord(roomId);
  }

  @override
  Future<Result<bool>> stopRecord(int roomId) async {
    return await _remoteDataSource.stopRecord(roomId);
  }
}
