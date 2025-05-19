class Endpoints {
  // Auth
  static const String auth = 'auth';
  static const String presignedUrlS3 = 'auth/presigned-url';

  // Users
  static const String users = 'users';
  static const String username = 'users/username';
  static const String searchUsers = 'users/search';

  // Room
  static const String rooms = 'meetings';
  static const String joinWithPassword = 'meetings/join/password';
  static const String joinWithoutPassword = 'meetings/join';
  static const String roomChat = 'meetings/conversations';
  static const String archivedConversations = 'meetings/conversations/archived';
  static const String roomMembers = 'meetings/members';
  static const String archivedMeeeting = 'meetings/archived';
  static const String acceptInvite = 'meetings/members/accept';

  // Chats
  static const String chats = 'chats';
  static const String chatsConversations = 'chats/conversations';
}
