// Package imports:
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

// Project imports:
import 'package:waterbus_sdk/core/api/base/usecase.dart';
import 'package:waterbus_sdk/core/api/user/repositories/user_repository.dart';
import 'package:waterbus_sdk/types/error/failures.dart';

@injectable
class GetPresignedUrl implements UseCase<String, NoParams> {
  final UserRepository repository;

  GetPresignedUrl(this.repository);

  @override
  Future<Either<Failure, String>> call(NoParams? params) async {
    return await repository.getPresignedUrl();
  }
}
