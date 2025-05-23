import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:waterbus_sdk/core/api/auth/datasources/auth_local_data_source.dart';
import 'package:waterbus_sdk/core/api/auth/datasources/auth_remote_data_source.dart';
import 'package:waterbus_sdk/core/api/auth/repositories/auth_repository.dart';
import 'package:waterbus_sdk/types/externals/models/index.dart';
import 'package:waterbus_sdk/types/result.dart';
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
    final AuthPayload authParams = AuthPayload(fullName: '', externalId: '');
    test('login success', () async {
      // arrange
      final Map<String, dynamic> userJson = jsonDecode(
        fixture(userSample),
      );
      final User user = User.fromJson(userJson);

      when(mockAuthRemoteDataSource.createToken(authParams)).thenAnswer(
        (realInvocation) => Future.value(Result.success(user)),
      );

      // act
      final Result<User> result = await repository.createToken(
        authParams,
      );

      // assert
      expect(result.value, user);

      verify(repository.createToken(authParams));
      verifyNever(
        mockAuthLocalDataSource.saveTokens(accessToken: '', refreshToken: ''),
      );
    });
  });

  group('logOut', () {
    test('log out success', () async {
      // arrange
      when(mockAuthRemoteDataSource.deleteToken()).thenAnswer(
        (realInvocation) => Future.value(Result.success(true)),
      );

      // act
      final Result<bool> result = await repository.deleteToken();

      // assert
      expect(result.value, true);

      verify(mockAuthRemoteDataSource.deleteToken());
      verify(mockAuthLocalDataSource.deleteToken());
    });
  });
}
