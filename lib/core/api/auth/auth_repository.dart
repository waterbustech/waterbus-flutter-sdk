// Package imports:
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

// Project imports:
import 'package:waterbus_sdk/constants/api_enpoints.dart';
import 'package:waterbus_sdk/constants/http_status_code.dart';
import 'package:waterbus_sdk/core/api/base/base_remote_data.dart';
import 'package:waterbus_sdk/types/error/failures.dart';
import 'package:waterbus_sdk/types/models/auth_payload_model.dart';
import 'package:waterbus_sdk/types/models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<(String, String)> refreshToken();
  Future<User?> signInWithSocial(AuthPayloadModel authPayload);
  Future<bool> logOut();
}

@LazySingleton(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl extends AuthRemoteDataSource {
  final BaseRemoteData _baseRemoteData;

  AuthRemoteDataSourceImpl(this._baseRemoteData);

  @override
  Future<User?> signInWithSocial(AuthPayloadModel authPayload) async {
    final Map<String, dynamic> body = authPayload.toMap();
    final Response response = await _baseRemoteData.postRoute(
      ApiEndpoints.auth,
      body: body,
    );

    if (response.statusCode == StatusCode.created) {
      return User.fromMap(response.data);
    }

    return null;
  }

  @override
  Future<(String, String)> refreshToken() async {
    final Response response = await _baseRemoteData.dio.get(
      ApiEndpoints.auth,
      options: _baseRemoteData.getOptionsRefreshToken,
    );

    if (response.statusCode == StatusCode.ok) {
      final rawData = response.data;
      return (rawData['token'] as String, rawData['refreshToken'] as String);
    }

    throw ServerFailure();
  }

  @override
  Future<bool> logOut() async {
    final Response response = await _baseRemoteData.deleteRoute(
      ApiEndpoints.auth,
    );

    if (response.statusCode == StatusCode.noContent) {
      return true;
    }

    return false;
  }
}
