part of 'rtc_manager_impl.dart';

extension RtcManagerPrivate on RtcManagerIpml {
  // ======== Media Acquisition ========
  Future<MediaStream?> _getUserMedia({bool onlyStream = false}) async {
    try {
      final MediaStream stream = await navigator.mediaDevices.getUserMedia(
        _currentCallSetting.mediaConstraints,
      );
      // Microphone not granted or has been broken
      if (stream.getAudioTracks().isEmpty) {
        toggleAudioInput(forceValue: false);
      }

      // Camera not granted or has been broken
      if (stream.getVideoTracks().isEmpty) {
        toggleVideoInput(forceValue: false);
      }

      if (stream.getTracks().isEmpty) return null;

      if (onlyStream) return stream;

      if (_currentCallSetting.audioConfig.isAudioMuted) {
        toggleAudioInput(forceValue: false);
      }

      if (_currentCallSetting.videoConfig.isVideoMuted) {
        toggleVideoInput(forceValue: false);
      }

      return stream;
    } catch (error) {
      // Unable getUserMedia
      toggleAudioInput(forceValue: false);
      toggleVideoInput(forceValue: false);

      return null;
    }
  }

  Future<MediaStream> _getDisplayMedia(DesktopCapturerSource? source) async {
    late final Map<String, dynamic> mediaConstraints;
    if (kIsWeb) {
      mediaConstraints = {
        "video": true,
        "audio": false,
      };
    } else if (WebRTC.platformIsLinux) {
      mediaConstraints = {
        'video': {
          'deviceId': {'exact': source?.id},
          'mandatory': {'frameRate': 30.0},
        },
      };
    } else {
      mediaConstraints = <String, dynamic>{
        'audio': false,
        'video': {
          'deviceId': source?.id ?? 'broadcast',
          'frameRate': 30,
          'mandatory': {
            'minWidth': 1280,
            'minHeight': 720,
            'minFrameRate': 10,
          },
        },
      };
    }

    final MediaStream stream = await navigator.mediaDevices.getDisplayMedia(
      mediaConstraints,
    );

    return stream;
  }

  // ======== PeerConnection Lifecycle ========
  Future<RTCPeerConnection> _createPeerConnection({
    Map<String, dynamic> constraints = const {},
    bool? isE2eeEnabled,
  }) async {
    IceServersResponse iceServers = kIceServers;

    if (_connectionType == ConnectionType.p2p) {
      iceServers = await _authRepository.getIceServers();
    }

    final RTCPeerConnection pc = await createPeerConnection(
      RTCConfigurations.configuration(
        isE2eeEnabled ?? _currentCallSetting.e2eeEnabled,
        iceServers: iceServers,
      ),
      constraints,
    );

    return pc;
  }

