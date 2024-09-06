enum MessageEventEnum { create, update, delete }

class MessageSocketEvent {
  final MessageEventEnum event;
  final Map<String, dynamic> data;
  MessageSocketEvent({
    required this.event,
    required this.data,
  });
}
