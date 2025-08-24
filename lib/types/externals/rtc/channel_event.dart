import 'dart:convert';
import 'dart:typed_data';

import 'package:waterbus_sdk/types/internals/rtc/track_quality.dart';

// Dart models matching your Rust structs
abstract class ChannelEvent {
  const ChannelEvent();

  static ChannelEvent fromJson(Map<String, dynamic> json) {
    // Handle the enum serialization format from Rust serde
    if (json.containsKey('Renegotitate')) {
      return Renegotitate.fromJson(json['Renegotitate']);
    } else if (json.containsKey('RidSubscription')) {
      return RidSubscription.fromJson(json['RidSubscription']);
    } else {
      throw ArgumentError(
        'Unknown event type in JSON: ${json.keys.join(", ")}',
      );
    }
  }

  static ChannelEvent fromBinary(Uint8List data) {
    final jsonString = utf8.decode(data);
    final jsonMap = jsonDecode(jsonString) as Map<String, dynamic>;
    return fromJson(jsonMap);
  }

  String get eventType;
  Map<String, dynamic> toJson();

  Uint8List toBinary() {
    final jsonString = jsonEncode(toJson());
    return Uint8List.fromList(utf8.encode(jsonString));
  }
}

class Renegotitate extends ChannelEvent {
  final String sdp;
  final String? mid;

  const Renegotitate({required this.sdp, this.mid});

  factory Renegotitate.fromJson(Map<String, dynamic> json) {
    return Renegotitate(
      sdp: json['sdp'] as String,
      mid: json['mid'] as String?,
    );
  }

  @override
  String get eventType => 'Renegotitate';

  @override
  Map<String, dynamic> toJson() {
    return {
      'Renegotitate': {
        'sdp': sdp,
        'mid': mid,
      },
    };
  }
}

class SubscriberTrackQuality extends ChannelEvent {
  final String mid;
  final TrackQuality quality;

  const SubscriberTrackQuality({required this.mid, required this.quality});

  factory SubscriberTrackQuality.fromJson(Map<String, dynamic> json) {
    return SubscriberTrackQuality(
      mid: json['mid'] as String,
      quality: TrackQuality.values[json['quality'] as int],
    );
  }

  @override
  String get eventType => 'SubscriberTrackQuality';

  @override
  Map<String, dynamic> toJson() {
    return {
      'SubscriberTrackQuality': {
        'mid': mid,
        'quality': quality.index,
      },
    };
  }
}

class RidSubscription extends ChannelEvent {
  final String rid;
  final String mid;
  final bool enabled;

  const RidSubscription({
    required this.rid,
    required this.mid,
    required this.enabled,
  });

  factory RidSubscription.fromJson(Map<String, dynamic> json) {
    return RidSubscription(
      rid: json['rid'] as String,
      mid: json['mid'] as String,
      enabled: json['enabled'] as bool,
    );
  }

  @override
  String get eventType => 'RidSubscription';

  @override
  Map<String, dynamic> toJson() {
    return {
      'RidSubscription': {
        'rid': rid,
        'mid': mid,
        'enabled': enabled,
      },
    };
  }
}
