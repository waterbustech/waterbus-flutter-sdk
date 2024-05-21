import 'package:waterbus_sdk/types/index.dart';

class CreateMeetingParams {
  final Meeting meeting;
  final String password;
  final int? userId;

  const CreateMeetingParams({
    required this.meeting,
    required this.password,
    this.userId,
  });
}
