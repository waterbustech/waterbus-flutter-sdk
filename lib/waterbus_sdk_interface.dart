// Dart imports:
import 'dart:typed_data';

// Project imports:
import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';

abstract class WaterbusSdkInterface {
  void initialize();

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

  // WebRTC
  Future<void> prepareMedia();
  Future<void> changeCallSettings(CallSetting setting);
  Future<void> switchCamera();
  Future<void> toggleVideo();
  Future<void> toggleAudio();
  Future<void> toggleSpeakerPhone();
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
