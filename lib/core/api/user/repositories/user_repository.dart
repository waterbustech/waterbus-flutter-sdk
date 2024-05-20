// Dart imports:
import 'dart:typed_data';

// Package imports:
import 'package:injectable/injectable.dart';

// Project imports:
import 'package:waterbus_sdk/core/api/user/datasources/user_remote_datasource.dart';
import 'package:waterbus_sdk/types/models/user_model.dart';

abstract class UserRepository {
  Future<User?> getUserProfile();
  Future<User?> updateUserProfile(User user);
  Future<bool> updateUsername(String username);
  Future<bool> checkUsername(String username);
  Future<String?> getPresignedUrl();
  Future<String?> uploadImageToS3({
    required String uploadUrl,
    required Uint8List image,
  });
}

@LazySingleton(as: UserRepository)
class UserRepositoryImpl extends UserRepository {
  final UserRemoteDataSource _remoteDataSource;

  UserRepositoryImpl(this._remoteDataSource);

  @override
  Future<User?> getUserProfile() async {
    final User? user = await _remoteDataSource.getUserProfile();

    return user;
  }

  @override
  Future<User?> updateUserProfile(User user) async {
    final bool isUpdateSucceed = await _remoteDataSource.updateUserProfile(
      user,
    );

    if (!isUpdateSucceed) return null;

    return user;
  }

  @override
  Future<String?> getPresignedUrl() async {
    final String? presignedUrl = await _remoteDataSource.getPresignedUrl();

    return presignedUrl;
  }

  @override
  Future<String?> uploadImageToS3({
    required String uploadUrl,
    required Uint8List image,
  }) async {
    final String? urlToImage = await _remoteDataSource.uploadImageToS3(
      uploadUrl: uploadUrl,
      image: image,
    );

    return urlToImage;
  }

  @override
  Future<bool> updateUsername(String username) async {
    final bool isUpdateSucceed =
        await _remoteDataSource.updateUsername(username);

    return isUpdateSucceed;
  }

  @override
  Future<bool> checkUsername(String username) async {
    final bool? isRegistered = await _remoteDataSource.checkUsername(username);

    return isRegistered ?? false;
  }
}
