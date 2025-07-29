import 'package:flutter/foundation.dart';

import 'package:injectable/injectable.dart';
import 'package:socket_io_client/socket_io_client.dart';

import 'package:waterbus_sdk/constants/ws_event.dart';
import 'package:waterbus_sdk/core/api/auth/datasources/auth_local_data_source.dart';
import 'package:waterbus_sdk/core/webrtc/webrtc_manager.dart';
import 'package:waterbus_sdk/core/websocket/interfaces/ws_handler.dart';
import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';
import 'package:waterbus_sdk/types/internals/enums/connection_type.dart';
import 'package:waterbus_sdk/types/internals/models/index.dart';
import 'package:waterbus_sdk/utils/dio/dio_configuration.dart';
import 'package:waterbus_sdk/utils/encrypt/encrypt.dart';
import 'package:waterbus_sdk/utils/extensions/duration_extension.dart';
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

    _socket = io(WaterbusSdk.serverConfig.url, options);

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

      _listenToRoomEvents();
      _listenToMediaEvents();
      _listenToRenegotiationEvents();
      _listenToChatEvents();
      _listenToSystemEvents();
    });
  }

  void _listenToRoomEvents() {
    _socket?.on(WsEvent.roomPublish, (data) {
      if (data == null) return;
      _rtcManager.setLocalSdpAsPublisher(data['sdp'], data['isRecording']);
    });

    _socket?.on(WsEvent.roomNewParticipant, (data) {
      if (data == null) return;

      final participant =
          Participant.fromJson(Map<String, dynamic>.from(data['participant']));
      final isMigrate = data['isMigrate'];

      _rtcManager.handleParticipantJoined(
        participant: participant,
        isMigrate: isMigrate,
      );
    });

    _socket?.on(WsEvent.roomAnswerSubscriber, (data) async {
      if (data == null || data['offer'] == null) return;

      final RTCVideoCodec codec =
          ((data['videoCodec'] ?? '') as String).toLowerCase().videoCodec;

      final payload = SubscribeResponsePayload(
        targetId: data['targetId'],
        sdp: data['offer'],
        audioEnabled: data['audioEnabled'] ?? false,
        videoEnabled: data['videoEnabled'] ?? false,
        isScreenSharing: data['isScreenSharing'] ?? false,
        isE2eeEnabled: data['isE2eeEnabled'] ?? false,
        isHandRaising: data['isHandRaising'] ?? false,
        screenTrackId: data['screenTrackId'],
        type: CameraType.values[data['cameraType'] ?? CameraType.front.type],
        connectionType: (data['connectionType'] as int?).toConnectionType(),
        codec: codec,
      );

      await _rtcManager.setRemoteSdpAsSubscriber(payload);
    });

    _socket?.on(WsEvent.roomParticipantLeft, (data) {
      if (data == null) return;
      _rtcManager.handleParticipantLeft(data['targetId']);
    });
  }

  void _listenToMediaEvents() {
    _socket?.on(WsEvent.roomPublisherCandidate, (data) {
      if (data == null) return;
      _rtcManager.addIceCandidateToPublisher(
        RTCIceCandidate(
          data['candidate'],
          data['sdpMid'],
          data['sdpMLineIndex'],
        ),
      );
    });

    _socket?.on(WsEvent.roomSubscriberCandidate, (data) {
      if (data == null) return;
      final c = data['candidate'];
      _rtcManager.addIceCandidateToSubscriber(
        data['targetId'],
        RTCIceCandidate(c['candidate'], c['sdpMid'], c['sdpMLineIndex']),
      );
    });

    _socket?.on(WsEvent.roomAudioEnabled, (data) {
      if (data == null) return;
      _rtcManager.setParticipantAudioEnabled(
        targetId: data['participantId'],
        isEnabled: data['isEnabled'],
      );
    });

    _socket?.on(WsEvent.roomVideoEnabled, (data) {
      if (data == null) return;
      _rtcManager.setParticipantVideoEnabled(
        targetId: data['participantId'],
        isEnabled: data['isEnabled'],
      );
    });

    _socket?.on(WsEvent.roomCameraType, (data) {
      if (data == null) return;
      _rtcManager.setParticipantCameraType(
        targetId: data['participantId'],
        type: CameraType.values[data['type']],
      );
    });

    _socket?.on(WsEvent.roomScreenSharing, (data) {
      if (data == null) return;

      _rtcManager.setParticipantScreenSharing(
        config: ParticipantScreenSharingConfig.fromJson(data),
      );
    });

    _socket?.on(WsEvent.roomHandRaising, (data) {
      if (data == null) return;
      _rtcManager.setParticipantHandRaising(
        targetId: data['participantId'],
        isRaising: data['isRaising'],
      );
    });
  }

  void _listenToRenegotiationEvents() {
    _socket?.on(WsEvent.roomPublisherRenegotiation, (data) {
      if (data == null) return;
      _rtcManager.setLocalSdpAsPublisher(data['sdp']);
    });

    _socket?.on(WsEvent.roomSubscriberRenegotiation, (data) {
      if (data == null) return;

      _rtcManager.renegotiateWithParticipant(
        targetId: data['targetId'],
        sdp: data['sdp'],
      );
    });

    _socket?.on(WsEvent.roomMigrate, (data) {
      if (data == null) return;
      _rtcManager.setLocalSdpAsPublisher(data['sdp']);
    });
  }

  void _listenToSystemEvents() {
    _socket?.on(WsEvent.systemDestroy, (data) {
      if (data == null) return;
    });
  }

  void _listenToChatEvents() {
    _socket?.on(WsEvent.chatSend, (data) async {
      if (data == null) return;
      final msg = Message.fromJson(data);
      final decrypted = await EncryptAES().decryptAES256(cipherText: msg.data);
      WaterbusSdk.listener.onMesssageChanged?.call(
        MessageSocketEvent(
          event: MessageEventEnum.create,
          message: msg.copyWith(data: decrypted),
        ),
      );
    });

    _socket?.on(WsEvent.chatUpdate, (data) async {
      if (data == null) return;
      final msg = Message.fromJson(data);
      final decrypted = await EncryptAES().decryptAES256(cipherText: msg.data);
      WaterbusSdk.listener.onMesssageChanged?.call(
        MessageSocketEvent(
          event: MessageEventEnum.update,
          message: msg.copyWith(data: decrypted),
        ),
      );
    });

    _socket?.on(WsEvent.chatDelete, (data) {
      if (data == null) return;
      final msg = Message.fromJson(data);
      WaterbusSdk.listener.onMesssageChanged?.call(
        MessageSocketEvent(event: MessageEventEnum.delete, message: msg),
      );
    });
  }

  @override
  void disconnection() {
    if (_socket == null) return;

    _socket?.disconnect();
    _socket = null;
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
