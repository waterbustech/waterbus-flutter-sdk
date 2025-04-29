import 'package:injectable/injectable.dart';
import 'package:socket_io_client/socket_io_client.dart';

import 'package:waterbus_sdk/constants/ws_event.dart';
import 'package:waterbus_sdk/core/websocket/interfaces/ws_emitter.dart';
import 'package:waterbus_sdk/core/websocket/interfaces/ws_handler.dart';
import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';
import 'package:waterbus_sdk/injection/injection_container.dart';
import 'package:waterbus_sdk/types/models/draw_model.dart';

@Injectable(as: WsEmitter)
class WsEmitterImpl extends WsEmitter {
  // MARK: emit functions
  @override
  void establishBroadcast({
    required String sdp,
    required String roomId,
    required String participantId,
    required ParticipantSFU participant,
    required int totalTracks,
  }) {
    _socket?.emit(WsEvent.publishCSS, {
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
  void leaveRoom(String roomId) {
    _socket?.emit(WsEvent.sendLeaveRoomCSS, {"roomId": roomId});
  }

  @override
  void sendBroadcastCandidate(RTCIceCandidate candidate) {
    _socket?.emit(
      WsEvent.publisherCandidateCSS,
      candidate.toMap(),
    );
  }

  @override
  void sendReceiverCandidate({
    required RTCIceCandidate candidate,
    required targetId,
  }) {
    _socket?.emit(WsEvent.subscriberCandidateCSS, {
      'targetId': targetId,
      'candidate': candidate.toMap(),
    });
  }

  @override
  void answerEstablishSubscriber({
    required String targetId,
    required String sdp,
  }) {
    _socket?.emit(WsEvent.answerSubscriberCSS, {
      "targetId": targetId,
      "sdp": sdp,
    });
  }

  @override
  void requestEstablishSubscriber({
    required String roomId,
    required String participantId,
    required String targetId,
  }) {
    _socket?.emit(WsEvent.subscribeCSS, {
      "roomId": roomId,
      "targetId": targetId,
      "participantId": participantId,
    });
  }

  @override
  void setE2eeEnabled(bool isEnabled) {
    _socket?.emit(WsEvent.setE2eeEnabledCSS, {'isEnabled': isEnabled});
  }

  @override
  void setAudioEnabled(bool isEnabled) {
    _socket?.emit(WsEvent.setAudioEnabledCSS, {'isEnabled': isEnabled});
  }

  @override
  void setVideoEnabled(bool isEnabled) {
    _socket?.emit(WsEvent.setVideoEnabledCSS, {'isEnabled': isEnabled});
  }

  @override
  void setCameraType(CameraType cameraType) {
    _socket?.emit(WsEvent.setCameraTypeCSS, {'type': cameraType.type});
  }

  @override
  void setScreenSharing(bool isSharing, {String? screenTrackId}) {
    final payload = <String, dynamic>{
      'isSharing': isSharing,
    };

    if (screenTrackId != null) {
      payload['screenTrackId'] = screenTrackId;
    }

    _socket?.emit(WsEvent.setScreenSharingCSS, payload);
  }

  @override
  void sendNewSdp(String sdp) {
    _socket?.emit(WsEvent.publisherRenegotiationCSS, {'sdp': sdp});
  }

  @override
  void setSubtitle(bool isEnabled) {
    _socket?.emit(WsEvent.setSubscribeSubtitleCSS, {'isEnabled': isEnabled});
  }

  @override
  void setHandRaising(bool isRaising) {
    _socket?.emit(WsEvent.handRaisingCSS, {'isRaising': isRaising});
  }

  @override
  void reconnect() {
    _socket?.emit(WsEvent.reconnect);
  }

  // White board

  @override
  void cleanWhiteBoard(String roomId) {
    _socket?.emit(WsEvent.cleanWhiteBoardCSS, {'roomId': roomId});
  }

  @override
  void startWhiteBoard(String roomId) {
    _socket?.emit(WsEvent.startWhiteBoardCSS, {'roomId': roomId});
  }

  @override
  void updateWhiteBoard(String roomId, String action, DrawModel draw) {
    _socket?.emit(WsEvent.updateWhiteBoardCSS, {
      'roomId': roomId,
      'action': action,
      'paints': [draw.toMap()],
    });
  }

  Socket? get _socket => getIt<WsHandler>().socket;
}
