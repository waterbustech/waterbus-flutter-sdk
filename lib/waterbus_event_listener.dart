import 'package:waterbus_sdk/types/models/callback_payload.dart';
import 'package:waterbus_sdk/types/models/conversation_socket_event.dart';
import 'package:waterbus_sdk/types/models/message_socket_event.dart';
import 'package:waterbus_sdk/types/models/stats.dart';
import 'package:waterbus_sdk/types/models/subtitle.dart';

class WaterBusEventListener {
  final Function(CallbackPayload)? onEventChanged;
  final Function(VideoSenderStats)? onStatsChanged;
  final Function(Subtitle)? onSubtitle;
  final Function(MessageSocketEvent)? onMesssageChanged;
  final Function(ConversationSocketEvent)? onConversationChanged;

  WaterBusEventListener({
    this.onEventChanged,
    this.onStatsChanged,
    this.onSubtitle,
    this.onMesssageChanged,
    this.onConversationChanged,
  });

  WaterBusEventListener copyWith({
    Function(CallbackPayload)? onEventChanged,
    Function(VideoSenderStats)? onStatsChanged,
    Function(Subtitle)? onSubtitle,
    Function(MessageSocketEvent)? onMesssageChanged,
    Function(ConversationSocketEvent)? onConversationChanged,
  }) {
    return WaterBusEventListener(
      onEventChanged: onEventChanged ?? this.onEventChanged,
      onStatsChanged: onStatsChanged ?? this.onStatsChanged,
      onSubtitle: onSubtitle ?? this.onSubtitle,
      onMesssageChanged: onMesssageChanged ?? this.onMesssageChanged,
      onConversationChanged:
          onConversationChanged ?? this.onConversationChanged,
    );
  }
}
