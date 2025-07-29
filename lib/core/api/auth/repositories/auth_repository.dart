import 'package:injectable/injectable.dart';

import 'package:waterbus_sdk/core/api/auth/datasources/auth_local_data_source.dart';
import 'package:waterbus_sdk/core/api/auth/datasources/auth_remote_data_source.dart';
import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';
import 'package:waterbus_sdk/types/internals/models/index.dart';

abstract class AuthRepository {
  Future<Result<bool>> renewToken();
  Future<Result<User>> createToken(AuthPayload params);
  Future<Result<bool>> deleteToken();
  Future<IceServersResponse> getIceServers();
}

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl extends AuthRepository {
  final AuthLocalDataSource _localDataSource;
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepositoryImpl(this._localDataSource, this._remoteDataSource);

  @override
  Future<Result<User>> createToken(AuthPayload params) async {
    final Result<User> result = await _remoteDataSource.createToken(params);

    return result;
  }

  @override
  Future<Result<bool>> renewToken() async {
    final (String? accessToken, String? refreshToken) =
        await _remoteDataSource.renewToken();

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
  Future<Result<bool>> deleteToken() async {
    final Result<bool> result = await _remoteDataSource.deleteToken();

    _localDataSource.deleteToken();

    return result;
  }

  @override
  Future<IceServersResponse> getIceServers() {
    return _remoteDataSource.getIceServers();
  }
}
