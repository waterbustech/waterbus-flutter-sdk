import 'package:waterbus_sdk/types/externals/index.dart';

class RoomParams {
  final Room room;
  final String? password;
  final int? userId;

  const RoomParams({
    required this.room,
    this.password,
    this.userId,
  });
}
