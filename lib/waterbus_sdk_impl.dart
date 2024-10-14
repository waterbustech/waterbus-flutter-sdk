import 'dart:typed_data';

import 'package:injectable/injectable.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import 'package:waterbus_sdk/core/api/auth/repositories/auth_repository.dart';
import 'package:waterbus_sdk/core/api/base/base_remote_data.dart';
import 'package:waterbus_sdk/core/api/chat/repositories/chat_repository.dart';
import 'package:waterbus_sdk/core/api/meetings/repositories/meeting_repository.dart';
import 'package:waterbus_sdk/core/api/messages/repositories/message_repository.dart';
import 'package:waterbus_sdk/core/api/user/repositories/user_repository.dart';
import 'package:waterbus_sdk/core/webrtc/webrtc_interface.dart';
import 'package:waterbus_sdk/core/websocket/interfaces/socket_emiter_interface.dart';
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
  final SocketEmiter _socketEmiter;
  final WaterbusWebRTCManager _rtcManager;
  final ReplayKitChannel _replayKitChannel;
  final BaseRemoteData _baseRepository;
  final AuthRepository _authRepository;
  final MeetingRepository _meetingRepository;
  final UserRepository _userRepository;
  final ChatRepository _chatRepository;
  final MessageRepository _messageRepository;
  final WaterbusLogger _logger;

  SdkCore(
    this._webSocket,
    this._socketEmiter,
    this._rtcManager,
    this._replayKitChannel,
    this._baseRepository,
    this._authRepository,
    this._meetingRepository,
    this._userRepository,
    this._chatRepository,
    this._messageRepository,
    this._logger,
  );

  @override
  Future<void> initializeApp() async {
    await _baseRepository.initialize();

    _webSocket.establishConnection(forceConnection: true);

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
    return await _meetingRepository.createMeeting(
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
    if (!_webSocket.isConnected) return null;

    late final Meeting? room;

    if (password.isEmpty) {
      room = await _meetingRepository.joinMeetingWithoutPassword(
        CreateMeetingParams(
          meeting: meeting,
          password: password,
          userId: userId,
        ),
      );
    } else {
      room = await _meetingRepository.joinMeetingWithPassword(
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
    return await _meetingRepository.updateMeeting(
      CreateMeetingParams(
        meeting: meeting,
        password: password,
        userId: userId,
      ),
    );
  }

  @override
  Future<Meeting?> getRoomInfo(int code) async {
    return await _meetingRepository.getInfoMeeting(code);
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
  Future<void> reconnect() async {
    _socketEmiter.reconnect();
    _webSocket.reconnect(
      callbackConnected: () async {
        await _rtcManager.reconnect();
      },
    );
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
  void setSubscribeSubtitle(bool isEnabled) {
    _socketEmiter.setSubtitle(isEnabled);
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

  // Chat
  @override
  Future<bool> deleteConversation(int conversationId) async {
    return await _chatRepository.deleteConversation(conversationId);
  }

  @override
  Future<List<Meeting>> getConversations({
    required int skip,
    int limit = 10,
    int status = 2,
  }) async {
    return await _chatRepository.getConversations(
      status: status,
      limit: limit,
      skip: skip,
    );
  }

  @override
  Future<bool> updateConversation({required Meeting meeting}) async {
    return await _chatRepository.updateConversation(meeting: meeting);
  }

  @override
  Future<Meeting?> acceptInvite({required int code}) async {
    return await _chatRepository.acceptInvite(code: code);
  }

  @override
  Future<Meeting?> addMember({required int code, required int userId}) async {
    return await _chatRepository.addMember(code: code, userId: userId);
  }

  @override
  Future<Meeting?> leaveConversation({required int code}) async {
    return await _chatRepository.leaveConversation(code: code);
  }

  @override
  Future<Meeting?> deleteMember({
    required int code,
    required int userId,
  }) async {
    return await _chatRepository.deleteMember(code: code, userId: userId);
  }

  // Messages
  @override
  Future<List<MessageModel>> getMessageByRoom({
    required int meetingId,
    required int skip,
    int limit = 10,
  }) async {
    return await _messageRepository.getMessageByRoom(
      meetingId: meetingId,
      limit: limit,
      skip: skip,
    );
  }

  @override
  Future<MessageModel?> sendMessage({
    required int meetingId,
    required String data,
  }) async {
    return await _messageRepository.sendMessage(
      meetingId: meetingId,
      data: data,
    );
  }

  @override
  Future<MessageModel?> editMessage({
    required int messageId,
    required String data,
  }) async {
    return await _messageRepository.editMessage(
      messageId: messageId,
      data: data,
    );
  }

  @override
  Future<MessageModel?> deleteMessage({required int messageId}) async {
    return await _messageRepository.deleteMessage(messageId: messageId);
  }

  // User
  @override
  Future<User?> getProfile() async {
    return await _userRepository.getUserProfile();
  }

  @override
  Future<User?> updateProfile({required User user}) async {
    return await _userRepository.updateUserProfile(user);
  }

  @override
  Future<bool> updateUsername({
    required String username,
  }) async {
    return await _userRepository.updateUsername(username);
  }

  @override
  Future<bool> checkUsername({
    required String username,
  }) async {
    return await _userRepository.checkUsername(username);
  }

  @override
  Future<String?> getPresignedUrl() async {
    return await _userRepository.getPresignedUrl();
  }

  @override
  Future<String?> uploadAvatar({
    required Uint8List image,
    required String uploadUrl,
  }) async {
    return await _userRepository.uploadImageToS3(
      image: image,
      uploadUrl: uploadUrl,
    );
  }

  @override
  Future<List<User>> searchUsers({
    required String keyword,
    required int skip,
    required int limit,
  }) async {
    return await _userRepository.searchUsers(
      keyword: keyword,
      skip: skip,
      limit: limit,
    );
  }

  // Auth
  @override
  Future<User?> createToken({required AuthPayloadModel payload}) async {
    final User? user = await _authRepository.loginWithSocial(payload);

    if (user != null) {
      _webSocket.establishConnection(forceConnection: true);
    }

    return user;
  }

  @override
  Future<bool> deleteToken() async {
    _webSocket.disconnection();

    return await _authRepository.logOut();
  }

  @override
  Future<bool> refreshToken() async {
    return await _authRepository.refreshToken();
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
