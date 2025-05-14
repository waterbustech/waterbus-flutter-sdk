import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';

abstract class WsEmitter {
  // ====== Room Events ======
  void publishRoom({required PublishWsEmitterPayLoad payload});

  void subscribeRoom({required SubscribePayload payload});

  void answerSubscription({required String targetId, required String sdp});

  void renegotiateSdp(String sdp);

  void leaveRoom(String roomId);

  void reconnect();

  // ====== ICE Candidate Events ======
  void sendPublisherIceCandidate(RTCIceCandidate candidate);

  void sendSubscriberIceCandidate({
    required RTCIceCandidate candidate,
    required String targetId,
  });

  // ====== Media Controls Events ======
  void switchCamera(CameraType cameraType);

  void toggleVideo(bool isEnabled);

  void toggleAudio(bool isEnabled);

  void toggleScreenSharing(bool isSharing, {String? screenTrackId});

  void toggleSubtitle(bool isEnabled);

  void toggleHandRaise(bool isRaising);
}
