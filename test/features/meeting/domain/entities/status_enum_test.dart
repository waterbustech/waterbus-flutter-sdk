import 'package:flutter_test/flutter_test.dart';

import 'package:waterbus_sdk/types/externals/enums/index.dart';

void main() {
  group('StatusEnum tests', () {
    test('StatusEnum.fromValue returns correct enum value', () {
      const inviting = 0;
      const invisibleValue = 1;
      const joinedValue = 2;

      expect(
        MemberStatusEnum.fromValue(inviting),
        equals(MemberStatusEnum.inviting),
      );
      expect(
        MemberStatusEnum.fromValue(invisibleValue),
        equals(
          MemberStatusEnum.invisible,
        ),
      );
      expect(
        MemberStatusEnum.fromValue(joinedValue),
        equals(MemberStatusEnum.joined),
      );
    });

    test('StatusEnum.fromValue throws exception for unknown value', () {
      const unknownValue = 3;

      expect(() => MemberStatusEnum.fromValue(unknownValue), throwsException);
    });
  });
}
