import 'dart:typed_data';

import 'package:injectable/injectable.dart';

import 'package:waterbus_sdk/core/api/user/datasources/user_remote_datasource.dart';
import 'package:waterbus_sdk/types/models/user_model.dart';
import 'package:waterbus_sdk/types/result.dart';

abstract class UserRepository {
  Future<Result<User>> getUserProfile();
  Future<Result<bool>> updateUserProfile(User user);
  Future<Result<bool>> updateUsername(String username);
  Future<Result<bool>> checkUsername(String username);
  Future<Result<String>> getPresignedUrl();
  Future<Result<String>> uploadImageToS3({
    required String uploadUrl,
    required Uint8List image,
  });
  Future<Result<List<User>>> searchUsers({
    required String keyword,
    required int skip,
    required int limit,
  });
}

@LazySingleton(as: UserRepository)
class UserRepositoryImpl extends UserRepository {
  final UserRemoteDataSource _remoteDataSource;

  UserRepositoryImpl(this._remoteDataSource);

  @override
  Future<Result<User>> getUserProfile() async {
    final Result<User> user = await _remoteDataSource.getUserProfile();

    return user;
  }

  @override
  Future<Result<bool>> updateUserProfile(User user) async {
    final Result<bool> result = await _remoteDataSource.updateUserProfile(
      user,
    );

    return result;
  }

  @override
  Future<Result<String>> getPresignedUrl() async {
    final Result<String> result = await _remoteDataSource.getPresignedUrl();

    return result;
  }

  @override
  Future<Result<String>> uploadImageToS3({
    required String uploadUrl,
    required Uint8List image,
  }) async {
    final Result<String> result = await _remoteDataSource.uploadImageToS3(
      uploadUrl: uploadUrl,
      image: image,
    );

    return result;
  }

  @override
  Future<Result<bool>> updateUsername(String username) async {
    final Result<bool> result =
        await _remoteDataSource.updateUsername(username);

    return result;
  }

  @override
  Future<Result<bool>> checkUsername(String username) async {
    final Result<bool> result = await _remoteDataSource.checkUsername(username);

    return result;
  }

  @override
  Future<Result<List<User>>> searchUsers({
    required String keyword,
    required int skip,
    required int limit,
  }) async {
    final Result<List<User>> result = await _remoteDataSource.searchUsers(
      keyword: keyword,
      limit: limit,
      skip: skip,
    );

    return result;
  }
}
