// Package imports:
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

// Project imports:
import 'package:waterbus_sdk/core/api/base/usecase.dart';
import 'package:waterbus_sdk/core/api/user/repositories/user_repository.dart';
import 'package:waterbus_sdk/types/error/failures.dart';

@injectable
class CheckUsername implements UseCase<bool, CheckUsernameParams> {
  final UserRepository repository;

  CheckUsername(this.repository);

  @override
  Future<Either<Failure, bool>> call(CheckUsernameParams params) async {
    return await repository.checkUsername(params.username);
  }
}

class CheckUsernameParams extends Equatable {
  final String username;

  const CheckUsernameParams({required this.username});

  @override
  List<Object> get props => [username];
}
