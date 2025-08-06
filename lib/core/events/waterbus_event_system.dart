import 'dart:async';

import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';

/// Room event types using sealed classes
sealed class RoomEvent {
  final DateTime timestamp;
  final String roomId;

  const RoomEvent({
    required this.timestamp,
    required this.roomId,
  });
}

class RoomConnectionStateChanged extends RoomEvent {
  final bool isConnected;
  final String connectionType;

  const RoomConnectionStateChanged({
    required super.timestamp,
    required super.roomId,
    required this.isConnected,
    required this.connectionType,
  });
}

class RoomEnded extends RoomEvent {
  final String? reason;

  const RoomEnded({
    required super.timestamp,
    required super.roomId,
    this.reason,
  });
}

class RoomRecordingStatusChanged extends RoomEvent {
  final bool isRecording;

  const RoomRecordingStatusChanged({
    required super.timestamp,
    required super.roomId,
    required this.isRecording,
  });
}

class RoomMetadataChanged extends RoomEvent {
  final String metadata;

  const RoomMetadataChanged({
    required super.timestamp,
    required super.roomId,
    required this.metadata,
  });
}

class RoomStateChanged extends RoomEvent {
  const RoomStateChanged({
    required super.timestamp,
    required super.roomId,
  });
}

/// Participant event types using sealed classes
sealed class ParticipantEvent {
  final DateTime timestamp;
  final String roomId;
  final String participantId;

  const ParticipantEvent({
    required this.timestamp,
    required this.roomId,
    required this.participantId,
  });
}

class ParticipantJoined extends ParticipantEvent {
  final Map<String, dynamic> participantData;

  const ParticipantJoined({
    required super.timestamp,
    required super.roomId,
    required super.participantId,
    this.participantData = const {},
  });
}

class ParticipantLeft extends ParticipantEvent {
  const ParticipantLeft({
    required super.timestamp,
    required super.roomId,
    required super.participantId,
  });
}

class ParticipantAudioEnabledChanged extends ParticipantEvent {
  final bool isEnabled;

  const ParticipantAudioEnabledChanged({
    required super.timestamp,
    required super.roomId,
    required super.participantId,
    required this.isEnabled,
  });
}

class ParticipantVideoEnabledChanged extends ParticipantEvent {
  final bool isEnabled;

  const ParticipantVideoEnabledChanged({
    required super.timestamp,
    required super.roomId,
    required super.participantId,
    required this.isEnabled,
  });
}

class ParticipantCameraTypeChanged extends ParticipantEvent {
  final String cameraType;

  const ParticipantCameraTypeChanged({
    required super.timestamp,
    required super.roomId,
    required super.participantId,
    required this.cameraType,
  });
}

class ParticipantScreenSharingChanged extends ParticipantEvent {
  final bool isSharing;
  final String? screenTrackId;

  const ParticipantScreenSharingChanged({
    required super.timestamp,
    required super.roomId,
    required super.participantId,
    required this.isSharing,
    this.screenTrackId,
  });
}

class ParticipantHandRaiseChanged extends ParticipantEvent {
  final bool isRaising;

  const ParticipantHandRaiseChanged({
    required super.timestamp,
    required super.roomId,
    required super.participantId,
    required this.isRaising,
  });
}

class ParticipantE2eeEnabledChanged extends ParticipantEvent {
  final bool isEnabled;

  const ParticipantE2eeEnabledChanged({
    required super.timestamp,
    required super.roomId,
    required super.participantId,
    required this.isEnabled,
  });
}

class ParticipantConnectionQualityChanged extends ParticipantEvent {
  final int quality;

  const ParticipantConnectionQualityChanged({
    required super.timestamp,
    required super.roomId,
    required super.participantId,
    required this.quality,
  });
}

class ParticipantStatsUpdated extends ParticipantEvent {
  final Map<String, dynamic> stats;

  const ParticipantStatsUpdated({
    required super.timestamp,
    required super.roomId,
    required super.participantId,
    required this.stats,
  });
}

/// Track event types using sealed classes
sealed class TrackEvent {
  final DateTime timestamp;
  final String roomId;
  final String participantId;
  final String trackId;
  final String trackKind;
  final bool isLocal;

  const TrackEvent({
    required this.timestamp,
    required this.roomId,
    required this.participantId,
    required this.trackId,
    required this.trackKind,
    required this.isLocal,
  });
}

class TrackStarted extends TrackEvent {
  const TrackStarted({
    required super.timestamp,
    required super.roomId,
    required super.participantId,
    required super.trackId,
    required super.trackKind,
    required super.isLocal,
  });
}

class TrackEnded extends TrackEvent {
  const TrackEnded({
    required super.timestamp,
    required super.roomId,
    required super.participantId,
    required super.trackId,
    required super.trackKind,
    required super.isLocal,
  });
}

class TrackMuted extends TrackEvent {
  final bool isMuted;

  const TrackMuted({
    required super.timestamp,
    required super.roomId,
    required super.participantId,
    required super.trackId,
    required super.trackKind,
    required super.isLocal,
    required this.isMuted,
  });
}

class TrackQualityChanged extends TrackEvent {
  final int quality;

  const TrackQualityChanged({
    required super.timestamp,
    required super.roomId,
    required super.participantId,
    required super.trackId,
    required super.trackKind,
    required super.isLocal,
    required this.quality,
  });
}

class TrackStatsUpdated extends TrackEvent {
  final Map<String, dynamic> stats;

