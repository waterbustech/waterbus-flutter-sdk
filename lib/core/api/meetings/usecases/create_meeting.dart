// Package imports:
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

// Project imports:
import 'package:waterbus_sdk/core/api/base/usecase.dart';
import 'package:waterbus_sdk/core/api/meetings/repositories/meeting_repository.dart';
import 'package:waterbus_sdk/types/error/failures.dart';
import 'package:waterbus_sdk/types/index.dart';

@injectable
class CreateMeeting implements UseCase<Meeting, CreateMeetingParams> {
  final MeetingRepository repository;

  CreateMeeting(this.repository);

  @override
  Future<Either<Failure, Meeting>> call(CreateMeetingParams params) async {
    return await repository.createMeeting(params);
  }
}

class CreateMeetingParams extends Equatable {
  final Meeting meeting;
  final String password;
  final int? userId;

  const CreateMeetingParams({
    required this.meeting,
    required this.password,
    this.userId,
  });

  @override
  List<Object> get props => [meeting, password];
}
