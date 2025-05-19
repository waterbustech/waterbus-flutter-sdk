import 'package:waterbus_sdk/types/externals/models/index.dart';

enum ConversationEventEnum { newMemberJoined, newInvitaion }

class ConversationSocketEvent {
  final ConversationEventEnum event;
  final Room? conversation;
  final Member? member;
  ConversationSocketEvent({
    required this.event,
    this.conversation,
    this.member,
  });
}
