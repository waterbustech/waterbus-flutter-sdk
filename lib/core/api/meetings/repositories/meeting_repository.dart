// Package imports:
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

// Project imports:
import 'package:waterbus_sdk/core/api/meetings/datasources/meeting_remote_datesource.dart';
import 'package:waterbus_sdk/core/api/meetings/usecases/create_meeting.dart';
import 'package:waterbus_sdk/core/api/meetings/usecases/get_info_meeting.dart';
import 'package:waterbus_sdk/types/error/failures.dart';
import 'package:waterbus_sdk/types/index.dart';

abstract class MeetingRepository {
  Future<Either<Failure, Meeting>> createMeeting(CreateMeetingParams params);
  Future<Either<Failure, Meeting>> updateMeeting(CreateMeetingParams params);
  Future<Either<Failure, Meeting>> joinMeetingWithPassword(
    CreateMeetingParams params,
  );
  Future<Either<Failure, Meeting>> joinMeetingWithoutPassword(
    CreateMeetingParams params,
  );
  Future<Either<Failure, Meeting>> getInfoMeeting(GetMeetingParams params);
}

@LazySingleton(as: MeetingRepository)
class MeetingRepositoryImpl extends MeetingRepository {
  final MeetingRemoteDataSource _remoteDataSource;

  MeetingRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, Meeting>> createMeeting(
    CreateMeetingParams params,
  ) async {
    Meeting? meeting = await _remoteDataSource.createMeeting(
      meeting: params.meeting,
      password: params.password,
    );

    if (meeting == null) {
      return Left(NullValue());
    }

    meeting = findMyParticipantObject(meeting, userId: params.userId);

    return Right(meeting);
  }

  @override
  Future<Either<Failure, Meeting>> getInfoMeeting(
    GetMeetingParams params,
  ) async {
    final Meeting? meeting = await _remoteDataSource.getInfoMeeting(
      params.code,
    );

    if (meeting == null) return Left(NullValue());

    return Right(meeting);
  }

  @override
  Future<Either<Failure, Meeting>> joinMeetingWithPassword(
    CreateMeetingParams params,
  ) async {
    Meeting? meeting = await _remoteDataSource.joinMeetingWithPassword(
      meeting: params.meeting,
      password: params.password,
    );

    if (meeting == null) return Left(NullValue());

    meeting = findMyParticipantObject(meeting, userId: params.userId);

    return Right(meeting);
  }

  @override
  Future<Either<Failure, Meeting>> joinMeetingWithoutPassword(
    CreateMeetingParams params,
  ) async {
    Meeting? meeting = await _remoteDataSource.joinMeetingWithoutPassword(
      meeting: params.meeting,
    );

    if (meeting == null) return Left(NullValue());

    meeting = findMyParticipantObject(
      meeting,
      userId: params.userId,
    );

    return Right(meeting);
  }

  @override
  Future<Either<Failure, Meeting>> updateMeeting(
    CreateMeetingParams params,
  ) async {
    final bool isUpdateSucceed = await _remoteDataSource.updateMeeting(
      meeting: params.meeting,
      password: params.password,
    );

    if (!isUpdateSucceed) return Left(NullValue());

    // Insert
    // _localDataSource.insertOrUpdate(meeting);

    return Right(params.meeting);
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
          : participant.user.id == userId,
    );

    if (indexOfMyParticipant == -1) return meeting;

    participants.add(participants[indexOfMyParticipant].copyWith(isMe: true));
    participants.removeAt(indexOfMyParticipant);

    return meeting.copyWith(participants: participants);
  }
}
