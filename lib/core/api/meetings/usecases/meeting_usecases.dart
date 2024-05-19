// Package imports:
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

// Project imports:
import 'package:waterbus_sdk/core/api/meetings/usecases/index.dart';
import 'package:waterbus_sdk/types/error/failures.dart';
import 'package:waterbus_sdk/types/models/meeting_model.dart';

@Singleton()
class MeetingUsecases {
  final CreateMeeting _createMeeting;
  final JoinMeeting _joinMeeting;
  final UpdateMeeting _updateMeeting;
  final GetInfoMeeting _getInfoMeeting;

  MeetingUsecases(
    this._createMeeting,
    this._joinMeeting,
    this._getInfoMeeting,
    this._updateMeeting,
  );

  Future<Either<Failure, Meeting>> createMeeting(
    Meeting meeting,
    String password,
    int? userId,
  ) async {
    return await _createMeeting.call(
      CreateMeetingParams(
        meeting: meeting,
        password: password,
        userId: userId,
      ),
    );
  }

  Future<Either<Failure, Meeting>> joinMeeting(
    Meeting meeting,
    String password,
    int? userId,
  ) async {
    return await _joinMeeting.call(
      CreateMeetingParams(
        meeting: meeting,
        password: password,
        userId: userId,
      ),
    );
  }

  Future<Either<Failure, Meeting>> updateMeeting(
    Meeting meeting,
    String password,
    int? userId,
  ) async {
    return await _updateMeeting.call(
      CreateMeetingParams(
        meeting: meeting,
        password: password,
        userId: userId,
      ),
    );
  }

  Future<Either<Failure, Meeting>> getInfoMeeting(int code) async {
    return await _getInfoMeeting.call(GetMeetingParams(code: code));
  }
}
