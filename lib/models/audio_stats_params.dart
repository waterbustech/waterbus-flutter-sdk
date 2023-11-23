// Project imports:
import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';
import 'package:waterbus_sdk/models/enums/audio_level.dart';

class AudioStatsParams {
  final RTCPeerConnection peerConnection;
  final Function(AudioLevel) callBack;
  final List<RTCRtpReceiver> receivers;
  AudioStatsParams({
    required this.peerConnection,
    required this.callBack,
    this.receivers = const [],
  });

  AudioStatsParams copyWith({
    RTCPeerConnection? peerConnection,
    Function(AudioLevel)? callBack,
  }) {
    return AudioStatsParams(
      peerConnection: peerConnection ?? this.peerConnection,
      callBack: callBack ?? this.callBack,
    );
  }

  @override
  String toString() =>
      'AudioStatsParams(peerConnection: $peerConnection, callBack: $callBack)';

  @override
  bool operator ==(covariant AudioStatsParams other) {
    if (identical(this, other)) return true;

    return other.peerConnection == peerConnection && other.callBack == callBack;
  }

  @override
  int get hashCode => peerConnection.hashCode ^ callBack.hashCode;
}
