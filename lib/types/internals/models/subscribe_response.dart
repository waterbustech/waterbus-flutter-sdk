import 'package:waterbus_sdk/types/externals/enums/index.dart';
import 'package:waterbus_sdk/types/internals/enums/connection_type.dart';

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
  final ConnectionType connectionType;

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
    required this.connectionType,
    this.screenTrackId,
  });
}
