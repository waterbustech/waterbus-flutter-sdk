// Package imports:
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

// Project imports:
import 'package:waterbus_sdk/core/api/auth/datasources/auth_local_datasource.dart';
import 'package:waterbus_sdk/core/api/auth/datasources/auth_remote_datasource.dart';
import 'package:waterbus_sdk/core/api/auth/usecases/login_with_social.dart';
import 'package:waterbus_sdk/types/error/failures.dart';
import 'package:waterbus_sdk/types/models/user_model.dart';

abstract class AuthRepository {
  Future<Either<Failure, bool>> refreshToken();
  Future<Either<Failure, User>> loginWithSocial(AuthParams params);
  Future<Either<Failure, bool>> logOut();
}

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl extends AuthRepository {
  final AuthLocalDataSource _localDataSource;
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepositoryImpl(this._localDataSource, this._remoteDataSource);

  @override
  Future<Either<Failure, User>> loginWithSocial(AuthParams params) async {
    final User? response = await _remoteDataSource.signInWithSocial(
      params.payloadModel,
    );

    if (response == null) return Left(NullValue());

    return Right(response);
  }

  @override
  Future<Either<Failure, bool>> refreshToken() async {
    try {
      final (String accessToken, String refreshToken) =
          await _remoteDataSource.refreshToken();

      _localDataSource.saveTokens(
        accessToken: accessToken,
        refreshToken: refreshToken,
      );

      return const Right(true);
    } catch (_) {
      return Left(NullValue());
    }
  }

  @override
  Future<Either<Failure, bool>> logOut() async {
    final bool isSignedOut = await _remoteDataSource.logOut();

    _localDataSource.clearToken();
    return Right(isSignedOut);
  }
}
