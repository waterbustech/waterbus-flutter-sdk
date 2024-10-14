import 'package:waterbus_sdk/types/index.dart';

enum ConversationEventEnum { newMemberJoined, newInvitaion }

class ConversationSocketEvent {
  final ConversationEventEnum event;
  final Meeting conversation;
  ConversationSocketEvent({
    required this.event,
    required this.conversation,
  });
}
