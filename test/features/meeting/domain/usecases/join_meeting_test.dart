// Package imports:
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

// Project imports:
import 'package:waterbus_sdk/core/api/meetings/usecases/index.dart';
import 'package:waterbus_sdk/types/index.dart';
import 'create_meeting_test.mocks.dart';

void main() {
  late JoinMeeting joinMeeting;
  late MockMeetingRepository mockRepository;

  setUp(() {
    mockRepository = MockMeetingRepository();
    joinMeeting = JoinMeeting(mockRepository);
  });

  const testMeeting = Meeting(title: 'Test Meeting');
  const testPassword = 'TestPassword';
  const createMeetingParams = CreateMeetingParams(
    meeting: testMeeting,
    password: testPassword,
  );

  test('should call joinMeeting on the repository with the given parameters',
      () async {
    // Arrange
    when(mockRepository.joinMeetingWithPassword(createMeetingParams))
        .thenAnswer((_) async => const Right(testMeeting));

    // Act
    final result = await joinMeeting(createMeetingParams);

    // Assert
    expect(result, const Right(testMeeting));
    verify(mockRepository.joinMeetingWithPassword(createMeetingParams));
    verifyNoMoreInteractions(mockRepository);
  });
}
