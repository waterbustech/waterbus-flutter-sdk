import 'dart:typed_data';

import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';
import 'package:waterbus_sdk/types/enums/draw_action.dart';
import 'package:waterbus_sdk/types/models/draw_model.dart';

abstract class WaterbusSdkInterface {
  Future<void> initializeApp();

  // Auth
  Future<User?> createToken({required AuthPayloadModel payload});
  Future<bool> deleteToken();
  Future<bool> refreshToken();

  // User
  Future<User?> getProfile();
  Future<User?> updateProfile({required User user});
  Future<bool> updateUsername({required String username});
  Future<bool> checkUsername({required String username});
  Future<String?> getPresignedUrl();
  Future<String?> uploadAvatar({
    required Uint8List image,
    required String uploadUrl,
  });
  Future<List<User>> searchUsers({
    required String keyword,
    required int skip,
    required int limit,
  });

  // Chat
  Future<List<Meeting>> getConversations({
    int status = 2,
    int limit = 10,
    required int skip,
  });
  Future<bool> deleteConversation(int conversationId);
  Future<Meeting?> leaveConversation({required int code});
  Future<Meeting?> addMember({required int code, required int userId});
  Future<Meeting?> deleteMember({required int code, required int userId});
  Future<Meeting?> acceptInvite({required int code});

  // Messages
  Future<List<MessageModel>> getMessageByRoom({
    required int skip,
    required int meetingId,
    int limit = 10,
  });

  Future<MessageModel?> sendMessage({
    required int meetingId,
    required String data,
  });
  Future<MessageModel?> editMessage({
    required int messageId,
    required String data,
  });
  Future<MessageModel?> deleteMessage({required int messageId});

  // Meeting
  Future<Meeting?> createRoom({
    required Meeting meeting,
    required String password,
    required int? userId,
  });
  Future<Meeting?> updateRoom({
    required Meeting meeting,
    required String password,
    required int? userId,
  });
  Future<Meeting?> joinRoom({
    required Meeting meeting,
    required String password,
    required int? userId,
  });
  Future<Meeting?> getRoomInfo(int code);
  Future<void> leaveRoom();

  // white board
  Future<void> startWhiteBoard();
  Future<void> updateWhiteBoard(
    DrawModel draw,
    DrawActionEnum action,
  );
  Future<void> cleanWhiteBoard();
  Future<void> undoWhiteBoard();
  Future<void> redoWhiteBoard();

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
