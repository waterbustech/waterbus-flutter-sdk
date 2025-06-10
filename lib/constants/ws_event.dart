class WsEvent {
  // ====== Room Events ======
  static const String roomPublish = 'room.publish';
  static const String roomSubscribe = 'room.subscribe';
  static const String roomAnswerSubscriber = 'room.answer_subscriber';
  static const String roomLeave = 'room.leave';
  static const String roomReconnect = 'room.reconnect';
  static const String roomMigrate = 'room.migrate';

  // ====== Room Renegotiation Events ======
  static const String roomPublisherRenegotiation =
      'room.publisher_renegotiation';
  static const String roomSubscriberRenegotiation =
      'room.subscriber_renegotiation';

  // ====== ICE Candidate Events ======
  static const String roomPublisherCandidate = 'room.publisher_candidate';
  static const String roomSubscriberCandidate = 'room.subscriber_candidate';

  // ====== Participant Presence Events ======
  static const String roomNewParticipant = 'room.new_participant';
  static const String roomParticipantLeft = 'room.participant_left';

  // ====== Media Controls Events ======
  static const String roomVideoEnabled = 'room.video_enabled';
  static const String roomCameraType = 'room.camera_type';
  static const String roomAudioEnabled = 'room.audio_enabled';
  static const String roomScreenSharing = 'room.screen_sharing';
  static const String roomHandRaising = 'room.hand_raising';
  static const String roomSubtitleTrack = 'room.subscribe_subtitle';

  // ====== Chat Events ======
  static const String chatSend = 'chat.send';
  static const String chatUpdate = 'chat.update';
  static const String chatDelete = 'chat.delete';

  // ====== System Events ======
  static const String systemDestroy = 'system.destroy';
}
