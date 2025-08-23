import 'dart:convert';
import 'dart:typed_data';

// Dart models matching your Rust structs
abstract class ChannelEvent {
  const ChannelEvent();

  static ChannelEvent fromJson(Map<String, dynamic> json) {
    // Handle the enum serialization format from Rust serde
    if (json.containsKey('ScreenSharingTrackStarted')) {
      return ScreenSharingTrackStarted.fromJson(
        json['ScreenSharingTrackStarted'],
      );
    } else if (json.containsKey('ScreenSharingTrackStopped')) {
      return ScreenSharingTrackStopped.fromJson(
        json['ScreenSharingTrackStopped'],
      );
    } else if (json.containsKey('VideoEnabled')) {
      return VideoEnabled.fromJson(json['VideoEnabled']);
    } else if (json.containsKey('AudioEnabled')) {
      return AudioEnabled.fromJson(json['AudioEnabled']);
    } else if (json.containsKey('HandRaising')) {
      return HandRaising.fromJson(json['HandRaising']);
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

  const Renegotitate({required this.sdp});

  @override
  String get eventType => 'Renegotitate';

  @override
  Map<String, dynamic> toJson() {
    return {
      'Renegotitate': {
        'sdp': sdp,
      },
    };
  }
}

class ScreenSharingTrackStarted extends ChannelEvent {
  final String mid;
  final String sdp;

  const ScreenSharingTrackStarted({
    required this.mid,
    required this.sdp,
  });

  factory ScreenSharingTrackStarted.fromJson(Map<String, dynamic> json) {
    return ScreenSharingTrackStarted(
      mid: json['mid'] as String,
      sdp: json['sdp'] as String,
    );
  }

  @override
  String get eventType => 'ScreenSharingTrackStarted';

  @override
  Map<String, dynamic> toJson() {
    return {
      'ScreenSharingTrackStarted': {
        'mid': mid,
        'sdp': sdp,
      },
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ScreenSharingTrackStarted &&
          mid == other.mid &&
          sdp == other.sdp;

  @override
  int get hashCode => mid.hashCode ^ sdp.hashCode;

  @override
  String toString() =>
      'ScreenSharingTrackStarted(mid: $mid, sdp: ${sdp.length} chars)';
}

class ScreenSharingTrackStopped extends ChannelEvent {
  final String mid;

  const ScreenSharingTrackStopped({required this.mid});

  factory ScreenSharingTrackStopped.fromJson(Map<String, dynamic> json) {
    return ScreenSharingTrackStopped(
      mid: json['mid'] as String,
    );
  }

  @override
  String get eventType => 'ScreenSharingTrackStopped';

  @override
  Map<String, dynamic> toJson() {
    return {
      'ScreenSharingTrackStopped': {
        'mid': mid,
      },
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ScreenSharingTrackStopped && mid == other.mid;

  @override
  int get hashCode => mid.hashCode;

  @override
  String toString() => 'ScreenSharingTrackStopped(mid: $mid)';
}

class VideoEnabled extends ChannelEvent {
  final bool isEnabled;

  const VideoEnabled({required this.isEnabled});

  factory VideoEnabled.fromJson(Map<String, dynamic> json) {
    return VideoEnabled(
      isEnabled: json['is_enabled'] as bool,
    );
  }

  @override
  String get eventType => 'VideoEnabled';

  @override
  Map<String, dynamic> toJson() {
    return {
      'VideoEnabled': {
        'is_enabled': isEnabled,
      },
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VideoEnabled && isEnabled == other.isEnabled;

  @override
  int get hashCode => isEnabled.hashCode;

  @override
  String toString() => 'VideoEnabled(isEnabled: $isEnabled)';
}

class AudioEnabled extends ChannelEvent {
  final bool isEnabled;

  const AudioEnabled({required this.isEnabled});

  factory AudioEnabled.fromJson(Map<String, dynamic> json) {
    return AudioEnabled(
      isEnabled: json['is_enabled'] as bool,
    );
  }

  @override
  String get eventType => 'AudioEnabled';

  @override
  Map<String, dynamic> toJson() {
    return {
      'AudioEnabled': {
        'is_enabled': isEnabled,
      },
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AudioEnabled && isEnabled == other.isEnabled;

  @override
  int get hashCode => isEnabled.hashCode;

  @override
  String toString() => 'AudioEnabled(isEnabled: $isEnabled)';
}

class HandRaising extends ChannelEvent {
  final bool isEnabled;

  const HandRaising({required this.isEnabled});

  factory HandRaising.fromJson(Map<String, dynamic> json) {
    return HandRaising(
      isEnabled: json['is_enabled'] as bool,
    );
  }

  @override
  String get eventType => 'HandRaising';

  @override
  Map<String, dynamic> toJson() {
    return {
      'HandRaising': {
        'is_enabled': isEnabled,
      },
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HandRaising && isEnabled == other.isEnabled;

  @override
  int get hashCode => isEnabled.hashCode;

  @override
  String toString() => 'HandRaising(isEnabled: $isEnabled)';
}
