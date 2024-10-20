import 'package:injectable/injectable.dart';

import 'package:waterbus_sdk/core/api/meetings/datasources/meeting_remote_datesource.dart';
import 'package:waterbus_sdk/types/index.dart';
import 'package:waterbus_sdk/types/models/create_meeting_params.dart';
import 'package:waterbus_sdk/types/models/record_model.dart';

abstract class MeetingRepository {
  Future<Meeting?> createMeeting(CreateMeetingParams params);
  Future<Meeting?> updateMeeting(CreateMeetingParams params);
  Future<Meeting?> joinMeetingWithPassword(
    CreateMeetingParams params,
  );
  Future<Meeting?> joinMeetingWithoutPassword(
    CreateMeetingParams params,
  );
  Future<Meeting?> getInfoMeeting(int code);
  Future<List<RecordModel>> getRecords({required int skip, required int limit});
  Future<int?> startRecord(int roomId);
  Future<bool> stopRecord(int roomId);
}

@LazySingleton(as: MeetingRepository)
class MeetingRepositoryImpl extends MeetingRepository {
  final MeetingRemoteDataSource _remoteDataSource;

  MeetingRepositoryImpl(this._remoteDataSource);

  @override
  Future<Meeting?> createMeeting(
    CreateMeetingParams params,
  ) async {
    Meeting? meeting = await _remoteDataSource.createMeeting(
      meeting: params.meeting,
      password: params.password,
    );

    if (meeting == null) return null;

    meeting = findMyParticipantObject(meeting, userId: params.userId);

    return meeting;
  }

  @override
  Future<Meeting?> getInfoMeeting(int code) async {
    final Meeting? meeting = await _remoteDataSource.getInfoMeeting(code);

    if (meeting == null) return null;

    return meeting;
  }

  @override
  Future<Meeting?> joinMeetingWithPassword(
    CreateMeetingParams params,
  ) async {
    Meeting? meeting = await _remoteDataSource.joinMeetingWithPassword(
      meeting: params.meeting,
      password: params.password,
    );

    if (meeting == null) return null;

    meeting = findMyParticipantObject(meeting, userId: params.userId);

    return meeting;
  }

  @override
  Future<Meeting?> joinMeetingWithoutPassword(
    CreateMeetingParams params,
  ) async {
    Meeting? meeting = await _remoteDataSource.joinMeetingWithoutPassword(
      meeting: params.meeting,
    );

    if (meeting == null) return null;

    meeting = findMyParticipantObject(
      meeting,
      userId: params.userId,
    );

    return meeting;
  }

  @override
  Future<Meeting?> updateMeeting(
    CreateMeetingParams params,
  ) async {
    final bool isUpdateSucceed = await _remoteDataSource.updateMeeting(
      meeting: params.meeting,
      password: params.password,
    );

    if (!isUpdateSucceed) return null;

    return params.meeting;
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
  Future<List<RecordModel>> getRecords({
    required int skip,
    required int limit,
  }) async {
    return await _remoteDataSource.getRecords(skip: skip, limit: limit);
  }

  @override
  Future<int?> startRecord(int roomId) async {
    return await _remoteDataSource.startRecord(roomId);
  }

  @override
  Future<bool> stopRecord(int roomId) async {
    return await _remoteDataSource.stopRecord(roomId);
  }
}
