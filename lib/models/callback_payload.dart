// Project imports:
import 'package:waterbus/models/index.dart';

class CallbackPayload {
  CallbackEvents event;
  CallState callState;
  CallbackPayload({
    required this.event,
    required this.callState,
  });

  CallbackPayload copyWith({
    CallbackEvents? event,
    CallState? callState,
  }) {
    return CallbackPayload(
      event: event ?? this.event,
      callState: callState ?? this.callState,
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