  Future<void> _establishPublisher() async {
    final RTCPeerConnection peerConnection = _localParticipant!.peerConnection;

    if (_connectionType == ConnectionType.sfu) {
      await _localParticipant?.createDataChannel();
    }

    peerConnection.onIceCandidate = (candidate) {
      if (_canPublisherAddIceCandidate) {
        _wsEmitter.sendPublisherIceCandidate(
          candidate: candidate,
          connectionType: _connectionType,
          roomId: _currentRoomId!,
        );
      } else {
        _iceCandidateQueueForPublisher.add(candidate);
      }
    };

    final List<MediaStreamTrack> tracks = _localCameraStream?.getTracks() ?? [];
    final List<RTCRtpSender> senders = [];

    for (final track in tracks) {
      final (sender, mid) = await peerConnection.addSimulcastTrack(
        track,
        vCodec: _currentCallSetting.videoConfig.preferedCodec,
        stream: _localCameraStream!,
        kind: track.kind == RtcTrackKind.video.kind
            ? RtcTrackKind.video
            : RtcTrackKind.audio,
        isSingleTrack: _connectionType == ConnectionType.p2p,
      );

      senders.add(sender);

      if (track.kind == RtcTrackKind.audio.kind) {
        _audioStats.setSender = AudioStatsParams(
          receivers: [],
          ownerId: kIsMine,
          pc: peerConnection,
          callBack: (audioLevel) {
            _localParticipant = _localParticipant?.sinkAudioLevel(audioLevel);
          },
        );
      } else {
        _videoStats.addSenders(
          ownerId: '$kIsMine-${TrackType.webcam.toString()}',
          senders: [sender],
          callback: (stats) {
            _localParticipant?.sinkWebcamStats(stats);
          },
        );
      }
    }

    await _applyEncryption(_currentCallSetting.e2eeEnabled, senders: senders);

    String sdp = await _createOfferSdp(peerConnection);

    if (_localCameraStream?.getVideoTracks().isNotEmpty ?? false) {
      sdp = sdp.optimizeSdp(
        codec: _currentCallSetting.videoConfig.preferedCodec,
        isP2P: _connectionType == ConnectionType.p2p,
      );
    }

    final RTCSessionDescription description = RTCSessionDescription(
      sdp,
      DescriptionType.offer.type,
    );

    await peerConnection.setLocalDescription(description);

    final PublishWsEmitterPayLoad payload = PublishWsEmitterPayLoad(
      sdp: sdp,
      roomId: _currentRoomId!,
      participantId: _currentParticipantId!,
      totalTracks: senders.length,
      isVideoEnabled: _localParticipant?.isVideoEnabled ?? false,
      isAudioEnabled: _localParticipant?.isAudioEnabled ?? false,
      isE2eeEnabled: _localParticipant?.isE2eeEnabled ?? false,
      connectionType: _connectionType,
      streamingProtocol: StreamingProtocol.sfu,
      isIpv6Supported: _isIpv6Supported,
    );

    _wsEmitter.publishRoom(payload: payload);

    if (WebRTC.platformIsLinux) return;

    _videoStats.initialize();
    _audioStats.initialize();
  }

  void _establishSubscriber(String targetId) {
    if (_currentRoomId == null || _currentParticipantId == null) return;

    final SubscribePayload payload = SubscribePayload(
      roomId: _currentRoomId ?? "",
      participantId: _currentParticipantId ?? "",
      targetId: targetId,
      isIpv6Supported: _isIpv6Supported,
    );

    _wsEmitter.subscribeRoom(payload: payload);
  }

  // ======== Migrate connection between P2P and SFU ========
  Future<void> _migrateConnection() async {
    _iceCandidateQueueForPublisher.clear();
    _remoteIceCandidatesForPublisher.clear();
    _canPublisherAddIceCandidate = false;
    final pc = await _createPeerConnection(
      constraints: RTCConfigurations.offerPublisherSdpConstraints,
    );

    _localParticipant!.backupPc = pc;

    pc.onIceCandidate = (candidate) {
      if (_canPublisherAddIceCandidate) {
        _wsEmitter.sendPublisherIceCandidate(
          candidate: candidate,
          connectionType: _connectionType,
          roomId: _currentRoomId!,
        );
      } else {
        _iceCandidateQueueForPublisher.add(candidate);
      }
    };

    pc.onConnectionState = (state) {
      if (state == RTCPeerConnectionState.RTCPeerConnectionStateConnected) {
        // Stop p2p connection after 10s since sfu connected
        // to ensure other participants migrate silently
        Future.delayed(10.seconds, () async {
          final p2pPeerConnection = _localParticipant?.peerConnection;

          _localParticipant!.peerConnection = pc;
          _localParticipant!.backupPc = null;

          await p2pPeerConnection?.close();
        });
      }
    };

    final List<MediaStreamTrack> streamTracks =
        _screenSharingStream?.getTracks() ?? [];
    final List<MediaStreamTrack> tracks = _localCameraStream?.getTracks() ?? [];
    final List<RTCRtpSender> senders = [];

    tracks.addAll(streamTracks);

    for (final track in tracks) {
      final (sender, mid) = await pc.addSimulcastTrack(
        track,
        vCodec: _currentCallSetting.videoConfig.preferedCodec,
        stream: _localCameraStream!,
        kind: track.kind == RtcTrackKind.video.kind
            ? RtcTrackKind.video
            : RtcTrackKind.audio,
        isSingleTrack: _connectionType == ConnectionType.p2p,
      );

      senders.add(sender);

      if (track.kind == RtcTrackKind.audio.kind) {
        _audioStats.setSender = AudioStatsParams(
          receivers: [],
          ownerId: kIsMine,
          pc: pc,
          callBack: (audioLevel) {
            _localParticipant = _localParticipant?.sinkAudioLevel(audioLevel);
          },
        );
      } else {
        _videoStats.addSenders(
          ownerId: '$kIsMine-${TrackType.webcam.toString()}',
          senders: [sender],
          callback: (stats) {
            _localParticipant?.sinkWebcamStats(stats);
          },
        );
      }
    }

    await _applyEncryption(_currentCallSetting.e2eeEnabled, senders: senders);

    String sdp = await _createOfferSdp(pc);

    if (_localCameraStream?.getVideoTracks().isNotEmpty ?? false) {
      sdp = sdp.optimizeSdp(
        codec: _currentCallSetting.videoConfig.preferedCodec,
        isP2P: _connectionType == ConnectionType.p2p,
      );
    }

    final RTCSessionDescription description = RTCSessionDescription(
      sdp,
      DescriptionType.offer.type,
    );

    await pc.setLocalDescription(description);

    _wsEmitter.migrateConnection(
      roomId: _currentRoomId!,
      participantId: _currentParticipantId!,
      sdp: sdp,
      connectionType: _connectionType,
    );
  }

