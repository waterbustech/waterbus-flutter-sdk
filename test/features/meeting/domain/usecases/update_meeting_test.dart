// Package imports:
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

// Project imports:
import 'package:waterbus_sdk/core/api/meetings/usecases/index.dart';
import 'package:waterbus_sdk/types/error/failures.dart';
import 'package:waterbus_sdk/types/index.dart';
import 'create_meeting_test.mocks.dart';

void main() {
  late UpdateMeeting usecase;
  late MockMeetingRepository mockRepository;

  setUp(() {
    mockRepository = MockMeetingRepository();
    usecase = UpdateMeeting(mockRepository);
  });

  const testMeeting = Meeting(title: 'Meeting with Kai');
  const testPassword = 'KaiDao';
  const createMeetingParams = CreateMeetingParams(
    meeting: testMeeting,
    password: testPassword,
  );

  test('should update a meeting for the given parameters', () async {
    // Arrange
    when(mockRepository.updateMeeting(any))
        .thenAnswer((_) async => const Right(testMeeting));

    // Act
    final result = await usecase(createMeetingParams);

    // Assert
    expect(result, const Right(testMeeting));
    verify(mockRepository.updateMeeting(createMeetingParams));
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return a Failure when the repository call fails', () async {
    // Arrange
    when(mockRepository.updateMeeting(any))
        .thenAnswer((_) async => Left(ServerFailure()));

    // Act
    final result = await usecase(createMeetingParams);

    // Assert
    expect(result, Left(ServerFailure()));
    verify(mockRepository.updateMeeting(createMeetingParams));
    verifyNoMoreInteractions(mockRepository);
  });
}
