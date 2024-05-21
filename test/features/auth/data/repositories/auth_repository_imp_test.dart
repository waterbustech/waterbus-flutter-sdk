// Dart imports:
import 'dart:convert';

// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

// Project imports:
import 'package:waterbus_sdk/core/api/auth/datasources/auth_local_datasource.dart';
import 'package:waterbus_sdk/core/api/auth/datasources/auth_remote_datasource.dart';
import 'package:waterbus_sdk/core/api/auth/repositories/auth_repository.dart';
import 'package:waterbus_sdk/types/index.dart';
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
    final AuthPayloadModel authParams = AuthPayloadModel(fullName: '');
    test('login success', () async {
      // arrange
      final Map<String, dynamic> userJson = jsonDecode(
        fixture(userSample),
      );
      final User user = User.fromMap(userJson);

      when(mockAuthRemoteDataSource.signInWithSocial(authParams)).thenAnswer(
        (realInvocation) => Future.value(user),
      );

      // act
      final User? result = await repository.loginWithSocial(
        authParams,
      );

      // assert
      expect(result, user);

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
      final bool result = await repository.logOut();

      // assert
      expect(result, true);

      verify(mockAuthRemoteDataSource.logOut());
      verify(mockAuthLocalDataSource.clearToken());
    });
  });
}
