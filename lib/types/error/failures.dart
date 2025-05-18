import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String? message;

  const Failure([this.message]);

  @override
  List<Object> get props => [];
}

// General failures
class ServerFailure extends Failure {}

class CacheFailure extends Failure {}

class NullValue extends Failure {}

// Room
class RoomNotFound extends Failure {}

class NotAllowedToUpdateRoom extends Failure {}

class WrongPassword extends Failure {}

class NotAllowToJoinDirectly extends Failure {}

class NotExistsParticipant extends Failure {}

class NotExistsCCU extends Failure {}

class IsAlreadyInRoom extends Failure {}

class HostNotFound extends Failure {}

class NotAllowToAddUser extends Failure {}

class HasNotJoinedMeeting extends Failure {}

class MemberNotFound extends Failure {}

class ParticipantNotFound extends Failure {}

class OnlyAllowHostStartRecord extends Failure {}

class OnlyAllowHostStopRecord extends Failure {}

class NotAllowedToLeaveTheRoom extends Failure {}

class OnlyHostPermitedToArchivedTheRoom extends Failure {}

// User

class UserNotFound extends Failure {}

class UserIsAlreadyUsed extends Failure {}

// Message

class NotAllowedGetMessages extends Failure {}

class NotAllowedModifyMessage extends Failure {}

class MessageNotFound extends Failure {}

class MessageHasBeenDelete extends Failure {}
