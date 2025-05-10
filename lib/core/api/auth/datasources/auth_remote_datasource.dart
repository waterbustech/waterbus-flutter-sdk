import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import 'package:waterbus_sdk/constants/endpoints.dart';
import 'package:waterbus_sdk/constants/status_code.dart';
import 'package:waterbus_sdk/core/api/auth/datasources/auth_local_datasource.dart';
import 'package:waterbus_sdk/core/api/base/base_remote_data.dart';
import 'package:waterbus_sdk/types/error/failures.dart';
import 'package:waterbus_sdk/types/models/auth_payload_model.dart';
import 'package:waterbus_sdk/types/models/user_model.dart';
import 'package:waterbus_sdk/types/result.dart';

abstract class AuthRemoteDataSource {
  Future<(String?, String?)> refreshToken();
  Future<Result<User>> signInWithSocial(AuthPayloadModel authPayload);
  Future<Result<bool>> logOut();
}

@LazySingleton(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl extends AuthRemoteDataSource {
  final BaseRemoteData _baseRemoteData;
  final AuthLocalDataSource _localDataSource;

  AuthRemoteDataSourceImpl(this._baseRemoteData, this._localDataSource);

  @override
  Future<Result<User>> signInWithSocial(AuthPayloadModel authPayload) async {
    final Map<String, dynamic> body = authPayload.toJson();

    final Response response = await _baseRemoteData.post(
      Endpoints.auth,
      body: body,
    );

    if (response.statusCode == StatusCode.created) {
      final String accessToken = response.data['token'];
      final String refreshToken = response.data['refreshToken'];

      _localDataSource.saveTokens(
        accessToken: accessToken,
        refreshToken: refreshToken,
      );

      return Result.success(User.fromJson(response.data['user']));
    }

    return Result.failure(ServerFailure());
  }

  @override
  Future<(String?, String?)> refreshToken() async {
    final Response response = await _baseRemoteData.dio.get(
      Endpoints.auth,
      options: _baseRemoteData.getOptionsRefreshToken,
    );

    if (response.statusCode == StatusCode.ok) {
      final rawData = response.data;
      return (rawData['token'] as String, rawData['refreshToken'] as String);
    }

    return (null, null);
  }

  @override
  Future<Result<bool>> logOut() async {
    final Response response = await _baseRemoteData.delete(
      Endpoints.auth,
    );

    if (response.statusCode == StatusCode.noContent) {
      return Result.success(true);
    }

    return Result.failure(ServerFailure());
  }
}
