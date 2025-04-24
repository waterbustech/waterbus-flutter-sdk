import 'package:flutter/foundation.dart';

import 'package:injectable/injectable.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import 'package:waterbus_sdk/core/api/auth/repositories/auth_repository.dart';
import 'package:waterbus_sdk/core/api/base/base_remote_data.dart';
import 'package:waterbus_sdk/core/api/chat/repositories/chat_repository.dart';
import 'package:waterbus_sdk/core/api/meetings/repositories/meeting_repository.dart';
import 'package:waterbus_sdk/core/api/messages/repositories/message_repository.dart';
import 'package:waterbus_sdk/core/api/user/repositories/user_repository.dart';
import 'package:waterbus_sdk/core/webrtc/webrtc_manager.dart';
import 'package:waterbus_sdk/core/websocket/interfaces/ws_emitter.dart';
import 'package:waterbus_sdk/core/websocket/interfaces/ws_handler.dart';
import 'package:waterbus_sdk/core/whiteboard/white_board_interfaces.dart';
import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';
import 'package:waterbus_sdk/native/picture-in-picture/index.dart';
import 'package:waterbus_sdk/native/replaykit.dart';
import 'package:waterbus_sdk/types/enums/draw_action.dart';
import 'package:waterbus_sdk/types/error/failures.dart';
import 'package:waterbus_sdk/types/models/create_meeting_params.dart';
import 'package:waterbus_sdk/types/models/draw_model.dart';
import 'package:waterbus_sdk/types/models/record_model.dart';
import 'package:waterbus_sdk/types/result.dart';
import 'package:waterbus_sdk/utils/logger/logger.dart';
import 'package:waterbus_sdk/utils/replaykit/replaykit_helper.dart';
import 'package:waterbus_sdk/waterbus_sdk_interface.dart';

@Singleton(as: WaterbusSdkInterface)
class SdkCore extends WaterbusSdkInterface {
  final WsHandler _wsHandler;
  final WsEmitter _wsEmitter;
  final WhiteBoardManager _whiteBoardManager;
  final WebRTCManager _rtcManager;
  final ReplayKitChannel _replayKitChannel;
  final BaseRemoteData _baseRepository;
  final AuthRepository _authRepository;
  final MeetingRepository _meetingRepository;
  final UserRepository _userRepository;
  final ChatRepository _chatRepository;
  final MessageRepository _messageRepository;
  final WaterbusLogger _logger;

  SdkCore(
    this._wsHandler,
    this._wsEmitter,
    this._whiteBoardManager,
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

    _wsHandler.establishConnection(forceConnection: true);

    _rtcManager.notifyChanged.listen((event) {
      WaterbusSdk.listener.onEventChanged?.call(event);
    });
  }

