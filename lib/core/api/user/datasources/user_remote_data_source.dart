// Package imports:
// ignore_for_file: depend_on_referenced_packages

import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';

import 'package:waterbus_sdk/constants/endpoints.dart';
import 'package:waterbus_sdk/constants/status_code.dart';
import 'package:waterbus_sdk/core/api/base/base_remote_data.dart';
import 'package:waterbus_sdk/types/error/app_exception.dart';
import 'package:waterbus_sdk/types/error/failures.dart';
import 'package:waterbus_sdk/types/externals/models/index.dart';
import 'package:waterbus_sdk/types/result.dart';

abstract class UserRemoteDataSource {
  Future<Result<User>> getUserProfile();
  Future<Result<bool>> updateUserProfile(User user);
  Future<Result<bool>> updateUsername(String username);
  Future<Result<bool>> checkUsername(String username);
  Future<Result<List<User>>> searchUsers({
    required String keyword,
    required int skip,
    required int limit,
  });
  Future<Result<PresignedUrl>> getPresignedUrl();
  Future<Result<String>> uploadAvatarToCloud({
    required String presignedUrl,
    required String sourceUrl,
    required Uint8List image,
  });
}

@LazySingleton(as: UserRemoteDataSource)
class UserRemoteDataSourceImpl extends UserRemoteDataSource {
  final BaseRemoteData _remoteData;
  UserRemoteDataSourceImpl(this._remoteData);

  @override
  Future<Result<PresignedUrl>> getPresignedUrl() async {
    final Response response = await _remoteData.post(
      Endpoints.presignedUrlS3,
    );

    if (response.statusCode == StatusCode.created) {
      final Map<String, dynamic> rawData = response.data;
      return Result.success(PresignedUrl.fromJson(rawData));
    }

    return Result.failure(ServerFailure());
  }

  @override
  Future<Result<String>> uploadAvatarToCloud({
    required String presignedUrl,
    required String sourceUrl,
    required Uint8List image,
  }) async {
    try {
      final Uri uri = Uri.parse(presignedUrl);

      final http.Response response = await http.put(
        uri,
        body: image,
        headers: const {
          "Content-Type": 'image/png',
          'x-amz-acl': 'public-read',
        },
      );

      if (response.statusCode == StatusCode.ok) {
        return Result.success(sourceUrl.split('?').first);
      }

      return Result.failure(ServerFailure());
    } catch (error) {
      return Result.failure(ServerFailure());
    }
  }

  @override
  Future<Result<User>> getUserProfile() async {
    final Response response = await _remoteData.get(Endpoints.users);

    if (response.statusCode == StatusCode.ok) {
      final Map<String, dynamic> rawData = response.data;
      return Result.success(User.fromJson(rawData));
    }

    return Result.failure(response.data['message'].toString().toFailure);
  }

  @override
  Future<Result<bool>> updateUserProfile(User user) async {
    final Response response = await _remoteData.put(
      Endpoints.users,
      user.toJson(),
    );

    if (response.statusCode == StatusCode.ok) {
      return Result.success(true);
    }

    return Result.failure(response.data['message'].toString().toFailure);
  }

  @override
  Future<Result<bool>> updateUsername(String username) async {
    final Response response = await _remoteData.put(
      "${Endpoints.username}/$username",
      {},
    );

    if (response.statusCode == StatusCode.ok) {
      return Result.success(true);
    }

    return Result.failure(response.data['message'].toString().toFailure);
  }

  @override
  Future<Result<bool>> checkUsername(String username) async {
    final Response response = await _remoteData.get(
      "${Endpoints.username}/$username",
    );

    if (response.statusCode == StatusCode.ok) {
      return Result.success(response.data['isRegistered'] ?? false);
    }

    return Result.failure(response.data['message'].toString().toFailure);
  }

  @override
  Future<Result<List<User>>> searchUsers({
    required String keyword,
    required int skip,
    required int limit,
  }) async {
    final Response response = await _remoteData.get(
      Endpoints.searchUsers,
      query: "q=$keyword&limit=$limit&skip=$skip",
    );

    if (response.statusCode == StatusCode.ok) {
      final List data = response.data['hits'];

      return Result.success(
        data.map((user) => User.fromJson(user['document'])).toList(),
      );
    }

    return Result.failure(response.data['message'].toString().toFailure);
  }
}
