// Project imports:
import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';

abstract class SocketEmiter {
  void establishBroadcast({
    required String sdp,
    required String roomId,
    required String participantId,
    required ParticipantSFU participant,
  });
  void requestEstablishSubscriber({required String targetId});
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
  void setVideoEnabled(bool isEnabled);
  void setAudioEnabled(bool isEnabled);
  void setScreenSharing(bool isSharing);
  void leaveRoom(String roomId);
}
