import 'package:waterbus_sdk/types/externals/models/index.dart';

enum MessageEventEnum { create, update, delete }

class MessageSocketEvent {
  final MessageEventEnum event;
  final MessageModel message;
  MessageSocketEvent({
    required this.event,
    required this.message,
  });
}
