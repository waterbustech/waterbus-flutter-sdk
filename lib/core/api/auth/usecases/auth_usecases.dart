// Package imports:
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

// Project imports:
import 'package:waterbus_sdk/core/api/auth/usecases/index.dart';
import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';
import 'package:waterbus_sdk/types/error/failures.dart';
import 'package:waterbus_sdk/types/models/auth_payload_model.dart';

@Singleton()
class AuthUsecases {
  final LoginWithSocial _loginWithSocial;
  final LogOut _logOut;
  final RefreshToken _refreshToken;

  AuthUsecases(this._logOut, this._loginWithSocial, this._refreshToken);

  Future<Either<Failure, User>> loginWithSocial(
    AuthPayloadModel payloadModel,
  ) async {
    return await _loginWithSocial.call(AuthParams(payloadModel: payloadModel));
  }

  Future<Either<Failure, bool>> logOut() async {
    return await _logOut.call(null);
  }

  Future<Either<Failure, bool>> refreshToken() async {
    return await _refreshToken.call(null);
  }
}
