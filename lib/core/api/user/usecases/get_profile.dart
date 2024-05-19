// Package imports:
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

// Project imports:
import 'package:waterbus_sdk/core/api/base/usecase.dart';
import 'package:waterbus_sdk/core/api/user/repositories/user_repository.dart';
import 'package:waterbus_sdk/types/error/failures.dart';
import 'package:waterbus_sdk/types/models/user_model.dart';

@injectable
class GetProfile implements UseCase<User, NoParams> {
  final UserRepository repository;

  GetProfile(this.repository);

  @override
  Future<Either<Failure, User>> call(NoParams? params) async {
    return await repository.getUserProfile();
  }
}
