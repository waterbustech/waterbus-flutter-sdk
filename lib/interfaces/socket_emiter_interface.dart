// Package imports:
import 'package:flutter_webrtc/flutter_webrtc.dart';

abstract class SocketEmiter {
  void establishBroadcast({
    required String sdp,
    required String roomId,
    required String participantId,
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
  void setVideoEnabled(bool isEnabled);
  void setAudioEnabled(bool isEnabled);
  void leaveRoom(String roomId);
}
