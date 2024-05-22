import 'dart:typed_data';

import 'package:injectable/injectable.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import 'package:waterbus_sdk/core/api/auth/repositories/auth_repository.dart';
import 'package:waterbus_sdk/core/api/meetings/repositories/meeting_repository.dart';
import 'package:waterbus_sdk/core/api/user/repositories/user_repository.dart';
import 'package:waterbus_sdk/core/webrtc/webrtc_interface.dart';
import 'package:waterbus_sdk/core/websocket/interfaces/socket_handler_interface.dart';
import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';
import 'package:waterbus_sdk/native/picture-in-picture/index.dart';
import 'package:waterbus_sdk/native/replaykit.dart';
import 'package:waterbus_sdk/types/models/create_meeting_params.dart';
import 'package:waterbus_sdk/utils/logger/logger.dart';
import 'package:waterbus_sdk/utils/replaykit/replaykit_helper.dart';
import 'package:waterbus_sdk/waterbus_sdk_interface.dart';

@Singleton(as: WaterbusSdkInterface)
class SdkCore extends WaterbusSdkInterface {
  final SocketHandler _webSocket;
  final WaterbusWebRTCManager _rtcManager;
  final ReplayKitChannel _replayKitChannel;
  final WaterbusLogger _logger;
  final AuthRepository _authRemoteDataSourceImpl;
  final MeetingRepository _meetingRemoteDataSourceImpl;
  final UserRepository _userRemoteDataSourceImpl;
  SdkCore(
    this._webSocket,
    this._rtcManager,
    this._replayKitChannel,
    this._logger,
    this._authRemoteDataSourceImpl,
    this._meetingRemoteDataSourceImpl,
    this._userRemoteDataSourceImpl,
  );

  @override
  void initialize() {
    _rtcManager.notifyChanged.listen((event) {
      WaterbusSdk.onEventChanged?.call(event);
    });
  }

  // Meeting
  @override
  Future<Meeting?> createRoom({
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

  @override
  Future<Meeting?> joinRoom({
    required Meeting meeting,
    required String password,
    required int? userId,
  }) async {
    if (!(_webSocket.socket?.connected ?? false)) return null;

    late final Meeting? room;

    if (password.isEmpty) {
      room = await _meetingRemoteDataSourceImpl.joinMeetingWithoutPassword(
        CreateMeetingParams(
          meeting: meeting,
          password: password,
          userId: userId,
        ),
      );
    } else {
      room = await _meetingRemoteDataSourceImpl.joinMeetingWithPassword(
        CreateMeetingParams(
          meeting: meeting,
          password: password,
          userId: userId,
        ),
      );
    }

    if (room != null) {
      final int mParticipantIndex = room.participants.lastIndexWhere(
        (participant) => participant.isMe,
      );

      if (mParticipantIndex < 0) return null;

      await _joinRoom(
        roomId: room.code.toString(),
        participantId: room.participants[mParticipantIndex].id,
      );

      final List<String> targetIds = room.participants
          .where((participant) => !participant.isMe)
          .map((participant) => participant.id.toString())
          .toList();

      _subscribe(targetIds);
    }

    return room;
  }

  @override
  Future<Meeting?> updateRoom({
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

  @override
  Future<Meeting?> getRoomInfo(int code) async {
    return await _meetingRemoteDataSourceImpl.getInfoMeeting(code);
  }

  @override
  Future<void> leaveRoom() async {
    try {
      await _rtcManager.dispose();
      WakelockPlus.disable();
    } catch (error) {
      _logger.bug(error.toString());
    }
  }

  @override
  Future<void> prepareMedia() async {
    await _rtcManager.prepareMedia();
  }

  @override
  Future<void> changeCallSettings(CallSetting setting) async {
    await _rtcManager.applyCallSettings(setting);
  }

  @override
  Future<void> switchCamera() async {
    await _rtcManager.switchCamera();
  }

  @override
  Future<void> toggleVideo() async {
    await _rtcManager.toggleVideo();
  }

  @override
  Future<void> toggleAudio() async {
    await _rtcManager.toggleAudio();
  }

  @override
  Future<void> toggleSpeakerPhone() async {
    await _rtcManager.toggleSpeakerPhone();
  }

  @override
  Future<void> startScreenSharing({DesktopCapturerSource? source}) async {
    if (WebRTC.platformIsIOS) {
      ReplayKitHelper().openReplayKit();
      _replayKitChannel.startReplayKit();
      _replayKitChannel.listenEvents(_rtcManager);
    } else {
      await _rtcManager.startScreenSharing(source: source);
    }
  }

  @override
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

  @override
  Future<void> enableVirtualBackground({
    required Uint8List backgroundImage,
    double thresholdConfidence = 0.7,
  }) async {
    await _rtcManager.enableVirtualBackground(
      backgroundImage: backgroundImage,
      thresholdConfidence: thresholdConfidence,
    );
  }

  @override
  Future<void> disableVirtualBackground() async {
    await _rtcManager.disableVirtualBackground();
  }

  @override
  Future<void> setPiPEnabled({
    required String textureId,
    bool enabled = true,
  }) async {
    await setPictureInPictureEnabled(textureId: textureId);
  }

  // User

  @override
  Future<User?> getProfile() async {
    return await _userRemoteDataSourceImpl.getUserProfile();
  }

  @override
  Future<User?> updateProfile({required User user}) async {
    return await _userRemoteDataSourceImpl.updateUserProfile(user);
  }

  @override
  Future<bool> updateUsername({
    required String username,
  }) async {
    return await _userRemoteDataSourceImpl.updateUsername(username);
  }

  @override
  Future<bool> checkUsername({
    required String username,
  }) async {
    return await _userRemoteDataSourceImpl.checkUsername(username);
  }

  @override
  Future<String?> getPresignedUrl() async {
    return await _userRemoteDataSourceImpl.getPresignedUrl();
  }

  @override
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

  @override
  Future<User?> createToken({required AuthPayloadModel payload}) async {
    return await _authRemoteDataSourceImpl.loginWithSocial(payload);
  }

  @override
  Future<bool> deleteToken() async {
    return await _authRemoteDataSourceImpl.logOut();
  }

  @override
  Future<bool> refreshToken() async {
    return await _authRemoteDataSourceImpl.refreshToken();
  }

  // MARK: Private
  Future<void> _joinRoom({
    required String roomId,
    required int participantId,
  }) async {
    try {
      WakelockPlus.enable();

      await _rtcManager.joinRoom(
        roomId: roomId,
        participantId: participantId,
      );
    } catch (error) {
      _logger.bug(error.toString());
    }
  }

  Future<void> _subscribe(List<String> targetIds) async {
    try {
      _rtcManager.subscribe(targetIds);
    } catch (error) {
      _logger.bug(error.toString());
    }
  }

  @override
  CallState get callState => _rtcManager.callState();
}
