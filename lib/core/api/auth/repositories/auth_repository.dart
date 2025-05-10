import 'package:injectable/injectable.dart';

import 'package:waterbus_sdk/core/api/auth/datasources/auth_local_datasource.dart';
import 'package:waterbus_sdk/core/api/auth/datasources/auth_remote_datasource.dart';
import 'package:waterbus_sdk/types/error/failures.dart';
import 'package:waterbus_sdk/types/models/auth_payload_model.dart';
import 'package:waterbus_sdk/types/models/user_model.dart';
import 'package:waterbus_sdk/types/result.dart';

abstract class AuthRepository {
  Future<Result<bool>> refreshToken();
  Future<Result<User>> loginWithSocial(AuthPayloadModel params);
  Future<Result<bool>> logOut();
}

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl extends AuthRepository {
  final AuthLocalDataSource _localDataSource;
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepositoryImpl(this._localDataSource, this._remoteDataSource);

  @override
  Future<Result<User>> loginWithSocial(AuthPayloadModel params) async {
    final Result<User> result =
        await _remoteDataSource.signInWithSocial(params);

    return result;
  }

  @override
  Future<Result<bool>> refreshToken() async {
    final (String? accessToken, String? refreshToken) =
        await _remoteDataSource.refreshToken();

    if (accessToken == null || refreshToken == null) {
      return Result.failure(ServerFailure());
    }

    _localDataSource.saveTokens(
      accessToken: accessToken,
      refreshToken: refreshToken,
    );

    return Result.success(true);
  }

  @override
  Future<Result<bool>> logOut() async {
    final Result<bool> result = await _remoteDataSource.logOut();

    _localDataSource.clearToken();

    return result;
  }
}
