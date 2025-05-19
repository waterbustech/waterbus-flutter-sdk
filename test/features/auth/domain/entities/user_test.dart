import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

import 'package:waterbus_sdk/types/externals/models/index.dart';
import '../../../../constants/sample_file_path.dart';
import '../../../../fixtures/fixture_reader.dart';

void main() {
  group('user entity', () {
    test(
      'should be a subclass of User entity',
      () {},
    );
    test('operator ==', () {
      final User userModel1 = User(
        id: 1,
        userName: "lambiengcode",
        fullName: "Kai Dao",
        bio: "bio1",
        externalId: '',
      );
      final User userModel2 = User(
        id: 2,
        userName: "lambiengcode",
        fullName: "Kai Dao",
        bio: "bio2",
        externalId: '',
      );

      // arrange
      final Map<String, dynamic> userJson = jsonDecode(
        fixture(userSample),
      );

      // act
      final User user = User.fromJson(userJson);

      expect(user == userModel1, true);
      expect(user == userModel2, false);
      expect(user.toString(), userModel1.toString());
      expect(user.hashCode, user.copyWith().hashCode);
    });
  });

  group('copyWith', () {
    test('should return new value', () {
      // arrange
      final Map<String, dynamic> userJson = jsonDecode(
        fixture(userSample),
      );

      // act
      final User user = User.fromJson(userJson);

      final User userClone = user.copyWith(
        userName: "lambiengcode1",
        fullName: "Kai",
      );
      // assert
      expect(userClone.userName, "lambiengcode1");
      expect(userClone.fullName, "Kai");
      expect(userClone.userName != user.userName, true);
      expect(userClone.fullName != user.fullName, true);
    });
  });

  group('fromJson', () {
    test(
      'fromJson - should return a valid model when the JSON',
      () {
        // arrange
        final Map<String, dynamic> userJson = jsonDecode(
          fixture(userSample),
        );

        // act
        final User user = User.fromJson(userJson);

        final User userClone = user.copyWith(
          userName: "lambiengcode1",
          fullName: "Kai",
        );

        // assert
        expect(userClone, isNotNull);
      },
    );
  });

  group('fromJson', () {
    test(
      'fromJson - should return a valid model when the JSON',
      () {
        // arrange
        final String userJson = fixture(userSample);

        // act
        final User user = User.fromJson(json.decode(userJson));

        // assert
        expect(user, isNotNull);
      },
    );

    test(
      'toJson - should return a valid model when the JSON',
      () {
        // arrange
        final Map<String, dynamic> userJson = jsonDecode(
          fixture(userSample),
        );

        // act
        final User user = User.fromJson(userJson);

        // assert
        expect(user.toJson(), isNotNull);
      },
    );
  });
}
