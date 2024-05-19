// Package imports:
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

// Project imports:
import 'package:waterbus_sdk/core/api/base/usecase.dart';
import 'package:waterbus_sdk/core/api/user/repositories/user_repository.dart';
import 'package:waterbus_sdk/types/error/failures.dart';
import 'package:waterbus_sdk/types/models/user_model.dart';

@injectable
class UpdateProfile implements UseCase<User, UpdateUserParams> {
  final UserRepository repository;

  UpdateProfile(this.repository);

  @override
  Future<Either<Failure, User>> call(UpdateUserParams params) async {
    return await repository.updateUserProfile(params.user);
  }
}

class UpdateUserParams extends Equatable {
  final User user;

  const UpdateUserParams({required this.user});

  @override
  List<Object> get props => [user];
}
