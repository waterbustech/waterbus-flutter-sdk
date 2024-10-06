class ApiEndpoints {
  // Auth
  static const String auth = 'auth';
  static const String presignedUrlS3 = 'auth/presigned-url';

  // Users
  static const String users = 'users';
  static const String username = 'users/username';
  static const String searchUsers = 'users/search';

  // Meetings
  static const String meetings = 'meetings';
  static const String joinWithPassword = 'meetings/join/password';
  static const String joinWithoutPassword = 'meetings/join';
  static const String meetingConversations = 'meetings/conversations';
  static const String meetingMembers = 'meetings/members';
  static const String acceptInvite = 'meetings/members/accept';
  static const String startRecord = 'meetings/record/start';
  static const String stopRecord = 'meetings/record/stop';

  // Chats
  static const String chats = 'chats';
  static const String chatsConversations = 'chats/conversations';
}