  void _setConnectionType(
    ConnectionType connectionType, {
    bool needMigrate = false,
  }) {
    if (_connectionType == connectionType) return;

    _connectionType = connectionType;

    if (needMigrate) {
      scheduleMicrotask(() async {
        await _migrateConnection();
      });
    }
  }

  void _resetRoomState() {
    _currentRoomId = null;
    _currentParticipantId = null;
    _iceCandidateQueueForPublisher.clear();
    _remoteIceCandidatesForPublisher.clear();
    _iceCandidateQueueForSubscribers.clear();
    _canPublisherAddIceCandidate = false;
    _nativeService.endCallKit();
    _connectionType = ConnectionType.p2p;
  }

  // ======== SDP Offer/Answer ========
  Future<String> _createAnswerSdp(RTCPeerConnection peerConnection) async {
    final RTCSessionDescription description =
        await peerConnection.createAnswer();
    final session = parse(description.sdp.toString());
    final String sdp = write(session, null);

    return sdp;
  }

  Future<String> _createOfferSdp(RTCPeerConnection peerConnection) async {
    final RTCSessionDescription description =
        await peerConnection.createOffer();
    final session = parse(description.sdp.toString());
    final String sdp = write(session, null);

    return sdp;
  }

  // ======== ICE Handling ========
  Future<void> _answerSubscriber({
    required RTCSessionDescription remoteDescription,
    required SubscribeResponsePayload payload,
  }) async {
    final RTCPeerConnection rtcPeerConnection = await _createPeerConnection(
      constraints: RTCConfigurations.offerSubscriberSdpConstraints,
      isE2eeEnabled: payload.isE2eeEnabled,
    );

    rtcPeerConnection.addTransceiver(
      kind: RTCRtpMediaType.RTCRtpMediaTypeVideo,
      init: RTCRtpTransceiverInit(
        direction: TransceiverDirection.RecvOnly,
      ),
    );
    rtcPeerConnection.addTransceiver(
      kind: RTCRtpMediaType.RTCRtpMediaTypeAudio,
      init: RTCRtpTransceiverInit(
        direction: TransceiverDirection.RecvOnly,
      ),
    );

    final targetId = payload.targetId;

    final isMigrate = _remoteSubscribers.containsKey(targetId);

    _remoteSubscribers[targetId] ??= RemoteParticipant.init(
      ownerId: targetId,
      peerConnection: rtcPeerConnection,
      onFirstFrameRendered: () => _notifyRoomEvent(
        RoomStateChanged(
          timestamp: DateTime.now(),
          roomId: _currentRoomId ?? '',
        ),
      ),
      isAudioEnabled: payload.audioEnabled,
      isVideoEnabled: payload.videoEnabled,
      isSharingScreen: payload.isScreenSharing,
      isE2eeEnabled: payload.isE2eeEnabled,
      isHandRaising: payload.isHandRaising,
      screenTrackId: payload.screenTrackId,
      cameraType: payload.type,
      videoCodec: payload.codec,
      connectionType: _connectionType,
      info: _participants[targetId] ?? ParticipantInfo(id: 0),
    );

    if (_connectionType == ConnectionType.sfu) {
      await _remoteSubscribers[targetId]?.createDataChannel();
    }

    if (isMigrate) {
      if (_remoteSubscribers[targetId] != null) {
        _remoteSubscribers[targetId]!.backupPc = rtcPeerConnection;
        _remoteSubscribers[targetId]!.connectionType = _connectionType;
      }

      rtcPeerConnection.onConnectionState = (state) async {
        if (state == RTCPeerConnectionState.RTCPeerConnectionStateConnected ||
            _remoteSubscribers[targetId]?.backupPc != null) {
          if (_remoteSubscribers[targetId] != null) {
            _remoteSubscribers[targetId]!.peerConnection = rtcPeerConnection;
            _remoteSubscribers[targetId]!.backupPc = null;
          }
        }
      };
    }

    rtcPeerConnection.onTrack = (track) {
      if (!_remoteSubscribers.containsKey(targetId)) return;

      if (track.streams.isEmpty) return;

      Future.microtask(() async {
        if (track.receiver == null) return;
        final ParticipantE2eeConfig config = ParticipantE2eeConfig(
          receiver: track.receiver!,
          targetId: targetId,
          isEnabled: payload.isE2eeEnabled,
        );

        await setParticipantE2ee(config: config);

        final TrackType? type = _remoteSubscribers[targetId]?.setSrcObject(
          track.streams.first,
          trackId: track.track.id,
        );

        if (type == null) return;

        if (track.track.kind == RtcTrackKind.video.kind) {
          _videoStats.addReceivers(
            ownerId:
                targetId + DateTime.now().microsecondsSinceEpoch.toString(),
            receivers: [track.receiver!],
            callback: (stats) {
              if (type == TrackType.screen) {
                _remoteSubscribers[targetId]?.sinkWebcamStats(stats);
              } else {
                _remoteSubscribers[targetId]?.sinkScreenStats(stats);
              }
            },
          );
        } else if (track.track.kind == RtcTrackKind.audio.kind) {
          _audioStats.addReceiver(
            ownerId: targetId,
            receiver: track.receiver!,
            callback: (audioLevel) {
              _remoteSubscribers[targetId]?.sinkAudioLevel(audioLevel);
            },
          );
        }

        _notifyRoomEvent(
          RoomStateChanged(
            timestamp: DateTime.now(),
            roomId: _currentRoomId ?? '',
          ),
        );
      });
    };

    rtcPeerConnection.onIceCandidate = (candidate) {
      _wsEmitter.sendSubscriberIceCandidate(
        candidate: candidate,
        targetId: targetId,
        connectionType: _connectionType,
        roomId: _currentRoomId!,
      );
    };

    rtcPeerConnection.setRemoteDescription(remoteDescription);

    final String sdp = await _createAnswerSdp(rtcPeerConnection);
    final RTCSessionDescription description = RTCSessionDescription(
      sdp,
      DescriptionType.answer.type,
    );
    await rtcPeerConnection.setLocalDescription(description);

    _wsEmitter.answerSubscription(
      roomId: _currentRoomId!,
      targetId: targetId,
      sdp: sdp,
      connectionType: _connectionType,
    );

    // Process queue candidates from server
    final List<RTCIceCandidate> candidates =
        _iceCandidateQueueForSubscribers[targetId] ?? [];

    for (final candidate in candidates) {
      addIceCandidateToSubscriber(targetId, candidate);
    }
  }

