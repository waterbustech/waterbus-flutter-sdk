// Dart imports:
import 'dart:convert';

// Package imports:
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

// Project imports:
import 'package:waterbus_sdk/core/api/auth/datasources/auth_local_datasource.dart';
import 'package:waterbus_sdk/core/api/auth/datasources/auth_remote_datasource.dart';
import 'package:waterbus_sdk/core/api/auth/repositories/auth_repository.dart';
import 'package:waterbus_sdk/core/api/auth/usecases/login_with_social.dart';
import 'package:waterbus_sdk/types/error/failures.dart';
import 'package:waterbus_sdk/types/index.dart';
import 'package:waterbus_sdk/types/models/auth_payload_model.dart';
import '../../../../constants/sample_file_path.dart';
import '../../../../fixtures/fixture_reader.dart';
import 'auth_repository_imp_test.mocks.dart';

// Package imports:

@GenerateNiceMocks([
  MockSpec<AuthLocalDataSource>(),
  MockSpec<AuthRemoteDataSource>(),
])
void main() {
  late AuthRepositoryImpl repository;
  late MockAuthLocalDataSource mockAuthLocalDataSource;
  late MockAuthRemoteDataSource mockAuthRemoteDataSource;

  setUp(() {
    mockAuthLocalDataSource = MockAuthLocalDataSource();
    mockAuthRemoteDataSource = MockAuthRemoteDataSource();
    repository = AuthRepositoryImpl(
      mockAuthLocalDataSource,
      mockAuthRemoteDataSource,
    );
  });

  group('logInWithSocial', () {
    final AuthParams authParams = AuthParams(
      payloadModel: AuthPayloadModel(fullName: ''),
    );

    test('login success', () async {
      // arrange
      final Map<String, dynamic> userJson = jsonDecode(
        fixture(userSample),
      );
      final User user = User.fromMap(userJson);

      when(mockAuthRemoteDataSource.signInWithSocial(authParams.payloadModel))
          .thenAnswer(
        (realInvocation) => Future.value(user),
      );

      // act
      final Either<Failure, User> result = await repository.loginWithSocial(
        authParams,
      );

      // assert
      expect(
        result.isRight(),
        Right<Failure, User>(user).isRight(),
      );

      verify(repository.loginWithSocial(authParams));
      verifyNever(
        mockAuthLocalDataSource.saveTokens(accessToken: '', refreshToken: ''),
      );
    });
  });

  group('logOut', () {
    test('log out success', () async {
      // arrange
      when(mockAuthRemoteDataSource.logOut()).thenAnswer(
        (realInvocation) => Future.value(true),
      );

      // act
      final Either<Failure, bool> result = await repository.logOut();

      // assert
      expect(result.isRight(), const Right<Failure, bool>(true).isRight());

      verify(mockAuthRemoteDataSource.logOut());
      verify(mockAuthLocalDataSource.clearToken());
    });
  });
}
