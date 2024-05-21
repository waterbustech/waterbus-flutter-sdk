import 'package:flutter/foundation.dart';

import 'package:injectable/injectable.dart';
import 'package:socket_io_client/socket_io_client.dart';

import 'package:waterbus_sdk/constants/socket_events.dart';
import 'package:waterbus_sdk/core/webrtc/webrtc_interface.dart';
import 'package:waterbus_sdk/core/websocket/interfaces/socket_handler_interface.dart';
import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';
import 'package:waterbus_sdk/utils/logger/logger.dart';

@Singleton(as: SocketHandler)
class SocketHandlerImpl extends SocketHandler {
  final WaterbusWebRTCManager _rtcManager;
  final WaterbusLogger _logger;
  SocketHandlerImpl(
    this._rtcManager,
    this._logger,
  );

  Socket? _socket;

  @override
  void establishConnection({
    required String accessToken,
    bool forceConnection = false,
  }) {
    if (_socket != null && !forceConnection) return;

    _socket = io(
      WaterbusSdk.wsWaterbusUrl,
      OptionBuilder()
          .setTransports(kIsWeb ? ['polling'] : ['websocket'])
          .enableReconnection()
          .enableForceNew()
          .setExtraHeaders({
        'Authorization': 'Bearer $accessToken',
      }).build(),
    );

    _socket?.connect();

    _socket?.onError((data) async {
      establishConnection(accessToken: accessToken);
    });

    _socket?.onConnect((_) async {
      _logger.log('established connection - sid: ${_socket?.id}');

      _socket?.on(SocketEvent.publishSSC, (data) {
        // pc context: only send peer
        // will receive sdp remote from service side if you join success
        /// otherParticipants, sdp (data)

        if (data == null) return;

        final String sdp = data['sdp'];

        _rtcManager.setPublisherRemoteSdp(sdp);
      });

      _socket?.on(SocketEvent.newParticipantSSC, (data) {
        /// Will receive signal when someone join,
        /// targetId
        if (data == null) return;

        final participant = Participant.fromMap(data);

        _rtcManager.newParticipant(participant);
      });

      _socket?.on(SocketEvent.answerSubscriberSSC, (data) async {
        // pc context: only receive peer
        // will receive sdp, get it and add to pc
        /// sdp, targetId
        if (data == null || data['offer'] == null) return;

        final WebRTCCodec codec =
            ((data['videoCodec'] ?? '') as String).videoCodec;

        final int type = data['cameraType'] ?? CameraType.front.type;

        await _rtcManager.setSubscriberRemoteSdp(
          targetId: data['targetId'],
          sdp: data['offer'],
          audioEnabled: data['audioEnabled'] ?? false,
          videoEnabled: data['videoEnabled'] ?? false,
          isScreenSharing: data['isScreenSharing'] ?? false,
          isE2eeEnabled: data['isE2eeEnabled'] ?? false,
          type: CameraType.values[type],
          codec: codec,
        );
      });

      _socket?.on(SocketEvent.participantHasLeftSSC, (data) {
        /// targetId
        if (data == null) return;

        final participantId = data['targetId'];

        _rtcManager.participantHasLeft(participantId);
      });

      _socket?.on(SocketEvent.publisherCandidateSSC, (data) {
        /// candidate json
        if (data == null) return;

        final RTCIceCandidate candidate = RTCIceCandidate(
          data['candidate'],
          data['sdpMid'],
          data['sdpMLineIndex'],
        );

        _rtcManager.addPublisherCandidate(candidate);
      });

      _socket?.on(SocketEvent.subscriberCandidateSSC, (data) {
        /// targetId, candidate json
        ///
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

      _socket?.on(SocketEvent.setE2eeEnabledSSC, (data) {
        /// targetId, isEnabled
        if (data == null) return;

        final String participantId = data['participantId'];
        final bool isEnabled = data['isEnabled'];

        _rtcManager.setE2eeEnabled(
          targetId: participantId,
          isEnabled: isEnabled,
        );
      });

      _socket?.on(SocketEvent.setAudioEnabledSSC, (data) {
        /// targetId, isEnabled
        if (data == null) return;

        final String participantId = data['participantId'];
        final bool isEnabled = data['isEnabled'];

        _rtcManager.setAudioEnabled(
          targetId: participantId,
          isEnabled: isEnabled,
        );
      });

      _socket?.on(SocketEvent.setVideoEnabledSSC, (data) {
        /// targetId, isEnabled
        if (data == null) return;

        final String participantId = data['participantId'];
        final bool isEnabled = data['isEnabled'];

        _rtcManager.setVideoEnabled(
          targetId: participantId,
          isEnabled: isEnabled,
        );
      });

      _socket?.on(SocketEvent.setCameraTypeSSC, (data) {
        /// targetId, isEnabled
        if (data == null) return;

        final String participantId = data['participantId'];
        final int type = data['type'];

        _rtcManager.setCameraType(
          targetId: participantId,
          type: CameraType.values[type],
        );
      });

      _socket?.on(SocketEvent.setScreenSharingSSC, (data) {
        /// targetId, isSharing
        if (data == null) return;

        final String participantId = data['participantId'];
        final bool isSharing = data['isSharing'];

        _rtcManager.setScreenSharing(
          targetId: participantId,
          isSharing: isSharing,
        );
      });

      _socket!.on(SocketEvent.publisherRenegotiationSSC, (data) {
        if (data == null) return;

        final String sdp = data['sdp'];

        _rtcManager.setPublisherRemoteSdp(sdp);
      });

      _socket!.on(SocketEvent.subscriberRenegotiationSSC, (data) {
        if (data == null) return;

        final String targetId = data['targetId'];
        final String sdp = data['sdp'];

        _rtcManager.handleSubscriberRenegotiation(
          targetId: targetId,
          sdp: sdp,
        );
      });
    });
  }

  @override
  void disconnection() {
    if (_socket == null) return;

    _socket?.disconnect();
    _socket = null;
  }

  @override
  Socket? get socket => _socket;
}
