// Package imports:
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

// Project imports:
import 'package:waterbus_sdk/core/api/base/usecase.dart';
import 'package:waterbus_sdk/core/api/meetings/repositories/meeting_repository.dart';
import 'package:waterbus_sdk/core/api/meetings/usecases/create_meeting.dart';
import 'package:waterbus_sdk/types/error/failures.dart';
import 'package:waterbus_sdk/types/index.dart';

@injectable
class UpdateMeeting implements UseCase<Meeting, CreateMeetingParams> {
  final MeetingRepository repository;

  UpdateMeeting(this.repository);

  @override
  Future<Either<Failure, Meeting>> call(CreateMeetingParams params) async {
    return await repository.updateMeeting(params);
  }
}
