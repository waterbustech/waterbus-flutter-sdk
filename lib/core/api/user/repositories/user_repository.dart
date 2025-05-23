import 'dart:typed_data';

import 'package:injectable/injectable.dart';

import 'package:waterbus_sdk/core/api/user/datasources/user_remote_data_source.dart';
import 'package:waterbus_sdk/types/externals/models/index.dart';
import 'package:waterbus_sdk/types/result.dart';

abstract class UserRepository {
  Future<Result<User>> getUserProfile();
  Future<Result<bool>> updateUserProfile(User user);
  Future<Result<bool>> updateUsername(String username);
  Future<Result<bool>> checkUsername(String username);
  Future<Result<PresignedUrl>> getPresignedUrl();
  Future<Result<String>> uploadAvatarToCloud({
    required String presignedUrl,
    required String sourceUrl,
    required Uint8List image,
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
  Future<Result<PresignedUrl>> getPresignedUrl() async {
    final Result<PresignedUrl> result =
        await _remoteDataSource.getPresignedUrl();

    return result;
  }

  @override
  Future<Result<String>> uploadAvatarToCloud({
    required String presignedUrl,
    required String sourceUrl,
    required Uint8List image,
  }) async {
    final Result<String> result = await _remoteDataSource.uploadAvatarToCloud(
      presignedUrl: presignedUrl,
      sourceUrl: sourceUrl,
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
}
