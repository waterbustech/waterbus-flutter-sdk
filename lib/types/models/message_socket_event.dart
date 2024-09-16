import 'package:waterbus_sdk/types/index.dart';

enum MessageEventEnum { create, update, delete }

class MessageSocketEvent {
  final MessageEventEnum event;
  final MessageModel message;
  MessageSocketEvent({
    required this.event,
    required this.message,
  });
}