  // ======== Stream Replacement ========
  Future<void> _replaceMediaStream(MediaStream? newStream) async {
    final List<RTCRtpSender> senders =
        await _localParticipant!.peerConnection.getSenders();

    final List<RTCRtpSender> sendersAudio = senders
        .where((sender) => sender.track?.kind == RtcTrackKind.audio.kind)
        .toList();
    final List<RTCRtpSender> sendersVideo = senders
        .where((sender) => sender.track?.kind == RtcTrackKind.video.kind)
        .toList();

    final MediaStreamTrack? audioTrack =
        newStream?.getAudioTracks().firstOrNull;
    final MediaStreamTrack? videoTrack =
        newStream?.getVideoTracks().firstOrNull;

    if (audioTrack != null) {
      for (final sender in sendersAudio) {
        sender.replaceTrack(audioTrack);
      }
    }

    if (videoTrack != null) {
      await _replaceVideoTrack(
        videoTrack,
        sendersList: sendersVideo,
      );
    }

    if (newStream != null) _localParticipant?.setSrcObject(newStream);
    _localCameraStream = newStream;
  }

  Future<void> _replaceAudioTrack(
    MediaStreamTrack track, {
    List<RTCRtpSender>? sendersList,
  }) async {
    final List<RTCRtpSender> senders =
        (sendersList ?? await _localParticipant!.peerConnection.getSenders())
            .where(
              (sender) => sender.track?.kind == RtcTrackKind.audio.kind,
            )
            .toList();

    if (senders.isEmpty) return;

    final sender = senders.first;

    await sender.replaceTrack(track);

    await _applyEncryption(_currentCallSetting.e2eeEnabled, senders: [sender]);
  }