  // Meeting
  @override
  Future<Result<Meeting>> createRoom({
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
  Future<Result<Meeting>> joinRoom({
    required Meeting meeting,
    required String password,
    required int? userId,
  }) async {
    if (!_wsHandler.isConnected) return Result.failure(ServerFailure());

    late final Result<Meeting> room;

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

    if (room.isSuccess) {
      final Meeting? meeting = room.value;

      if (meeting == null) return Result.failure(room.error ?? ServerFailure());

      final int mParticipantIndex = meeting.participants.lastIndexWhere(
        (participant) => participant.isMe,
      );

      if (mParticipantIndex < 0) return Result.failure(ServerFailure());

      await _joinRoom(
        roomId: meeting.code.toString(),
        participantId: meeting.participants[mParticipantIndex].id,
      );

      final List<String> targetIds = meeting.participants
          .where((participant) => !participant.isMe)
          .map((participant) => participant.id.toString())
          .toList();

      _subscribe(targetIds);

      return Result.success(meeting);
    } else {
      return Result.failure(room.error ?? ServerFailure());
    }
  }

  @override
  Future<Result<bool>> updateRoom({
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
  Future<Result<Meeting>> getRoomInfo(int code) async {
    return await _meetingRepository.getInfoMeeting(code);
  }

  @override
  Future<Result<List<RecordModel>>> getRecords({
    required int skip,
    required int limit,
  }) async {
    return await _meetingRepository.getRecords(skip: skip, limit: limit);
  }

  @override
  Future<Result<int>> startRecord() async {
    final String? meetingId = _rtcManager.roomId;

    if (meetingId == null) return Result.failure(ServerFailure());

    return await _meetingRepository.startRecord(int.parse(meetingId));
  }

  @override
  Future<Result<bool>> stopRecord() async {
    final String? meetingId = _rtcManager.roomId;

    if (meetingId == null) return Result.failure(ServerFailure());

    return await _meetingRepository.stopRecord(int.parse(meetingId));
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
  Future<void> startWhiteBoard() async {
    _whiteBoardManager.startWhiteBoard();
  }

  @override
  Future<void> updateWhiteBoard(
    DrawModel draw,
    DrawActionEnum action,
  ) async {
    _whiteBoardManager.updateWhiteBoard(draw, action);
  }

  @override
  Future<void> cleanWhiteBoard() async {
    _whiteBoardManager.cleanWhiteBoard();
  }

  @override
  Future<void> undoWhiteBoard() async {
    _whiteBoardManager.undoWhiteBoard();
  }

  @override
  Future<void> redoWhiteBoard() async {
    _whiteBoardManager.redoWhiteBoard();
  }

  @override
  Future<void> reconnect() async {
    _wsEmitter.reconnect();
    _wsHandler.reconnect(
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
    await _rtcManager.applySettings(setting);
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
  void toggleRaiseHand() {
    _rtcManager.toggleRaiseHand();
  }

  @override
  Future<void> toggleSpeakerPhone() async {
    await _rtcManager.toggleSpeakerPhone();
  }

  @override
  void setSubscribeSubtitle(bool isEnabled) {
    _wsEmitter.setSubtitle(isEnabled);
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
  Future<Result<bool>> deleteConversation(int conversationId) async {
    return await _chatRepository.deleteConversation(conversationId);
  }

  @override
  Future<Result<List<Meeting>>> getConversations({
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
  Future<Result<List<Meeting>>> getArchivedConversations({
    int limit = 10,
    required int skip,
  }) async {
    return await _chatRepository.getArchivedConversations(
      limit: limit,
      skip: skip,
    );
  }

  @override
  Future<Result<bool>> updateConversation({
    required Meeting meeting,
    String? password,
  }) async {
    return await _chatRepository.updateConversation(
      meeting: meeting,
      password: password,
    );
  }

  @override
  Future<Result<Meeting>> acceptInvite({required int meetingId}) async {
    return await _chatRepository.acceptInvite(meetingId: meetingId);
  }

  @override
  Future<Result<Meeting>> addMember({
    required int code,
    required int userId,
  }) async {
    return await _chatRepository.addMember(code: code, userId: userId);
  }

  @override
  Future<Result<Meeting>> leaveConversation({required int code}) async {
    return await _chatRepository.leaveConversation(code: code);
  }

  @override
  Future<Result<Meeting>> archivedConversation({required int code}) async {
    return await _chatRepository.archivedConversation(code: code);
  }

  @override
  Future<Result<Meeting>> deleteMember({
    required int code,
    required int userId,
  }) async {
    return await _chatRepository.deleteMember(code: code, userId: userId);
  }

  // Messages
  @override
  Future<Result<List<MessageModel>>> getMessageByRoom({
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
  Future<Result<MessageModel>> sendMessage({
    required int meetingId,
    required String data,
  }) async {
    return await _messageRepository.sendMessage(
      meetingId: meetingId,
      data: data,
    );
  }

  @override
  Future<Result<MessageModel>> editMessage({
    required int messageId,
    required String data,
  }) async {
    return await _messageRepository.editMessage(
      messageId: messageId,
      data: data,
    );
  }

  @override
  Future<Result<MessageModel>> deleteMessage({required int messageId}) async {
    return await _messageRepository.deleteMessage(messageId: messageId);
  }

  // User
  @override
  Future<Result<User>> getProfile() async {
    return await _userRepository.getUserProfile();
  }

  @override
  Future<Result<bool>> updateProfile({required User user}) async {
    return await _userRepository.updateUserProfile(user);
  }

  @override
  Future<Result<bool>> updateUsername({
    required String username,
  }) async {
    return await _userRepository.updateUsername(username);
  }

  @override
  Future<Result<bool>> checkUsername({
    required String username,
  }) async {
    return await _userRepository.checkUsername(username);
  }

  @override
  Future<Result<String>> getPresignedUrl() async {
    return await _userRepository.getPresignedUrl();
  }

  @override
  Future<Result<String>> uploadAvatar({
    required Uint8List image,
    required String uploadUrl,
  }) async {
    return await _userRepository.uploadImageToS3(
      image: image,
      uploadUrl: uploadUrl,
    );
  }

  @override
  Future<Result<List<User>>> searchUsers({
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
  Future<Result<User>> createToken({required AuthPayloadModel payload}) async {
    final Result<User> user = await _authRepository.loginWithSocial(payload);

    if (user.isSuccess) {
      _wsHandler.establishConnection(forceConnection: true);
    }

    return user;
  }

  @override
  Future<Result<bool>> deleteToken() async {
    _wsHandler.disconnection();

    return await _authRepository.logOut();
  }

  @override
  Future<Result<bool>> refreshToken() async {
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
