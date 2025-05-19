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
  void publishRoom({required PublishWsEmitterPayLoad payload}) {
    _socket?.emit(WsEvent.roomPublish, payload.toJson());
  }

  @override
  void subscribeRoom({required SubscribePayload payload}) {
    _socket?.emit(WsEvent.roomSubscribe, payload.toJson());
  }

  @override
  void answerSubscription({
    required String targetId,
    required String sdp,
  }) {
    _socket?.emit(WsEvent.roomAnswerSubscriber, {
      "targetId": targetId,
      "sdp": sdp,
    });
  }

  @override
  void renegotiateSdp(String sdp) {
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
  void sendPublisherIceCandidate(RTCIceCandidate candidate) {
    _socket?.emit(WsEvent.roomPublisherCandidate, candidate.toMap());
  }

  @override
  void sendSubscriberIceCandidate({
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
  void switchCamera(CameraType cameraType) {
    _socket?.emit(WsEvent.roomCameraType, {'type': cameraType.type});
  }

  @override
  void toggleVideo(bool isEnabled) {
    _socket?.emit(WsEvent.roomVideoEnabled, {'isEnabled': isEnabled});
  }

  @override
  void toggleAudio(bool isEnabled) {
    _socket?.emit(WsEvent.roomAudioEnabled, {'isEnabled': isEnabled});
  }

  @override
  void toggleScreenSharing(bool isSharing, {String? screenTrackId}) {
    final payload = <String, dynamic>{
      'isSharing': isSharing,
    };

    if (screenTrackId != null) {
      payload['screenTrackId'] = screenTrackId;
    }

    _socket?.emit(WsEvent.roomScreenSharing, payload);
  }

  @override
  void toggleSubtitle(bool isEnabled) {
    _socket?.emit(WsEvent.roomSubtitleTrack, {'isEnabled': isEnabled});
  }

  @override
  void toggleHandRaise(bool isRaising) {
    _socket?.emit(WsEvent.roomHandRaising, {'isRaising': isRaising});
  }

  // ====== Internal ======
  Socket? get _socket => getIt<WsHandler>().socket;
}