  Future<void> _replaceVideoTrack(
    MediaStreamTrack track, {
    List<RTCRtpSender>? sendersList,
  }) async {
    final List<RTCRtpSender> senders =
        (sendersList ?? await _localParticipant!.peerConnection.getSenders())
            .where(
              (sender) => sender.track?.kind == RtcTrackKind.video.kind,
            )
            .toList();

    if (senders.isEmpty) return;

    final sender = senders.first;

    await sender.replaceTrack(track);

    await _applyEncryption(_currentCallSetting.e2eeEnabled, senders: [sender]);
  }

  // ======== Encryption (E2EE) Setup ========
  Future<void> _applyEncryption(
    bool enabled, {
    List<RTCRtpSender> senders = const [],
  }) async {
    final List<Future> futureTasks = [];

    for (final sender in senders) {
      futureTasks.add(
        _encryptionManager.addRtpSender(sender: sender),
      );
    }

    await Future.wait(futureTasks);

    _localParticipant!.isE2eeEnabled = enabled;
  }

  // ======== Renegotiation Flow ========
  Future<void> _performRenegotiation() async {
    final pc = _localParticipant?.peerConnection;

    if (pc == null) return;

    String sdp = await _createOfferSdp(pc);

    if (_localCameraStream?.getVideoTracks().isNotEmpty ?? false) {
      sdp = sdp.optimizeSdp(
        codec: _currentCallSetting.videoConfig.preferedCodec,
        isP2P: _connectionType == ConnectionType.p2p,
      );
    }

    final RTCSessionDescription description = RTCSessionDescription(
      sdp,
      DescriptionType.offer.type,
    );

    await pc.setLocalDescription(description);

    _wsEmitter.renegotiateSdp(
      sdp: sdp,
      roomId: _currentRoomId!,
      connectionType: _connectionType,
    );
  }

  // ======== New Event Notification Methods ========
  void _notifyRoomEvent(
    RoomEvent event,
  ) {
    _eventSystem.emitRoomEvent(event);
  }

  void _notifyParticipantEvent(
    ParticipantEvent event,
  ) {
    _eventSystem.emitParticipantEvent(event);
  }
}
