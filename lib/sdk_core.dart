// Dart imports:
import 'dart:typed_data';

// Package imports:
import 'package:injectable/injectable.dart';
import 'package:wakelock/wakelock.dart';

// Project imports:
import 'package:waterbus_sdk/core/api/auth/repositories/auth_repository.dart';
import 'package:waterbus_sdk/core/api/meetings/repositories/meeting_repository.dart';
import 'package:waterbus_sdk/core/api/user/repositories/user_repository.dart';
import 'package:waterbus_sdk/core/webrtc/webrtc_interface.dart';
import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';
import 'package:waterbus_sdk/native/picture-in-picture/index.dart';
import 'package:waterbus_sdk/native/replaykit.dart';
import 'package:waterbus_sdk/types/models/auth_payload_model.dart';
import 'package:waterbus_sdk/types/models/create_meeting_params.dart';
import 'package:waterbus_sdk/utils/logger/logger.dart';
import 'package:waterbus_sdk/utils/replaykit/replaykit_helper.dart';

@Singleton()
class SdkCore {
  final WaterbusWebRTCManager _rtcManager;
  final ReplayKitChannel _replayKitChannel;
  final WaterbusLogger _logger;
  final AuthRepository _authRemoteDataSourceImpl;
  final MeetingRepository _meetingRemoteDataSourceImpl;
  final UserRepository _userRemoteDataSourceImpl;
  SdkCore(
    this._rtcManager,
    this._replayKitChannel,
    this._logger,
    this._authRemoteDataSourceImpl,
    this._meetingRemoteDataSourceImpl,
    this._userRemoteDataSourceImpl,
  );

  bool _isListened = false;

  Future<void> joinRoom({
    required String roomId,
    required int participantId,
  }) async {
    try {
      if (!_isListened) {
        _isListened = true;
        _rtcManager.notifyChanged.listen((event) {
          WaterbusSdk.onEventChanged?.call(event);
        });
      }

      Wakelock.enable();

      await _rtcManager.joinRoom(
        roomId: roomId,
        participantId: participantId,
      );
    } catch (error) {
      _logger.bug(error.toString());
    }
  }

  Future<void> subscribe(List<String> targetIds) async {
    try {
      _rtcManager.subscribe(targetIds);
    } catch (error) {
      _logger.bug(error.toString());
    }
  }

  Future<void> leaveRoom() async {
    try {
      await _rtcManager.dispose();
      Wakelock.disable();
    } catch (error) {
      _logger.bug(error.toString());
    }
  }

  Future<void> prepareMedia() async {
    await _rtcManager.prepareMedia();
  }

  Future<void> changeCallSettings(CallSetting setting) async {
    await _rtcManager.applyCallSettings(setting);
  }

  Future<void> switchCamera() async {
    await _rtcManager.switchCamera();
  }

  Future<void> toggleVideo() async {
    await _rtcManager.toggleVideo();
  }

  Future<void> toggleAudio() async {
    await _rtcManager.toggleAudio();
  }

  Future<void> toggleSpeakerPhone() async {
    await _rtcManager.toggleSpeakerPhone();
  }

  Future<void> startScreenSharing({DesktopCapturerSource? source}) async {
    if (WebRTC.platformIsIOS) {
      ReplayKitHelper().openReplayKit();
      _replayKitChannel.startReplayKit();
      _replayKitChannel.listenEvents(_rtcManager);
    } else {
      await _rtcManager.startScreenSharing(source: source);
    }
  }

  Future<void> stopScreenSharing() async {
    try {
      if (WebRTC.platformIsIOS) {
        ReplayKitHelper().openReplayKit();
      } else {
        await _rtcManager.stopScreenSharing();
      }
    } catch (error) {
      _logger.bug(error.toString());
    }
  }

  Future<void> enableVirtualBackground({
    required Uint8List backgroundImage,
    double thresholdConfidence = 0.7,
  }) async {
    await _rtcManager.enableVirtualBackground(
      backgroundImage: backgroundImage,
      thresholdConfidence: thresholdConfidence,
    );
  }

  Future<void> disableVirtualBackground() async {
    await _rtcManager.disableVirtualBackground();
  }

  Future<void> setPiPEnabled({
    required String textureId,
    bool enabled = true,
  }) async {
    await setPictureInPictureEnabled(textureId: textureId);
  }

  // User
  Future<User?> getProfile() async {
    return await _userRemoteDataSourceImpl.getUserProfile();
  }

  Future<User?> updateProfile({required User user}) async {
    return await _userRemoteDataSourceImpl.updateUserProfile(user);
  }

  Future<bool> updateUsername({
    required String username,
  }) async {
    return await _userRemoteDataSourceImpl.updateUsername(username);
  }

  Future<bool> checkUsername({
    required String username,
  }) async {
    return await _userRemoteDataSourceImpl.checkUsername(username);
  }

  Future<String?> getPresignedUrl() async {
    return await _userRemoteDataSourceImpl.getPresignedUrl();
  }

  Future<String?> uploadAvatar({
    required Uint8List image,
    required String uploadUrl,
  }) async {
    return await _userRemoteDataSourceImpl.uploadImageToS3(
      image: image,
      uploadUrl: uploadUrl,
    );
  }

  // Auth
  Future<User?> loginWithSocial({
    required AuthPayloadModel payloadModel,
  }) async {
    return await _authRemoteDataSourceImpl.loginWithSocial(payloadModel);
  }

  Future<bool> logOut() async {
    return await _authRemoteDataSourceImpl.logOut();
  }

  Future<bool> handleRefreshToken() async {
    return await _authRemoteDataSourceImpl.refreshToken();
  }

  // Meeting
  Future<Meeting?> createMeeting({
    required Meeting meeting,
    required String password,
    required int? userId,
  }) async {
    return await _meetingRemoteDataSourceImpl.createMeeting(
      CreateMeetingParams(
        meeting: meeting,
        password: password,
        userId: userId,
      ),
    );
  }

  Future<Meeting?> joinMeeting({
    required Meeting meeting,
    required String password,
    required int? userId,
  }) async {
    late final Meeting? response;

    if (password.isEmpty) {
      response = await _meetingRemoteDataSourceImpl.joinMeetingWithoutPassword(
        CreateMeetingParams(
          meeting: meeting,
          password: password,
          userId: userId,
        ),
      );
    } else {
      response = await _meetingRemoteDataSourceImpl.joinMeetingWithPassword(
        CreateMeetingParams(
          meeting: meeting,
          password: password,
          userId: userId,
        ),
      );
    }

    return response;
  }

  Future<Meeting?> updateMeeting({
    required Meeting meeting,
    required String password,
    required int? userId,
  }) async {
    return await _meetingRemoteDataSourceImpl.updateMeeting(
      CreateMeetingParams(
        meeting: meeting,
        password: password,
        userId: userId,
      ),
    );
  }

  Future<Meeting?> getInfoMeeting({required int code}) async {
    return await _meetingRemoteDataSourceImpl.getInfoMeeting(code);
  }

  CallState get callState => _rtcManager.callState();
}
