import 'package:waterbus_sdk/types/externals/participant/member.dart';
import 'package:waterbus_sdk/types/externals/room/room.dart';

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
