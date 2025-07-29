import 'package:injectable/injectable.dart';
import 'package:socket_io_client/socket_io_client.dart';

import 'package:waterbus_sdk/constants/ws_event.dart';
import 'package:waterbus_sdk/core/websocket/interfaces/ws_emitter.dart';
import 'package:waterbus_sdk/core/websocket/interfaces/ws_handler.dart';
import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';
import 'package:waterbus_sdk/injection/injection_container.dart';
import 'package:waterbus_sdk/types/internals/enums/connection_type.dart';
import 'package:waterbus_sdk/types/internals/models/index.dart';

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
    required String roomId,
    required String targetId,
    required String sdp,
    required ConnectionType connectionType,
  }) {
    _socket?.emit(WsEvent.roomAnswerSubscriber, {
      "roomId": roomId,
      "targetId": targetId,
      "sdp": sdp,
      'connectionType': connectionType.index,
    });
  }

  @override
  void renegotiateSdp({
    required String roomId,
    required String sdp,
    required ConnectionType connectionType,
  }) {
    _socket?.emit(WsEvent.roomPublisherRenegotiation, {
      'sdp': sdp,
      'roomId': roomId,
      'connectionType': connectionType.index,
    });
  }

  @override
  void leaveRoom(String roomId) {
    _socket?.emit(WsEvent.roomLeave, {"roomId": roomId});
  }

  @override
  void reconnect() {
    _socket?.emit(WsEvent.roomReconnect);
  }

  @override
  void migrateConnection({
    required String roomId,
    required String participantId,
    required String sdp,
    required ConnectionType connectionType,
  }) {
    _socket?.emit(WsEvent.roomMigrate, {
      'roomId': roomId,
      'sdp': sdp,
      'participantId': participantId,
      'connectionType': connectionType.index,
    });
  }

  // ====== ICE Candidate Events ======
  @override
  void sendPublisherIceCandidate({
    required RTCIceCandidate candidate,
    required ConnectionType connectionType,
    required String roomId,
  }) {
    _socket?.emit(
      WsEvent.roomPublisherCandidate,
      {
        'candidate': candidate.toMap(),
        'connectionType': connectionType.index,
        'roomId': roomId,
      },
    );
  }

  @override
  void sendSubscriberIceCandidate({
    required RTCIceCandidate candidate,
    required String targetId,
    required ConnectionType connectionType,
    required String roomId,
  }) {
    _socket?.emit(WsEvent.roomSubscriberCandidate, {
      'targetId': targetId,
      'candidate': candidate.toMap(),
      'connectionType': connectionType.index,
      'roomId': roomId,
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
