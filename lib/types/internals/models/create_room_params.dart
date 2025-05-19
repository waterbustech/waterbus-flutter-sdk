import 'package:waterbus_sdk/types/externals/models/index.dart';

class CreateRoomParams {
  final Room room;
  final String password;
  final int? userId;

  const CreateRoomParams({
    required this.room,
    required this.password,
    this.userId,
  });
}
