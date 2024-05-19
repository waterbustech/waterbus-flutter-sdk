// Package imports:
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

// Project imports:
import 'package:waterbus_sdk/core/api/base/usecase.dart';
import 'package:waterbus_sdk/core/api/user/repositories/user_repository.dart';
import 'package:waterbus_sdk/core/api/user/usecases/index.dart';
import 'package:waterbus_sdk/types/error/failures.dart';
import 'get_presigned_url_test.mocks.dart';

@GenerateNiceMocks([MockSpec<UserRepository>()])
void main() {
  late GetPresignedUrl usecase;
  late MockUserRepository mockUserRepository;

  setUp(() {
    mockUserRepository = MockUserRepository();
    usecase = GetPresignedUrl(mockUserRepository);
  });

  test('should call getPresignedUrl method from the repository', () async {
    // Arrange
    when(mockUserRepository.getPresignedUrl()).thenAnswer(
      (_) async => const Right('https://example.com/presigned-url'),
    );

    // Act
    final result = await usecase(NoParams());

    // Assert
    expect(result, const Right('https://example.com/presigned-url'));
    verify(mockUserRepository.getPresignedUrl());
    verifyNoMoreInteractions(mockUserRepository);
  });

  test(
      'should return a failure when getPresignedUrl method from the repository fails',
      () async {
    // Arrange
    when(mockUserRepository.getPresignedUrl())
        .thenAnswer((_) async => Left(ServerFailure()));

    // Act
    final result = await usecase(NoParams());

    // Assert
    expect(result, Left(ServerFailure()));
    verify(mockUserRepository.getPresignedUrl());
    verifyNoMoreInteractions(mockUserRepository);
  });
}
