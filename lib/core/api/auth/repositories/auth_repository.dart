import 'package:injectable/injectable.dart';

import 'package:waterbus_sdk/core/api/auth/datasources/auth_local_datasource.dart';
import 'package:waterbus_sdk/core/api/auth/datasources/auth_remote_datasource.dart';
import 'package:waterbus_sdk/types/models/auth_payload_model.dart';
import 'package:waterbus_sdk/types/models/user_model.dart';

abstract class AuthRepository {
  Future<bool> refreshToken();
  Future<User?> loginWithSocial(AuthPayloadModel params);
  Future<bool> logOut();
}

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl extends AuthRepository {
  final AuthLocalDataSource _localDataSource;
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepositoryImpl(this._localDataSource, this._remoteDataSource);

  @override
  Future<User?> loginWithSocial(AuthPayloadModel params) async {
    final User? response = await _remoteDataSource.signInWithSocial(params);

    return response;
  }

  @override
  Future<bool> refreshToken() async {
    final (String? accessToken, String? refreshToken) =
        await _remoteDataSource.refreshToken();

    if (accessToken == null || refreshToken == null) return false;

    _localDataSource.saveTokens(
      accessToken: accessToken,
      refreshToken: refreshToken,
    );

    return true;
  }

  @override
  Future<bool> logOut() async {
    final bool isSignedOut = await _remoteDataSource.logOut();

    _localDataSource.clearToken();

    return isSignedOut;
  }
}
