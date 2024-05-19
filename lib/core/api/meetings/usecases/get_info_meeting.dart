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
class GetInfoMeeting implements UseCase<Meeting, GetMeetingParams> {
  final MeetingRepository repository;

  GetInfoMeeting(this.repository);

  @override
  Future<Either<Failure, Meeting>> call(GetMeetingParams params) async {
    return await repository.getInfoMeeting(params);
  }
}

class GetMeetingParams extends Equatable {
  final int code;

  const GetMeetingParams({required this.code});

  @override
  List<Object> get props => [code];
}
