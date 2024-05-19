// Dart imports:
import 'dart:typed_data';

// Package imports:
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

// Project imports:
import 'package:waterbus_sdk/core/api/user/usecases/index.dart';
import 'package:waterbus_sdk/types/error/failures.dart';
import 'package:waterbus_sdk/types/models/user_model.dart';

@Singleton()
class UseUsecases {
  final GetProfile _getProfile;
  final UpdateProfile _updateProfile;
  final UpdateUsername _updateUsername;
  final CheckUsername _checkUsername;
  final GetPresignedUrl _getPresignedUrl;
  final UploadAvatar _uploadAvatar;

  UseUsecases(
    this._getProfile,
    this._updateProfile,
    this._updateUsername,
    this._checkUsername,
    this._getPresignedUrl,
    this._uploadAvatar,
  );

  Future<Either<Failure, User>> getProfile() async {
    return await _getProfile.call(null);
  }

  Future<Either<Failure, User>> updateProfile(User user) async {
    return await _updateProfile.call(UpdateUserParams(user: user));
  }

  Future<Either<Failure, bool>> updateUsername(String username) async {
    return await _updateUsername.call(UpdateUsernameParams(username: username));
  }

  Future<Either<Failure, bool>> checkUsername(String username) async {
    return await _checkUsername.call(CheckUsernameParams(username: username));
  }

  Future<Either<Failure, String>> getPresignedUrl() async {
    return await _getPresignedUrl.call(null);
  }

  Future<Either<Failure, String>> uploadAvatar(
    Uint8List image,
    String uploadUrl,
  ) async {
    return await _uploadAvatar.call(
      UploadAvatarParams(
        image: image,
        uploadUrl: uploadUrl,
      ),
    );
  }
}
