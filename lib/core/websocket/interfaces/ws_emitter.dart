import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';

abstract class WsEmitter {
  // Meeting
  void establishBroadcast({
    required String sdp,
    required String roomId,
    required String participantId,
    required ParticipantSFU participant,
    required int totalTracks,
  });
  void requestEstablishSubscriber({
    required String roomId,
    required String participantId,
    required String targetId,
  });
  void answerEstablishSubscriber({
    required String targetId,
    required String sdp,
  });
  void sendBroadcastCandidate(RTCIceCandidate candidate);
  void sendReceiverCandidate({
    required RTCIceCandidate candidate,
    required targetId,
  });
  void setCameraType(CameraType cameraType);
  void setVideoEnabled(bool isEnabled);
  void setAudioEnabled(bool isEnabled);
  void setScreenSharing(bool isSharing, {String? screenTrackId});
  void setSubtitle(bool isEnabled);
  void setHandRaising(bool isRaising);

  void sendNewSdp(String sdp);
  void leaveRoom(String roomId);
  void reconnect();
}