  const TrackStatsUpdated({
    required super.timestamp,
    required super.roomId,
    required super.participantId,
    required super.trackId,
    required super.trackKind,
    required super.isLocal,
    required this.stats,
  });
}

class TrackPermissionChanged extends TrackEvent {
  final bool hasPermission;

  const TrackPermissionChanged({
    required super.timestamp,
    required super.roomId,
    required super.participantId,
    required super.trackId,
    required super.trackKind,
    required super.isLocal,
    required this.hasPermission,
  });
}

/// Connection event types using sealed classes
sealed class ConnectionEvent {
  final DateTime timestamp;
  final String roomId;
  final String participantId;

  const ConnectionEvent({
    required this.timestamp,
    required this.roomId,
    required this.participantId,
  });
}

class IceConnectionStateChanged extends ConnectionEvent {
  final String state;

  const IceConnectionStateChanged({
    required super.timestamp,
    required super.roomId,
    required super.participantId,
    required this.state,
  });
}

class IceGatheringStateChanged extends ConnectionEvent {
  final String state;

  const IceGatheringStateChanged({
    required super.timestamp,
    required super.roomId,
    required super.participantId,
    required this.state,
  });
}

class ConnectionStateChanged extends ConnectionEvent {
  final String state;

  const ConnectionStateChanged({
    required super.timestamp,
    required super.roomId,
    required super.participantId,
    required this.state,
  });
}

class SignalingStateChanged extends ConnectionEvent {
  final String state;

  const SignalingStateChanged({
    required super.timestamp,
    required super.roomId,
    required super.participantId,
    required this.state,
  });
}

class IceCandidateReceived extends ConnectionEvent {
  final String candidate;

  const IceCandidateReceived({
    required super.timestamp,
    required super.roomId,
    required super.participantId,
    required this.candidate,
  });
}

class IceCandidateSent extends ConnectionEvent {
  final String candidate;

  const IceCandidateSent({
    required super.timestamp,
    required super.roomId,
    required super.participantId,
    required this.candidate,
  });
}

class ConnectionQualityChanged extends ConnectionEvent {
  final int quality;

  const ConnectionQualityChanged({
    required super.timestamp,
    required super.roomId,
    required super.participantId,
    required this.quality,
  });
}

/// Message event types using sealed classes
sealed class MessageEvent {
  final DateTime timestamp;
  final String roomId;

  const MessageEvent({
    required this.timestamp,
    required this.roomId,
  });
}

class MessageReceived extends MessageEvent {
  final Message message;

  const MessageReceived({
    required super.timestamp,
    required super.roomId,
    required this.message,
  });
}

class MessageUpdated extends MessageEvent {
  final Message message;

  const MessageUpdated({
    required super.timestamp,
    required super.roomId,
    required this.message,
  });
}

class MessageDeleted extends MessageEvent {
  final Message message;

  const MessageDeleted({
    required super.timestamp,
    required super.roomId,
    required this.message,
  });
}

/// Main event system with generic subscription
class WaterbusEventSystem {
  // Separate streams for different event types
  final StreamController<RoomEvent> _roomEventsController =
      StreamController<RoomEvent>.broadcast();
  final StreamController<ParticipantEvent> _participantEventsController =
      StreamController<ParticipantEvent>.broadcast();
  final StreamController<TrackEvent> _trackEventsController =
      StreamController<TrackEvent>.broadcast();
  final StreamController<ConnectionEvent> _connectionEventsController =
      StreamController<ConnectionEvent>.broadcast();
  final StreamController<MessageEvent> _messageEventsController =
      StreamController<MessageEvent>.broadcast();

  // Public streams
  Stream<RoomEvent> get roomEvents => _roomEventsController.stream;
  Stream<ParticipantEvent> get participantEvents =>
      _participantEventsController.stream;
  Stream<TrackEvent> get trackEvents => _trackEventsController.stream;
  Stream<ConnectionEvent> get connectionEvents =>
      _connectionEventsController.stream;
  Stream<MessageEvent> get messageEvents => _messageEventsController.stream;

  /// Generic subscription method
  Stream<T> on<T>() {
    if (T == RoomEvent) {
      return roomEvents as Stream<T>;
    } else if (T == ParticipantEvent) {
      return participantEvents as Stream<T>;
    } else if (T == TrackEvent) {
      return trackEvents as Stream<T>;
    } else if (T == ConnectionEvent) {
      return connectionEvents as Stream<T>;
    } else if (T == MessageEvent) {
      return messageEvents as Stream<T>;
    }
    throw ArgumentError('Unsupported event type: $T');
  }

  /// Emit a room event
  void emitRoomEvent(RoomEvent event) {
    _roomEventsController.add(event);
  }

  /// Emit a participant event
  void emitParticipantEvent(ParticipantEvent event) {
    _participantEventsController.add(event);
  }

  /// Emit a track event
  void emitTrackEvent(TrackEvent event) {
    _trackEventsController.add(event);
  }

  /// Emit a connection event
  void emitConnectionEvent(ConnectionEvent event) {
    _connectionEventsController.add(event);
  }

  /// Emit a message event
  void emitMessageEvent(MessageEvent event) {
    _messageEventsController.add(event);
  }

  /// Dispose all controllers
  void dispose() {
    _roomEventsController.close();
    _participantEventsController.close();
    _trackEventsController.close();
    _connectionEventsController.close();
    _messageEventsController.close();
  }
}
