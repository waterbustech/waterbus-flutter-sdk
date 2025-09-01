import 'package:flutter_test/flutter_test.dart';

import 'package:waterbus_sdk/types/externals/room/room_role.dart';

void main() {
  group('RoomRole', () {
    test('Should return correct integer value for host', () {
      const role = RoomRole.onwer;
      expect(role.value, 0);
    });

    test('Should return correct integer value for attendee', () {
      const role = RoomRole.attendee;
      expect(role.value, 1);
    });

    test('Should return correct RoomRole for integer value 0', () {
      final role = RoomRoleX.fromValue(0);
      expect(role, RoomRole.onwer);
    });

    test('Should return correct RoomRole for integer value 1', () {
      final role = RoomRoleX.fromValue(1);
      expect(role, RoomRole.attendee);
    });

    test('Should throw an exception for unknown integer value', () {
      expect(() => RoomRoleX.fromValue(2), throwsA(isA<Exception>()));
    });
  });
}
