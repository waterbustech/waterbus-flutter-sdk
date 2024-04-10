// Project imports:
import 'package:waterbus_sdk/models/index.dart';

class CallbackPayload {
  CallbackEvents event;
  CallState callState;
  String? participantId;
  NewParticipant? newParticipant;
  CallbackPayload({
    required this.event,
    required this.callState,
    this.participantId,
    this.newParticipant,
  });

  CallbackPayload copyWith({
    CallbackEvents? event,
    CallState? callState,
    String? participantId,
  }) {
    return CallbackPayload(
      event: event ?? this.event,
      callState: callState ?? this.callState,
      participantId: participantId ?? this.participantId,
    );
  }

  @override
  String toString() => 'CallbackPayload(event: $event, callState: $callState)';

  @override
  bool operator ==(covariant CallbackPayload other) {
    if (identical(this, other)) return true;

    return other.event == event && other.callState == callState;
  }

  @override
  int get hashCode => event.hashCode ^ callState.hashCode;
}
