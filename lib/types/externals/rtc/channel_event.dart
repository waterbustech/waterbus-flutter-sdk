import 'dart:convert';
import 'dart:typed_data';

// Dart models matching your Rust structs
abstract class ChannelEvent {
  const ChannelEvent();

  static ChannelEvent fromJson(Map<String, dynamic> json) {
    // Handle the enum serialization format from Rust serde
    if (json.containsKey('Renegotitate')) {
      return Renegotitate.fromJson(json['Renegotitate']);
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
