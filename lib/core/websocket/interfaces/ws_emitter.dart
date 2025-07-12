import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';
import 'package:waterbus_sdk/types/internals/enums/connection_type.dart';
import 'package:waterbus_sdk/types/internals/models/index.dart';

abstract class WsEmitter {
  // ====== Room Events ======
  void publishRoom({required PublishWsEmitterPayLoad payload});

  void subscribeRoom({required SubscribePayload payload});

  void answerSubscription({
    required String roomId,
    required String targetId,
    required String sdp,
    required ConnectionType connectionType,
  });

  void renegotiateSdp({
    required String roomId,
    required String sdp,
    required ConnectionType connectionType,
  });

  void leaveRoom(String roomId);

  void reconnect();

  void migrateConnection({
    required String roomId,
    required String participantId,
    required String sdp,
    required ConnectionType connectionType,
  });

  // ====== ICE Candidate Events ======
  void sendPublisherIceCandidate({
    required RTCIceCandidate candidate,
    required ConnectionType connectionType,
    required String roomId,
  });

  void sendSubscriberIceCandidate({
    required RTCIceCandidate candidate,
    required String targetId,
    required ConnectionType connectionType,
    required String roomId,
  });

  // ====== Media Controls Events ======
  void switchCamera(CameraType cameraType);

  void toggleVideo(bool isEnabled);

  void toggleAudio(bool isEnabled);

  void toggleScreenSharing(bool isSharing, {String? screenTrackId});

  void toggleSubtitle(bool isEnabled);

  void toggleHandRaise(bool isRaising);
}
