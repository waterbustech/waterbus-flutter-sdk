import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import 'package:waterbus_sdk/constants/api_enpoints.dart';
import 'package:waterbus_sdk/constants/http_status_code.dart';
import 'package:waterbus_sdk/core/api/auth/datasources/auth_local_datasource.dart';
import 'package:waterbus_sdk/core/api/base/base_remote_data.dart';
import 'package:waterbus_sdk/types/models/auth_payload_model.dart';
import 'package:waterbus_sdk/types/models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<(String?, String?)> refreshToken();
  Future<User?> signInWithSocial(AuthPayloadModel authPayload);
  Future<bool> logOut();
}

@LazySingleton(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl extends AuthRemoteDataSource {
  final BaseRemoteData _baseRemoteData;
  final AuthLocalDataSource _localDataSource;

  AuthRemoteDataSourceImpl(this._baseRemoteData, this._localDataSource);

  @override
  Future<User?> signInWithSocial(AuthPayloadModel authPayload) async {
    final Map<String, dynamic> body = authPayload.toMap();

    final Response response = await _baseRemoteData.postRoute(
      ApiEndpoints.auth,
      body: body,
    );

    if (response.statusCode == StatusCode.created) {
      final String accessToken = response.data['token'];
      final String refreshToken = response.data['refreshToken'];

      _localDataSource.saveTokens(
        accessToken: accessToken,
        refreshToken: refreshToken,
      );

      return User.fromMap(response.data['user']);
    }

    return null;
  }

  @override
  Future<(String?, String?)> refreshToken() async {
    final Response response = await _baseRemoteData.dio.get(
      ApiEndpoints.auth,
      options: _baseRemoteData.getOptionsRefreshToken,
    );

    if (response.statusCode == StatusCode.ok) {
      final rawData = response.data;
      return (rawData['token'] as String, rawData['refreshToken'] as String);
    }

    return (null, null);
  }

  @override
  Future<bool> logOut() async {
    final Response response = await _baseRemoteData.deleteRoute(
      ApiEndpoints.auth,
    );

    return response.statusCode == StatusCode.noContent;
  }
}
