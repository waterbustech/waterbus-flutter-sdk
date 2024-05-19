// Package imports:
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

// Project imports:
import 'package:waterbus_sdk/core/api/auth/repositories/auth_repository.dart';
import 'package:waterbus_sdk/core/api/base/usecase.dart';
import 'package:waterbus_sdk/types/error/failures.dart';

@injectable
class RefreshToken implements UseCase<bool, NoParams> {
  final AuthRepository repository;

  RefreshToken(this.repository);

  @override
  Future<Either<Failure, bool>> call(NoParams? params) async {
    return await repository.refreshToken();
  }
}
