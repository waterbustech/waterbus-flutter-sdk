import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';

abstract class WsEmitter {
  // ====== Room Events ======
  void publish({
    required String sdp,
    required String roomId,
    required String participantId,
    required ParticipantSFU participant,
    required int totalTracks,
  });

  void subscribe({
    required String roomId,
    required String participantId,
    required String targetId,
  });

  void answerSubscribe({
    required String targetId,
    required String sdp,
  });

  void sendRenegotiateSdp(String sdp);

  void leaveRoom(String roomId);

  void reconnect();

  // ====== ICE Candidate Events ======
  void sendPublisherCandidate(RTCIceCandidate candidate);

  void sendSubscriberCandidate({
    required RTCIceCandidate candidate,
    required String targetId,
  });

  // ====== Media Controls Events ======
  void setCameraType(CameraType cameraType);

  void setVideoEnabled(bool isEnabled);

  void setAudioEnabled(bool isEnabled);

  void setScreenSharing(bool isSharing, {String? screenTrackId});

  void setSubtitle(bool isEnabled);

  void setHandRaising(bool isRaising);
}
