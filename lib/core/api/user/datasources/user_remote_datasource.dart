// Package imports:
// ignore_for_file: depend_on_referenced_packages

import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';

import 'package:waterbus_sdk/constants/api_enpoints.dart';
import 'package:waterbus_sdk/constants/http_status_code.dart';
import 'package:waterbus_sdk/core/api/base/base_remote_data.dart';
import 'package:waterbus_sdk/types/models/user_model.dart';

abstract class UserRemoteDataSource {
  Future<User?> getUserProfile();
  Future<bool> updateUserProfile(User user);
  Future<bool> updateUsername(String username);
  Future<bool?> checkUsername(String username);
  Future<List<User>> searchUsers(String keyword);
  Future<String?> getPresignedUrl();
  Future<String?> uploadImageToS3({
    required String uploadUrl,
    required Uint8List image,
  });
}

@LazySingleton(as: UserRemoteDataSource)
class UserRemoteDataSourceImpl extends UserRemoteDataSource {
  final BaseRemoteData _remoteData;
  UserRemoteDataSourceImpl(this._remoteData);

  @override
  Future<String?> getPresignedUrl() async {
    final Response response = await _remoteData.postRoute(
      ApiEndpoints.presignedUrlS3,
    );

    if (response.statusCode == StatusCode.created) {
      final Map<String, dynamic> rawData = response.data;
      return rawData['presignedUrl'];
    }

    return null;
  }

  @override
  Future<String?> uploadImageToS3({
    required String uploadUrl,
    required Uint8List image,
  }) async {
    try {
      final Uri uri = Uri.parse(uploadUrl);

      final http.Response response = await http.put(
        uri,
        body: image,
        headers: const {"Content-Type": 'image/png'},
      );

      if (response.statusCode == StatusCode.ok) {
        return uploadUrl.split('?').first;
      }

      return null;
    } catch (error) {
      return null;
    }
  }

  @override
  Future<User?> getUserProfile() async {
    final Response response = await _remoteData.getRoute(ApiEndpoints.users);

    if (response.statusCode == StatusCode.ok) {
      final Map<String, dynamic> rawData = response.data;
      return User.fromMap(rawData);
    }

    return null;
  }

  @override
  Future<bool> updateUserProfile(User user) async {
    final Response response = await _remoteData.putRoute(
      ApiEndpoints.users,
      user.toMap(),
    );

    return response.statusCode == StatusCode.ok;
  }

  @override
  Future<bool> updateUsername(String username) async {
    final Response response = await _remoteData.putRoute(
      "${ApiEndpoints.username}/$username",
      {},
    );

    return response.statusCode == StatusCode.ok;
  }

  @override
  Future<bool> checkUsername(String username) async {
    final Response response = await _remoteData.getRoute(
      "${ApiEndpoints.username}/$username",
    );

    if (response.statusCode == StatusCode.ok) {
      return response.data['isRegistered'] ?? false;
    }

    return false;
  }

  @override
  Future<List<User>> searchUsers(String keyword) async {
    final Response response = await _remoteData.getRoute(
      ApiEndpoints.searchUsers,
      query: "q=$keyword&limit=10&skip=0",
    );

    if (response.statusCode == StatusCode.ok) {
      final List data = response.data['hits'];

      return data.map((user) => User.fromMap(user['document'])).toList();
    }

    return [];
  }
}
