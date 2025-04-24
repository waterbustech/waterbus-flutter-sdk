import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';

class SubscribeResponsePayload {
  final String targetId;
  final String sdp;
  final bool videoEnabled;
  final bool audioEnabled;
  final bool isScreenSharing;
  final bool isE2eeEnabled;
  final bool isHandRaising;
  final CameraType type;
  final RTCVideoCodec codec;
  final String? screenTrackId;

  SubscribeResponsePayload({
    required this.targetId,
    required this.sdp,
    required this.videoEnabled,
    required this.audioEnabled,
    required this.isScreenSharing,
    required this.isE2eeEnabled,
    required this.isHandRaising,
    required this.type,
    required this.codec,
    this.screenTrackId,
  });
}
