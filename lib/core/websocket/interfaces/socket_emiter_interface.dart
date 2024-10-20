import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';
import 'package:waterbus_sdk/types/models/draw_model.dart';

abstract class SocketEmiter {
  // Meeting
  void establishBroadcast({
    required String sdp,
    required String roomId,
    required String participantId,
    required ParticipantSFU participant,
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
  void setE2eeEnabled(bool isEnabled);
  void setCameraType(CameraType cameraType);
  void setVideoEnabled(bool isEnabled);
  void setAudioEnabled(bool isEnabled);
  void setScreenSharing(bool isSharing);
  void sendNewSdp(String sdp);
  void leaveRoom(String roomId);
  void setSubtitle(bool isEnabled);
  void reconnect();

  // White board
  void startWhiteBoard(String roomId);
  void updateWhiteBoard(String roomId, String action, DrawModel draw);
  void cleanWhiteBoard(String roomId);
}
