import 'dart:typed_data';

import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';

abstract class WaterbusSdkInterface {
  Future<void> initializeApp();

  // Auth
  Future<Result<User>> createToken({required AuthPayloadModel payload});
  Future<Result<bool>> deleteToken();
  Future<Result<bool>> refreshToken();

  // User
  Future<Result<User>> getProfile();
  Future<Result<bool>> updateProfile({required User user});
  Future<Result<bool>> updateUsername({required String username});
  Future<Result<bool>> checkUsername({required String username});
  Future<Result<String>> getPresignedUrl();
  Future<Result<String>> uploadAvatar({
    required Uint8List image,
    required String uploadUrl,
  });
  Future<Result<List<User>>> searchUsers({
    required String keyword,
    required int skip,
    required int limit,
  });

  // Chat
  Future<Result<List<Meeting>>> getConversations({
    int status = 2,
    int limit = 10,
    required int skip,
  });
  Future<Result<List<Meeting>>> getArchivedConversations({
    int limit = 10,
    required int skip,
  });
  Future<Result<bool>> updateConversation({
    required Meeting meeting,
    String? password,
  });
  Future<Result<bool>> deleteConversation(int conversationId);
  Future<Result<Meeting>> leaveConversation({required int code});
  Future<Result<Meeting>> addMember({required int code, required int userId});
  Future<Result<Meeting>> deleteMember({
    required int code,
    required int userId,
  });
  Future<Result<Meeting>> acceptInvite({required int meetingId});
  Future<Result<Meeting>> archivedConversation({required int code});

  // Messages
  Future<Result<List<MessageModel>>> getMessageByRoom({
    required int skip,
    required int meetingId,
    int limit = 10,
  });
  Future<Result<MessageModel?>> sendMessage({
    required int meetingId,
    required String data,
  });
  Future<Result<MessageModel>> editMessage({
    required int messageId,
    required String data,
  });
  Future<Result<MessageModel>> deleteMessage({required int messageId});

  // Meeting
  Future<Result<Meeting>> createRoom({
    required Meeting meeting,
    required String password,
    required int? userId,
  });
  Future<Result<bool>> updateRoom({
    required Meeting meeting,
    required String password,
    required int? userId,
  });
  Future<Result<Meeting>> joinRoom({
    required Meeting meeting,
    required String password,
    required int? userId,
  });
  Future<Result<Meeting>> getRoomInfo(int code);
  Future<Result<List<RecordModel>>> getRecords({
    required int skip,
    required int limit,
  });
  Future<Result<int>> startRecord();
  Future<Result<bool>> stopRecord();
  Future<void> leaveRoom();
  void toggleRaiseHand();

  // WebRTC
  Future<void> reconnect();
  Future<void> prepareMedia();
  Future<void> changeCallSettings(CallSetting setting);
  Future<void> switchCamera();
  Future<void> toggleVideo();
  Future<void> toggleAudio();
  Future<void> toggleSpeakerPhone();
  void setSubscribeSubtitle(bool isEnabled);
  Future<void> startScreenSharing({DesktopCapturerSource? source});
  Future<void> stopScreenSharing();
  Future<void> enableVirtualBackground({
    required Uint8List backgroundImage,
    double thresholdConfidence = 0.7,
  });
  Future<void> disableVirtualBackground();
  Future<void> setPiPEnabled({required String textureId, bool enabled = true});

  CallState get callState;
}
