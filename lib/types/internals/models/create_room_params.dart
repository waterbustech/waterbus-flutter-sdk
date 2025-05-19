import 'package:waterbus_sdk/types/externals/models/index.dart';

class RoomParams {
  final Room room;
  final String password;
  final int? userId;

  const RoomParams({
    required this.room,
    required this.password,
    this.userId,
  });
}
