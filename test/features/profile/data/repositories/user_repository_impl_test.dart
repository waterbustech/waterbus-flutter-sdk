import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:waterbus_sdk/core/api/user/datasources/user_remote_datasource.dart';
import 'package:waterbus_sdk/core/api/user/repositories/user_repository.dart';
import 'package:waterbus_sdk/types/error/failures.dart';
import 'package:waterbus_sdk/types/models/user_model.dart';
import 'package:waterbus_sdk/types/result.dart';
import 'user_repository_impl_test.mocks.dart';

@GenerateNiceMocks([MockSpec<UserRemoteDataSource>()])
void main() {
  late UserRepositoryImpl repository;
  late MockUserRemoteDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockUserRemoteDataSource();
    repository = UserRepositoryImpl(mockDataSource);
  });

  final testUser = User(id: 1, userName: 'testuser', fullName: 'Test User');

  group('getUserProfile', () {
    test('should return user from remote data source', () async {
      // Arrange
      when(mockDataSource.getUserProfile())
          .thenAnswer((_) async => Result.success(testUser));

      // Act
      final result = await repository.getUserProfile();

      // Assert
      expect(result.value, testUser);
      verify(mockDataSource.getUserProfile());
      verifyNoMoreInteractions(mockDataSource);
    });

    test('should return a failure from remote data source', () async {
      // Arrange
      when(mockDataSource.getUserProfile()).thenAnswer(
        (realInvocation) async => Result.failure(ServerFailure()),
      );

      // Act
      final result = await repository.getUserProfile();

      // Assert
      expect(result.error, ServerFailure());
      verify(mockDataSource.getUserProfile());
      verifyNoMoreInteractions(mockDataSource);
    });
  });

  group('updateUserProfile', () {
    test('should return updated user from remote data source', () async {
      // Arrange
      when(mockDataSource.updateUserProfile(testUser))
          .thenAnswer((_) async => Result.success(true));

      // Act
      final result = await repository.updateUserProfile(testUser);

      // Assert
      expect(result.value, true);
      verify(mockDataSource.updateUserProfile(testUser));
      verifyNoMoreInteractions(mockDataSource);
    });

    test('should return a failure from remote data source', () async {
      // Arrange
      when(mockDataSource.updateUserProfile(testUser))
          .thenAnswer((_) async => Result.failure(ServerFailure()));

      // Act
      final result = await repository.updateUserProfile(testUser);

      // Assert
      expect(result.error, ServerFailure());
      verify(mockDataSource.updateUserProfile(testUser));
      verifyNoMoreInteractions(mockDataSource);
    });
  });

  group('updateUsername', () {
    test('should return true from remote data source', () async {
      // Arrange
      when(mockDataSource.updateUsername(testUser.userName))
          .thenAnswer((_) async => Result.success(true));

      // Act
      final result = await repository.updateUsername(testUser.userName);

      // Assert
      expect(result.value, true);
      verify(mockDataSource.updateUsername(testUser.userName));
      verifyNoMoreInteractions(mockDataSource);
    });

    test('should return a failure from remote data source', () async {
      // Arrange
      when(mockDataSource.updateUsername(testUser.userName))
          .thenAnswer((_) async => Result.failure(ServerFailure()));

      // Act
      final result = await repository.updateUsername(testUser.userName);

      // Assert
      expect(result.error, ServerFailure());
      verify(mockDataSource.updateUsername(testUser.userName));
      verifyNoMoreInteractions(mockDataSource);
    });
  });

  group('checkUsername', () {
    test('should return true from remote data source', () async {
      // Arrange
      when(mockDataSource.checkUsername(testUser.userName))
          .thenAnswer((_) async => Result.success(true));

      // Act
      final result = await repository.checkUsername(testUser.userName);

      // Assert
      expect(result.value, true);
      verify(mockDataSource.checkUsername(testUser.userName));
      verifyNoMoreInteractions(mockDataSource);
    });

    test('should return false from remote data source', () async {
      // Arrange
      when(mockDataSource.checkUsername(testUser.userName))
          .thenAnswer((_) async => Result.failure(ServerFailure()));

      // Act
      final result = await repository.checkUsername(testUser.userName);

      // Assert
      expect(result.error, ServerFailure());
      verify(mockDataSource.checkUsername(testUser.userName));
      verifyNoMoreInteractions(mockDataSource);
    });

    test('should return null from remote data source', () async {
      // Arrange
      when(mockDataSource.checkUsername(testUser.userName))
          .thenAnswer((_) async => Result.failure(ServerFailure()));

      // Act
      final result = await repository.checkUsername(testUser.userName);

      // Assert
      expect(result.error, ServerFailure());
      verify(mockDataSource.checkUsername(testUser.userName));
      verifyNoMoreInteractions(mockDataSource);
    });
  });

  group('getPresignedUrl', () {
    test('should return presigned URL from remote data source', () async {
      // Arrange
      const testUrl = 'https://example.com/presigned-url';
      when(mockDataSource.getPresignedUrl())
          .thenAnswer((_) async => Result.success(testUrl));

      // Act
      final result = await repository.getPresignedUrl();

      // Assert
      expect(result.value, testUrl);
      verify(mockDataSource.getPresignedUrl());
      verifyNoMoreInteractions(mockDataSource);
    });

    test('should return a failure from remote data source', () async {
      // Arrange
      when(mockDataSource.getPresignedUrl()).thenAnswer(
        (realInvocation) async => Result.failure(ServerFailure()),
      );

      // Act
      final result = await repository.getPresignedUrl();

      // Assert
      expect(result.error, ServerFailure());
      verify(mockDataSource.getPresignedUrl());
      verifyNoMoreInteractions(mockDataSource);
    });
  });

  group('uploadImageToS3', () {
    const testUploadUrl = 'https://example.com/upload';
    final testImage = Uint8List(69);
    const testImageUrl = 'https://example.com/image.png';

    test('should return the uploaded image URL', () async {
      // Arrange
      when(
        mockDataSource.uploadImageToS3(
          uploadUrl: anyNamed('uploadUrl'),
          image: anyNamed('image'),
        ),
      ).thenAnswer((_) async => Result.success(testImageUrl));

      // Act
      final result = await repository.uploadImageToS3(
        uploadUrl: testUploadUrl,
        image: testImage,
      );

      // Assert
      expect(result.value, testImageUrl);
      verify(
        mockDataSource.uploadImageToS3(
          uploadUrl: testUploadUrl,
          image: testImage,
        ),
      );
      verifyNoMoreInteractions(mockDataSource);
    });

    test('should return a failure when upload fails', () async {
      // Arrange
      when(
        mockDataSource.uploadImageToS3(
          uploadUrl: anyNamed('uploadUrl'),
          image: anyNamed('image'),
        ),
      ).thenAnswer((_) async => Result.failure(ServerFailure()));

      // Act
      final result = await repository.uploadImageToS3(
        uploadUrl: testUploadUrl,
        image: testImage,
      );

      // Assert
      expect(result.error, ServerFailure());
      verify(
        mockDataSource.uploadImageToS3(
          uploadUrl: testUploadUrl,
          image: testImage,
        ),
      );
      verifyNoMoreInteractions(mockDataSource);
    });
  });
}
