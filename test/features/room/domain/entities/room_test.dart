import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';

import 'package:waterbus_sdk/types/externals/enums/index.dart';
import 'package:waterbus_sdk/types/externals/models/index.dart';
import '../../../../constants/sample_file_path.dart';
import '../../../../fixtures/fixture_reader.dart';

// Project imports:

@GenerateNiceMocks([])
void main() {
  group('Room entity', () {
    test(
      'should be a subclass of Room entity',
      () {},
    );

    test('operator ==', () {
      final User userModel = User(
        id: 1,
        userName: 'lambiengcode',
        fullName: 'Kai',
        externalId: '',
      );
      final participant1 = Participant(
        id: 1,
        user: userModel,
      );
      final participant2 = Participant(
        id: 2,
        user: userModel,
      );

      final Room room1 = Room(
        title: 'Room with Kai 1',
        id: 1,
        participants: [participant1],
        code: "1",
      );
      final Room room2 = Room(
        title: 'Room with Kai 2',
        id: 2,
        participants: [participant2],
        code: "2",
      );

      // Act
      final Room room = room1.copyWith();

      // Assert
      expect(room.title == room1.title, true);
      expect(room == room1, true);
      expect(room == room2, false);
    });

    test('copyWith - should return a new instance with the specified changes',
        () {
      // Arrange
      final Map<String, dynamic> roomSampleJson =
          jsonDecode(fixture(roomSample));

      // Act
      final Room room = Room.fromJson(roomSampleJson);
      final Room updatedroom = room.copyWith(
        title: 'Updated Room',
        id: 0,
      );

      // Assert
      expect(updatedroom.title, 'Updated Room');
    });

    test('toString - should return a string representation of the Room', () {
      // Arrange
      final Map<String, dynamic> roomSampleJson =
          jsonDecode(fixture(roomSample));

      // Act
      final Room room = Room.fromJson(roomSampleJson);
      final String roomString = room.toString();

      // Assert
      expect(roomString, contains('Room'));
      expect(roomString, contains(room.title));
    });

    test('hashCode - should return the hash code of the Room', () {
      // Arrange
      final Map<String, dynamic> roomSampleJson =
          jsonDecode(fixture(roomSample));

      // Act
      final Room room = Room.fromJson(roomSampleJson);
      final int hashCode = room.hashCode;

      // Assert
      expect(hashCode, isA<int>());
    });

    test('toMapCreate - should return a map for creating a Room', () {
      // Arrange
      final Room room = Room(title: 'Sample Room');
      const String password = 'sample_password';

      // Act
      final Map<String, dynamic> map = room.toMapCreate(password: password);

      // Assert
      expect(map, isA<Map<String, dynamic>>());
      expect(map['title'], 'Sample Room');
      expect(map['password'], 'sample_password');
    });
  });

  group('fromJson', () {
    test(
      'fromJson - should return a valid model when the JSON',
      () {
        // Arrange
        final Map<String, dynamic> roomSampleJson =
            jsonDecode(fixture(roomSample));

        // Act
        final Room room = Room.fromJson(roomSampleJson);

        // Assert
        expect(room, isNotNull);
      },
    );
  });

  group('fromJson', () {
    test(
      'fromJson - should return a valid model when the JSON',
      () {
        // Arrange
        final String roomSampleJson = fixture(roomSample);

        // Act
        final Room room = Room.fromJson(jsonDecode(roomSampleJson));

        // Assert
        expect(room, isNotNull);
      },
    );

    test(
      'toJson - should return a valid model when the JSON',
      () {
        // Arrange
        final String roomSampleJson = fixture(roomSample);

        // Act
        final Room room = Room.fromJson(jsonDecode(roomSampleJson));

        // Assert
        expect(room.toJson(), isNotNull);
      },
    );
  });

  group('MeetingX', () {
    final user1 = User(id: 1, fullName: '1', userName: '1', externalId: '');
    final user2 = User(id: 2, fullName: '1', userName: '1', externalId: '');
    final user3 = User(id: 3, fullName: '1', userName: '1', externalId: '');

    final participant1 = Participant(user: user1, id: 1);
    final participant2 = Participant(user: user2, id: 2);
    final participant3 = Participant(user: user3, id: 3);

    final fakeParticipants = [participant1, participant2, participant3];
    final fakeMembers = fakeParticipants
        .map(
          (participant) => Member(
            id: participant.id,
            role: RoomRole.attendee,
            user: participant.user!,
          ),
        )
        .toList();

    final roomWithParticipants = Room(
      title: "Room with Kai",
      participants: fakeParticipants,
      members: fakeMembers,
    );

    final roomWithoutParticipants = Room(
      title: "Room with Kai",
    );

    test('should return active users', () {
      expect(
        roomWithParticipants.participants,
        [participant1, participant2, participant3],
      );
    });

    test('should return true for isNoOneElse when no users', () {
      expect(roomWithoutParticipants.isNoOneElse, true);
    });

    test('should return false for isNoOneElse when multiple active users', () {
      expect(roomWithParticipants.isNoOneElse, false);
    });

    test('participantsOnlineTile - should return the appropriate text', () {
      // Test with 1 participant
      final room1Participant = Room(
        title: '1',
        participants: [
          Participant(
            id: 1,
            user: User(
              id: 1,
              fullName: 'Alice',
              userName: 'alice',
              externalId: '',
            ),
          ),
        ],
      );
      expect(
        room1Participant.participantsOnlineTile,
        'Alice is in the room',
      );

      // Test with 2 participants
      final room2Participants = Room(
        title: '1',
        participants: [
          Participant(
            id: 1,
            user: User(
              id: 1,
              fullName: 'Alice',
              userName: 'alice',
              externalId: '',
            ),
          ),
          Participant(
            id: 2,
            user: User(
              id: 1,
              fullName: 'Bob',
              userName: 'bob',
              externalId: '',
            ),
          ),
        ],
      );
      expect(
        room2Participants.participantsOnlineTile,
        'Alice and Bob are in the room',
      );

      // Test with 3 or more participants
      final room3Participants = Room(
        title: '1',
        participants: [
          Participant(
            id: 1,
            user: User(
              id: 1,
              fullName: 'Alice',
              userName: 'alice',
              externalId: '',
            ),
          ),
          Participant(
            id: 2,
            user: User(
              id: 1,
              fullName: 'Bob',
              userName: 'bob',
              externalId: '',
            ),
          ),
          Participant(
            id: 3,
            user: User(
              id: 1,
              fullName: 'Kai',
              userName: 'kai',
              externalId: '',
            ),
          ),
          Participant(
            id: 4,
            user: User(
              id: 1,
              fullName: 'lambiengcode',
              userName: 'lambiengcode',
              externalId: '',
            ),
          ),
        ],
      );
      expect(
        room3Participants.participantsOnlineTile,
        'Alice, Bob and 2 others are in the room',
      );
    });

    group('latestJoinedTime', () {
      final testroom = Room(
        title: '1',
        participants: [
          Participant(
            id: 1,
            user: User(
              id: 1,
              fullName: 'Alice',
              userName: 'alice',
              externalId: '',
            ),
          ),
        ],
      );
      test('latestJoinedAt not null', () {
        final DateTime latestJoinedAt = DateTime.now();
        final Room room = testroom.copyWith(
          latestJoinedAt: latestJoinedAt,
        );

        expect(room.latestJoinedTime, latestJoinedAt);
      });
      test('latestJoinedAt is null, createdAt not null', () {
        final DateTime createdAt = DateTime.now();
        final Room room = testroom.copyWith(
          createdAt: createdAt,
        );

        expect(room.latestJoinedTime, createdAt);
        expect(room.latestJoinedAt, isNull);
      });
      test('latestJoinedAt is null, createdAt is also null', () {
        final Room room = testroom.copyWith();

        expect(room.latestJoinedAt, isNull);
        expect(room.createdAt, isNull);
      });
    });
  });
}
