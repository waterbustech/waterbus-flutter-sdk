class Endpoints {
  // Auth
  static const String auth = 'auth';
  static const String presignedUrlS3 = 'auth/presigned-url';

  // Users
  static const String users = 'users';
  static const String username = 'users/username';
  static const String searchUsers = 'users/search';

  // Room
  static const String rooms = 'rooms';
  static const String join = 'join';
  static const String members = 'members';
  static const String inactive = 'rooms/inactive';
  static const String deactivate = 'deactivate';

  // Chats
  static const String chats = 'chats';
  static const String conversations = 'conversations';
}
