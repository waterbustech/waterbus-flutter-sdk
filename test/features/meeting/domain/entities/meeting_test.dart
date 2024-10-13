import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';

import 'package:waterbus_sdk/types/enums/meeting_role.dart';
import 'package:waterbus_sdk/types/index.dart';
import '../../../../constants/sample_file_path.dart';
import '../../../../fixtures/fixture_reader.dart';

// Project imports:

@GenerateNiceMocks([])
void main() {
  group('Meeting entity', () {
    test(
      'should be a subclass of Meeting entity',
      () {},
    );

    test('operator ==', () {
      final User userModel = User(
        id: 1,
        userName: 'lambiengcode',
        fullName: 'Kai',
      );
      final participant1 = Participant(
        id: 1,
        user: userModel,
      );
      final participant2 = Participant(
        id: 2,
        user: userModel,
      );

      final Meeting meeting1 = Meeting(
        title: 'Meeting with Kai 1',
        id: 1,
        participants: [participant1],
        code: 1,
      );
      final Meeting meeting2 = Meeting(
        title: 'Meeting with Kai 2',
        id: 2,
        participants: [participant2],
        code: 2,
      );

      // Act
      final Meeting meeting = meeting1.copyWith();

      // Assert
      expect(meeting.title == meeting1.title, true);
      expect(meeting == meeting1, true);
      expect(meeting == meeting2, false);
    });

    test('copyWith - should return a new instance with the specified changes',
        () {
      // Arrange
      final Map<String, dynamic> meetingSampleJson =
          jsonDecode(fixture(meetingSample));

      // Act
      final Meeting meeting = Meeting.fromMap(meetingSampleJson);
      final Meeting updatedMeeting = meeting.copyWith(
        title: 'Updated Meeting',
        id: 0,
      );

      // Assert
      expect(updatedMeeting.title, 'Updated Meeting');
    });

    test('toString - should return a string representation of the Meeting', () {
      // Arrange
      final Map<String, dynamic> meetingSampleJson =
          jsonDecode(fixture(meetingSample));

      // Act
      final Meeting meeting = Meeting.fromMap(meetingSampleJson);
      final String meetingString = meeting.toString();

      // Assert
      expect(meetingString, contains('Meeting'));
      expect(meetingString, contains(meeting.title));
    });

    test('hashCode - should return the hash code of the Meeting', () {
      // Arrange
      final Map<String, dynamic> meetingSampleJson =
          jsonDecode(fixture(meetingSample));

      // Act
      final Meeting meeting = Meeting.fromMap(meetingSampleJson);
      final int hashCode = meeting.hashCode;

      // Assert
      expect(hashCode, isA<int>());
    });

    test('toMapCreate - should return a map for creating a Meeting', () {
      // Arrange
      final Meeting meeting = Meeting(title: 'Sample Meeting');
      const String password = 'sample_password';

      // Act
      final Map<String, dynamic> map = meeting.toMapCreate(password);

      // Assert
      expect(map, isA<Map<String, dynamic>>());
      expect(map['title'], 'Sample Meeting');
      expect(map['password'], 'sample_password');
    });
  });

  group('fromMap', () {
    test(
      'fromMap - should return a valid model when the JSON',
      () {
        // Arrange
        final Map<String, dynamic> meetingSampleJson =
            jsonDecode(fixture(meetingSample));

        // Act
        final Meeting meeting = Meeting.fromMap(meetingSampleJson);

        // Assert
        expect(meeting, isNotNull);
      },
    );
  });

  group('fromJson', () {
    test(
      'fromJson - should return a valid model when the JSON',
      () {
        // Arrange
        final String meetingSampleJson = fixture(meetingSample);

        // Act
        final Meeting meeting = Meeting.fromJson(meetingSampleJson);

        // Assert
        expect(meeting, isNotNull);
      },
    );

    test(
      'toJson - should return a valid model when the JSON',
      () {
        // Arrange
        final String meetingSampleJson = fixture(meetingSample);

        // Act
        final Meeting meeting = Meeting.fromJson(meetingSampleJson);

        // Assert
        expect(meeting.toJson(), isNotNull);
      },
    );
  });

  group('MeetingX', () {
    final user1 = User(id: 1, fullName: '1', userName: '1');
    final user2 = User(id: 2, fullName: '1', userName: '1');
    final user3 = User(id: 3, fullName: '1', userName: '1');

    final participant1 = Participant(user: user1, id: 1);
    final participant2 = Participant(user: user2, id: 2);
    final participant3 = Participant(user: user3, id: 3);

    final fakeParticipants = [participant1, participant2, participant3];
    final fakeMembers = fakeParticipants
        .map(
          (participant) => Member(
            id: participant.id,
            role: MeetingRole.attendee,
            user: participant.user!,
          ),
        )
        .toList();

    final meetingWithParticipants = Meeting(
      title: "Meeting with Kai",
      participants: fakeParticipants,
      members: fakeMembers,
    );

    final meetingWithoutParticipants = Meeting(
      title: "Meeting with Kai",
    );

    test('should return active users', () {
      expect(
        meetingWithParticipants.participants,
        [participant1, participant2, participant3],
      );
    });

    test('should return true for isNoOneElse when no users', () {
      expect(meetingWithoutParticipants.isNoOneElse, true);
    });

    test('should return false for isNoOneElse when multiple active users', () {
      expect(meetingWithParticipants.isNoOneElse, false);
    });

    test('inviteLink - should return the invite link', () {
      final meeting = Meeting(code: 123, title: '1');
      expect(meeting.inviteLink, 'https:/waterbus.tech/meeting/123');
    });

    test('participantsOnlineTile - should return the appropriate text', () {
      // Test with 1 participant
      final meeting1Participant = Meeting(
        title: '1',
        participants: [
          Participant(
            id: 1,
            user: User(
              id: 1,
              fullName: 'Alice',
              userName: 'alice',
            ),
          ),
        ],
      );
      expect(
        meeting1Participant.participantsOnlineTile,
        'Alice is in the room',
      );

      // Test with 2 participants
      final meeting2Participants = Meeting(
        title: '1',
        participants: [
          Participant(
            id: 1,
            user: User(
              id: 1,
              fullName: 'Alice',
              userName: 'alice',
            ),
          ),
          Participant(
            id: 2,
            user: User(
              id: 1,
              fullName: 'Bob',
              userName: 'bob',
            ),
          ),
        ],
      );
      expect(
        meeting2Participants.participantsOnlineTile,
        'Alice and Bob are in the room',
      );

      // Test with 3 or more participants
      final meeting3Participants = Meeting(
        title: '1',
        participants: [
          Participant(
            id: 1,
            user: User(
              id: 1,
              fullName: 'Alice',
              userName: 'alice',
            ),
          ),
          Participant(
            id: 2,
            user: User(
              id: 1,
              fullName: 'Bob',
              userName: 'bob',
            ),
          ),
          Participant(
            id: 3,
            user: User(
              id: 1,
              fullName: 'Kai',
              userName: 'kai',
            ),
          ),
          Participant(
            id: 4,
            user: User(
              id: 1,
              fullName: 'lambiengcode',
              userName: 'lambiengcode',
            ),
          ),
        ],
      );
      expect(
        meeting3Participants.participantsOnlineTile,
        'Alice, Bob and 2 others are in the room',
      );
    });

    group('latestJoinedTime', () {
      final testMeeting = Meeting(
        title: '1',
        participants: [
          Participant(
            id: 1,
            user: User(
              id: 1,
              fullName: 'Alice',
              userName: 'alice',
            ),
          ),
        ],
      );
      test('latestJoinedAt not null', () {
        final DateTime latestJoinedAt = DateTime.now();
        final Meeting meeting = testMeeting.copyWith(
          latestJoinedAt: latestJoinedAt,
        );

        expect(meeting.latestJoinedTime, latestJoinedAt);
      });
      test('latestJoinedAt is null, createdAt not null', () {
        final DateTime createdAt = DateTime.now();
        final Meeting meeting = testMeeting.copyWith(
          createdAt: createdAt,
        );

        expect(meeting.latestJoinedTime, createdAt);
        expect(meeting.latestJoinedAt, isNull);
      });
      test('latestJoinedAt is null, createdAt is also null', () {
        final Meeting meeting = testMeeting.copyWith();

        expect(meeting.latestJoinedAt, isNull);
        expect(meeting.createdAt, isNull);
      });
    });
  });
}
