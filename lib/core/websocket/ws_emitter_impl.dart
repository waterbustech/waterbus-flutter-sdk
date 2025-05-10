import 'package:injectable/injectable.dart';
import 'package:socket_io_client/socket_io_client.dart';

import 'package:waterbus_sdk/constants/ws_event.dart';
import 'package:waterbus_sdk/core/websocket/interfaces/ws_emitter.dart';
import 'package:waterbus_sdk/core/websocket/interfaces/ws_handler.dart';
import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';
import 'package:waterbus_sdk/injection/injection_container.dart';

@Injectable(as: WsEmitter)
class WsEmitterImpl extends WsEmitter {
  // ====== Room Events ======
  @override
  void publish({
    required String sdp,
    required String roomId,
    required String participantId,
    required ParticipantSFU participant,
    required int totalTracks,
  }) {
    _socket?.emit(WsEvent.roomPublish, {
      "roomId": roomId,
      "sdp": sdp,
      "participantId": participantId,
      "isVideoEnabled": participant.isVideoEnabled,
      "isAudioEnabled": participant.isAudioEnabled,
      "isE2eeEnabled": participant.isE2eeEnabled,
      "totalTracks": totalTracks,
    });
  }

  @override
  void subscribe({
    required String roomId,
    required String participantId,
    required String targetId,
  }) {
    _socket?.emit(WsEvent.roomSubscribe, {
      "roomId": roomId,
      "targetId": targetId,
      "participantId": participantId,
    });
  }

  @override
  void answerSubscribe({
    required String targetId,
    required String sdp,
  }) {
    _socket?.emit(WsEvent.roomAnswerSubscriber, {
      "targetId": targetId,
      "sdp": sdp,
    });
  }

  @override
  void sendRenegotiateSdp(String sdp) {
    _socket?.emit(WsEvent.roomPublisherRenegotiation, {'sdp': sdp});
  }

  @override
  void leaveRoom(String roomId) {
    _socket?.emit(WsEvent.roomLeave, {"roomId": roomId});
  }

  @override
  void reconnect() {
    _socket?.emit(WsEvent.roomReconnect);
  }

  // ====== ICE Candidate Events ======
  @override
  void sendPublisherCandidate(RTCIceCandidate candidate) {
    _socket?.emit(WsEvent.roomPublisherCandidate, candidate.toMap());
  }

  @override
  void sendSubscriberCandidate({
    required RTCIceCandidate candidate,
    required targetId,
  }) {
    _socket?.emit(WsEvent.roomSubscriberCandidate, {
      'targetId': targetId,
      'candidate': candidate.toMap(),
    });
  }

  // ====== Media Controls Events ======
  @override
  void setCameraType(CameraType cameraType) {
    _socket?.emit(WsEvent.roomCameraType, {'type': cameraType.type});
  }

  @override
  void setVideoEnabled(bool isEnabled) {
    _socket?.emit(WsEvent.roomVideoEnabled, {'isEnabled': isEnabled});
  }

  @override
  void setAudioEnabled(bool isEnabled) {
    _socket?.emit(WsEvent.roomAudioEnabled, {'isEnabled': isEnabled});
  }

  @override
  void setScreenSharing(bool isSharing, {String? screenTrackId}) {
    final payload = <String, dynamic>{
      'isSharing': isSharing,
    };

    if (screenTrackId != null) {
      payload['screenTrackId'] = screenTrackId;
    }

    _socket?.emit(WsEvent.roomScreenSharing, payload);
  }

  @override
  void setSubtitle(bool isEnabled) {
    _socket?.emit(WsEvent.roomSubtitleTrack, {'isEnabled': isEnabled});
  }

  @override
  void setHandRaising(bool isRaising) {
    _socket?.emit(WsEvent.roomHandRaising, {'isRaising': isRaising});
  }

  // ====== Internal ======
  Socket? get _socket => getIt<WsHandler>().socket;
}
