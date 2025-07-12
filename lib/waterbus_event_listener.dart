import 'package:waterbus_sdk/types/index.dart';
import 'package:waterbus_sdk/types/internals/models/stats.dart';

class WaterbusEventListener {
  final Function(CallbackPayload)? onEventChanged;
  final Function(VideoSenderStats)? onStatsChanged;
  final Function(Subtitle)? onSubtitle;
  final Function(MessageSocketEvent)? onMesssageChanged;

  WaterbusEventListener({
    this.onEventChanged,
    this.onStatsChanged,
    this.onSubtitle,
    this.onMesssageChanged,
  });

  WaterbusEventListener copyWith({
    Function(CallbackPayload)? onEventChanged,
    Function(VideoSenderStats)? onStatsChanged,
    Function(Subtitle)? onSubtitle,
    Function(MessageSocketEvent)? onMesssageChanged,
  }) {
    return WaterbusEventListener(
      onEventChanged: onEventChanged ?? this.onEventChanged,
      onStatsChanged: onStatsChanged ?? this.onStatsChanged,
      onSubtitle: onSubtitle ?? this.onSubtitle,
      onMesssageChanged: onMesssageChanged ?? this.onMesssageChanged,
    );
  }
}
