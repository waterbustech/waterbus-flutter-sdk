import 'package:waterbus_sdk/types/index.dart';

enum ConversationEventEnum { newMemberJoined, newInvitaion }

class ConversationSocketEvent {
  final ConversationEventEnum event;
  final Meeting? conversation;
  final Member? member;
  ConversationSocketEvent({
    required this.event,
    this.conversation,
    this.member,
  });
}
