import 'dart:typed_data';

import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';
import 'package:waterbus_sdk/types/externals/models/join_room_params.dart';

abstract class WaterbusSdkInterface {
  Future<void> initializeApp();

  // Auth
  Future<Result<User>> createToken({
    required AuthPayload payload,
    Function()? callbackConnected,
  });
  Future<Result<bool>> deleteToken();
  Future<Result<bool>> renewToken();

  // User
  Future<Result<User>> getProfile();
  Future<Result<bool>> updateProfile({required User user});
  Future<Result<bool>> updateUsername({required String username});
  Future<Result<bool>> checkUsername({required String username});
  Future<Result<PresignedUrl>> getPresignedUrl();
  Future<Result<String>> uploadAvatar({
    required Uint8List image,
    required String presignedUrl,
    required String sourceUrl,
  });

  // Chat
  Future<Result<List<Room>>> getConversations({
    int limit = 10,
    required int skip,
  });
  Future<Result<List<Room>>> getArchivedConversations({
    int limit = 10,
    required int skip,
  });
  Future<Result<bool>> updateConversation({
    required Room room,
    String? password,
  });
  Future<Result<bool>> deleteConversation(int conversationId);
  Future<Result<Room>> leaveConversation({required int roomId});
  Future<Result<Room>> addMember({required int roomId, required int userId});
  Future<Result<Room>> deleteMember({
    required int roomId,
    required int userId,
  });
  Future<Result<Room>> archivedConversation({required int roomId});

  // Messages
  Future<Result<List<Message>>> getMessageByRoom({
    required int skip,
    required int roomId,
    int limit = 10,
  });
  Future<Result<Message?>> sendMessage({
    required int roomId,
    required String data,
  });
  Future<Result<Message>> editMessage({
    required int messageId,
    required String data,
  });
  Future<Result<Message>> deleteMessage({required int messageId});

  // Room
  Future<Result<Room>> createRoom({required RoomParams params});
  Future<Result<bool>> updateRoom({required RoomParams params});
  Future<Result<Room>> joinRoom({required JoinRoomParams params});
  Future<Result<Room>> getRoomInfo(String code);
  Future<void> leaveRoom();
  void toggleRaiseHand();

  // WebRTC
  Future<void> reconnect();
  Future<void> prepareMedia();
  Future<void> updateMediaConfig(MediaConfig setting);
  Future<void> switchCamera();
  Future<void> toggleVideo();
  Future<void> toggleAudio();
  Future<void> toggleSpeakerPhone();
  Future<void> changeAudioInputDevice({required String deviceId});
  Future<void> changeVideoInputDevice({required String deviceId});
  void setSubscribeSubtitle(bool isEnabled);
  Future<void> startScreenSharing({DesktopCapturerSource? source});
  Future<void> stopScreenSharing();
  Future<void> enableVirtualBg({
    required Uint8List backgroundImage,
    double thresholdConfidence = 0.7,
  });
  Future<void> disableVirtualBg();
  Future<void> setPiPEnabled({required String textureId, bool enabled = true});

  CallState get callState;
}
