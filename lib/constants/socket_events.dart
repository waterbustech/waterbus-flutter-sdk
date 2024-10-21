class SocketEvent {
  // Meeting
  static const String publishCSS = 'PUBLISH_CSS';
  static const String publishSSC = 'PUBLISH_SSC';
  static const String subscribeCSS = 'SUBSCRIBE_CSS';
  static const String answerSubscriberSSC = 'SEND_SDP_SUBSCRIBER_SSC';
  static const String answerSubscriberCSS = 'SEND_SDP_SUBSCRIBER_CSS';
  static const String publisherCandidateCSS = 'SEND_CANDIDATE_PUBLISHER_CSS';
  static const String publisherCandidateSSC = 'SEND_CANDIDATE_PUBLISHER_SSC';
  static const String subscriberCandidateCSS = 'SEND_CANDIDATE_SUBSCRIBER_CSS';
  static const String subscriberCandidateSSC = 'SEND_CANDIDATE_SUBSCRIBER_SSC';
  static const String newParticipantSSC = 'NEW_PARTICIPANT_SSC';
  static const String participantHasLeftSSC = 'PARTICIPANT_HAS_LEFT_SSC';
  static const String sendLeaveRoomCSS = 'LEAVE_ROOM_CSS';
  static const String setE2eeEnabledCSS = "SET_E2EE_ENABLED_CSS";
  static const String setE2eeEnabledSSC = "SET_E2EE_ENABLED_SSC";
  static const String setVideoEnabledCSS = "SET_VIDEO_ENABLED_CSS";
  static const String setVideoEnabledSSC = "SET_VIDEO_ENABLED_SSC";
  static const String setCameraTypeCSS = "SET_CAMERA_TYPE_CSS";
  static const String setCameraTypeSSC = "SET_CAMERA_TYPE_SSC";
  static const String setAudioEnabledCSS = "SET_AUDIO_ENABLED_CSS";
  static const String setAudioEnabledSSC = "SET_AUDIO_ENABLED_SSC";
  static const String setScreenSharingSSC = "SET_SCREEN_SHARING_SSC";
  static const String setScreenSharingCSS = "SET_SCREEN_SHARING_CSS";
  static const String handRaisingSSC = 'HAND_RAISING_SSC';
  static const String handRaisingCSS = 'HAND_RAISING_CSS';
  static const String subtitleSSC = 'SUBTITLE_SSC';
  static const String setSubscribeSubtitleCSS = 'SET_SUBSCRIBE_SUBTITLE_CSS';
  static const String startRecordSSC = 'START_RECORD_SSC';
  static const String stopRecordSSC = 'STOP_RECORD_SSC';

  static const String publisherRenegotiationCSS = 'PUBLISHER_RENEGOTIATION_CSS';
  static const String publisherRenegotiationSSC = 'PUBLISHER_RENEGOTIATION_SSC';
  static const String subscriberRenegotiationSSC =
      'SUBSCRIBER_RENEGOTIATION_SSC';

  // Chats
  static const String sendMessageSSC = 'SEND_MESSAGE_SSC';
  static const String updateMessageSSC = 'UPDATE_MESSAGE_SSC';
  static const String deleteMessageSSC = 'DELETE_MESSAGE_SSC';

  static const String newMemberJoinedSSC = 'NEW_MEMBER_JOINED_SSC';
  static const String newInvitationSSC = 'NEW_INVITATION_SSC';
  static const String startWhiteBoardSSC = 'START_WHITE_BOARD_SSC';
  static const String startWhiteBoardCSS = 'START_WHITE_BOARD_CSS';
  static const String updateWhiteBoardCSS = 'UPDATE_WHITE_BOARD_CSS';
  static const String updateWhiteBoardSSC = 'UPDATE_WHITE_BOARD_SSC';
  static const String cleanWhiteBoardCSS = 'CLEAN_WHITE_BOARD_CSS';
  static const String cleanWhiteBoardSSC = 'CLEAN_WHITE_BOARD_SSC';

  // System
  static const String sendPodNameSSC = 'SEND_POD_NAME_SSC';
  static const String reconnect = 'reconnect_CSS';
  static const String destroy = 'destroy';
}
