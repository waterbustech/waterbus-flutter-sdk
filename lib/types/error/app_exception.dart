import 'package:collection/collection.dart';

import 'package:waterbus_sdk/types/error/failures.dart';

enum AppException {
  // Room
  roomNotFound("Room with Code ", RoomNotFound.new),
  notAllowedToUpdateRoom(
    'User not allowed to update rooom',
    NotAllowedToUpdateRoom.new,
  ),
  wrongPassword('Password is not correct', WrongPassword.new),
  notAllowToJoinDirectly(
    'User not allow to join directly',
    NotAllowToJoinDirectly.new,
  ),
  notExistsParticipant('Not exists participant', NotExistsParticipant.new),
  notExistsCCU('Not exists CCU', NotExistsCCU.new),
  isAlreadyInRoom('User already in room', IsAlreadyInRoom.new),
  hostNotFound('Host not found', HostNotFound.new),
  notAllowToAddUser('You not allow to add user', NotAllowToAddUser.new),
  memberNotFound('Member Not Found', MemberNotFound.new),
  participantNotFound('Participant Not Found', ParticipantNotFound.new),
  notAllowedToLeaveTheRoom(
    'Host not allowed to leave the room. You can archive chats if the room no longer active.',
    NotAllowedToLeaveTheRoom.new,
  ),
  onlyHostPermitedToArchivedTheRoom(
    'Only Host permited to archived the room.',
    OnlyHostPermitedToArchivedTheRoom.new,
  ),

  // User
  userNotFound("User not found", UserNotFound.new),

  // Message
  messageHasBeenDelete("Message has been deleted", MessageHasBeenDelete.new),
  messageNotFound("Message not found", MessageNotFound.new),
  notAllowedModifyMessage(
    "You not allowed modify message of other users",
    NotAllowedModifyMessage.new,
  ),
  notAllowedGetMessages(
    "You not allowed get messages from room that you not stay in there",
    NotAllowedGetMessages.new,
  ),
  ;

  const AppException(this.message, this.failureFactory);

  final String message;
  final Failure Function() failureFactory;

  Failure get failure => failureFactory();
}

extension AppExceptionX on String {
  Failure get toFailure {
    final match = AppException.values.firstWhereOrNull(
      (e) => contains(e.message),
    );

    return match?.failure ?? ServerFailure();
  }
}
