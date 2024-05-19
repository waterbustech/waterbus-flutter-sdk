// Package imports:
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

// Project imports:
import 'package:waterbus_sdk/core/api/auth/repositories/auth_repository.dart';
import 'package:waterbus_sdk/core/api/base/usecase.dart';
import 'package:waterbus_sdk/types/error/failures.dart';
import 'package:waterbus_sdk/types/models/auth_payload_model.dart';
import 'package:waterbus_sdk/types/models/user_model.dart';

@injectable
class LoginWithSocial implements UseCase<User, AuthParams> {
  final AuthRepository repository;

  LoginWithSocial(this.repository);

  @override
  Future<Either<Failure, User>> call(AuthParams params) async {
    return await repository.loginWithSocial(params);
  }
}

class AuthParams extends Equatable {
  final AuthPayloadModel payloadModel;

  const AuthParams({required this.payloadModel});

  @override
  List<Object> get props => [payloadModel];
}
