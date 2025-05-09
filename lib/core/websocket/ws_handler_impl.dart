import 'package:flutter/foundation.dart';

import 'package:injectable/injectable.dart';
import 'package:socket_io_client/socket_io_client.dart';

import 'package:waterbus_sdk/constants/ws_event.dart';
import 'package:waterbus_sdk/core/api/auth/datasources/auth_local_datasource.dart';
import 'package:waterbus_sdk/core/api/base/dio_configuration.dart';
import 'package:waterbus_sdk/core/webrtc/webrtc_manager.dart';
import 'package:waterbus_sdk/core/websocket/interfaces/ws_handler.dart';
import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';
import 'package:waterbus_sdk/types/models/conversation_socket_event.dart';
import 'package:waterbus_sdk/types/models/subscribe_response.dart';
import 'package:waterbus_sdk/utils/encrypt/encrypt.dart';
import 'package:waterbus_sdk/utils/extensions/duration_extensions.dart';
import 'package:waterbus_sdk/utils/logger/logger.dart';
import 'package:waterbus_sdk/utils/msg_pack_parser.dart';

@Singleton(as: WsHandler)
class WsHandlerImpl extends WsHandler {
  final WebRTCManager _rtcManager;
  final WaterbusLogger _logger;
  final AuthLocalDataSource _authLocal;
  final DioConfiguration _dioConfig;
  WsHandlerImpl(
    this._rtcManager,
    this._logger,
    this._authLocal,
    this._dioConfig,
  );

  Socket? _socket;
  String _podName = '';

  @override
  void establishConnection({
    bool forceConnection = false,
    int numberOfRetries = 3,
    String? forceAccessToken,
    Function? callbackConnected,
  }) {
    if (_authLocal.accessToken.isEmpty ||
        (_socket != null && !forceConnection)) {
      return;
    }

    disconnection();

    final String mAccessToken = forceAccessToken ?? _authLocal.accessToken;

    final options = OptionBuilder()
        .setTransports(kIsWeb ? ['polling'] : ['websocket'])
        .enableReconnection()
        .enableForceNew()
        .setParser(
          ParserOptions(
            encoder: () => MsgPackEncoder(),
            decoder: () => MsgPackDecoder(),
          ),
        )
        .setExtraHeaders(
      {
        'Authorization': 'Bearer $mAccessToken',
      },
    ).build();

    _socket = io(WaterbusSdk.wsUrl, options);

    _socket?.connect();

    _socket?.onError((data) async {
      if (_authLocal.accessToken.isEmpty || numberOfRetries == 0) return;

      final (String newAccessToken, _) = await _dioConfig.onRefreshToken(
        oldAccessToken: mAccessToken,
      );

      Future.delayed(1.seconds, () {
        establishConnection(
          forceConnection: true,
          forceAccessToken: newAccessToken,
          numberOfRetries: numberOfRetries - 1,
        );
      });
    });

    _socket?.onConnect((_) async {
      callbackConnected?.call();

      _logger.log('established connection - sid: ${_socket?.id}');

      _socket?.on(WsEvent.publishSSC, (data) {
        /// pc context: only send peer
        /// will receive sdp remote from service side if you join success
        /// otherParticipants, sdp (data)

        if (data == null) return;

        final String sdp = data['sdp'];
        final bool isRecording = data['isRecording'];

        _rtcManager.setPublisherRemoteSdp(sdp, isRecording);
      });

      _socket?.on(WsEvent.newParticipantSSC, (data) {
        /// Will receive signal when someone join,
        /// targetId
        if (data == null) return;

        final participant = Participant.fromMap(
          Map<String, dynamic>.from(data),
        );

        _rtcManager.handleNewParticipant(participant);
      });

      _socket?.on(WsEvent.answerSubscriberSSC, (data) async {
        /// pc context: only receive peer
        /// will receive sdp, get it and add to pc
        /// sdp, targetId
        if (data == null || data['offer'] == null) return;

        final RTCVideoCodec codec =
            ((data['videoCodec'] ?? '') as String).videoCodec;

        final int type = data['cameraType'] ?? CameraType.front.type;
        final payload = SubscribeResponsePayload(
          targetId: data['targetId'],
          sdp: data['offer'],
          audioEnabled: data['audioEnabled'] ?? false,
          videoEnabled: data['videoEnabled'] ?? false,
          isScreenSharing: data['isScreenSharing'] ?? false,
          isE2eeEnabled: data['isE2eeEnabled'] ?? false,
          isHandRaising: data['isHandRaising'] ?? false,
          screenTrackId: data['screenTrackId'],
          type: CameraType.values[type],
          codec: codec,
        );

        await _rtcManager.setSubscriberRemoteSdp(payload);
      });

      _socket?.on(WsEvent.participantHasLeftSSC, (data) {
        /// targetId
        if (data == null) return;

        final participantId = data['targetId'];

        _rtcManager.handleParticipantLeave(participantId);
      });

      _socket?.on(WsEvent.publisherCandidateSSC, (data) {
        /// candidate json
        if (data == null) return;

        final RTCIceCandidate candidate = RTCIceCandidate(
          data['candidate'],
          data['sdpMid'],
          data['sdpMLineIndex'],
        );

        _rtcManager.addPublisherCandidate(candidate);
      });

      _socket?.on(WsEvent.subscriberCandidateSSC, (data) {
        /// targetId, candidate json

        if (data == null) return;

        final Map<String, dynamic> candidateMap = data['candidate'];

        final String participantId = data['targetId'];
        final RTCIceCandidate candidate = RTCIceCandidate(
          candidateMap['candidate'],
          candidateMap['sdpMid'],
          candidateMap['sdpMLineIndex'],
        );

        _rtcManager.addSubscriberCandidate(participantId, candidate);
      });

      _socket?.on(WsEvent.setAudioEnabledSSC, (data) {
        /// targetId, isEnabled
        if (data == null) return;

        final String participantId = data['participantId'];
        final bool isEnabled = data['isEnabled'];

        _rtcManager.setAudioEnabled(
          targetId: participantId,
          isEnabled: isEnabled,
        );
      });

      _socket?.on(WsEvent.setVideoEnabledSSC, (data) {
        /// targetId, isEnabled
        if (data == null) return;

        final String participantId = data['participantId'];
        final bool isEnabled = data['isEnabled'];

        _rtcManager.setVideoEnabled(
          targetId: participantId,
          isEnabled: isEnabled,
        );
      });

      _socket?.on(WsEvent.setCameraTypeSSC, (data) {
        /// targetId, isEnabled
        if (data == null) return;

        final String participantId = data['participantId'];
        final int type = data['type'];

        _rtcManager.setCameraType(
          targetId: participantId,
          type: CameraType.values[type],
        );
      });

      _socket?.on(WsEvent.setScreenSharingSSC, (data) {
        /// targetId, isSharing
        if (data == null) return;

        final String participantId = data['participantId'];
        final bool isSharing = data['isSharing'];
        final String? screenTrackId = data['screenTrackId'];

        _rtcManager.setScreenSharing(
          targetId: participantId,
          isSharing: isSharing,
          screenTrackId: screenTrackId,
        );
      });

      _socket!.on(WsEvent.publisherRenegotiationSSC, (data) {
        if (data == null) return;

        final String sdp = data['sdp'];

        _rtcManager.setPublisherRemoteSdp(sdp);
      });

      _socket!.on(WsEvent.subscriberRenegotiationSSC, (data) {
        if (data == null) return;

        final String targetId = data['targetId'];
        final String sdp = data['sdp'];

        _rtcManager.renegotiateSubscriber(
          targetId: targetId,
          sdp: sdp,
        );
      });

      _socket?.on(WsEvent.handRaisingSSC, (data) {
        if (data == null) return;

        final String participantId = data['participantId'];
        final bool isRaising = data['isRaising'];
        _rtcManager.setHandRaising(
          targetId: participantId,
          isRaising: isRaising,
        );
      });

      _socket?.on(WsEvent.destroy, (data) {
        if (data == null) return;

        final String podName = data['podName'];

        if (_podName == podName && _rtcManager.roomId != null) {
          reconnect(
            callbackConnected: () {
              _rtcManager.reconnect();
            },
          );
        }
      });

      _socket?.on(WsEvent.sendMessageSSC, (data) async {
        if (data == null) return;

        final MessageModel message = MessageModel.fromMapSocket(data);

        final String dataDecrypted =
            await EncryptAES().decryptAES256(cipherText: message.data);

        WaterbusSdk.listener.onMesssageChanged?.call(
          MessageSocketEvent(
            event: MessageEventEnum.create,
            message: message.copyWith(data: dataDecrypted),
          ),
        );
      });

      _socket?.on(WsEvent.updateMessageSSC, (data) async {
        if (data == null) return;

        final MessageModel message = MessageModel.fromMapSocket(data);

        final String dataDecrypted =
            await EncryptAES().decryptAES256(cipherText: message.data);

        WaterbusSdk.listener.onMesssageChanged?.call(
          MessageSocketEvent(
            event: MessageEventEnum.update,
            message: message.copyWith(data: dataDecrypted),
          ),
        );
      });

      _socket?.on(WsEvent.deleteMessageSSC, (data) {
        if (data == null) return;

        final MessageModel message = MessageModel.fromMapSocket(data);

        WaterbusSdk.listener.onMesssageChanged?.call(
          MessageSocketEvent(event: MessageEventEnum.delete, message: message),
        );
      });

      _socket?.on(WsEvent.newInvitationSSC, (data) {
        if (data == null) return;
        final Meeting meeting = Meeting.fromMapSocket(data['meeting']);

        WaterbusSdk.listener.onConversationChanged?.call(
          ConversationSocketEvent(
            event: ConversationEventEnum.newInvitaion,
            conversation: meeting,
          ),
        );
      });

      _socket?.on(WsEvent.newMemberJoinedSSC, (data) {
        if (data == null) return;
        final Member member = Member.fromMapSocket(data);

        WaterbusSdk.listener.onConversationChanged?.call(
          ConversationSocketEvent(
            event: ConversationEventEnum.newMemberJoined,
            member: member,
          ),
        );
      });
    });
  }

  @override
  void disconnection() {
    if (_socket == null) return;

    _socket?.disconnect();
    _socket = null;
    _podName = '';
  }

  @override
  void reconnect({required Function callbackConnected}) {
    disconnection();
    establishConnection(
      forceConnection: true,
      callbackConnected: callbackConnected,
    );
  }

  @override
  Socket? get socket => _socket;

  @override
  bool get isConnected => _socket != null && _socket!.connected;
}
