import 'package:flutter/foundation.dart';

import 'package:injectable/injectable.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import 'package:waterbus_sdk/core/api/auth/repositories/auth_repository.dart';
import 'package:waterbus_sdk/core/api/base/base_remote_data.dart';
import 'package:waterbus_sdk/core/api/chat/repositories/chat_repository.dart';
import 'package:waterbus_sdk/core/api/messages/repositories/message_repository.dart';
import 'package:waterbus_sdk/core/api/rooms/repositories/room_repository.dart';
import 'package:waterbus_sdk/core/api/user/repositories/user_repository.dart';
import 'package:waterbus_sdk/core/rtc/rtc_manager.dart';
import 'package:waterbus_sdk/core/ws/interfaces/ws_emitter.dart';
import 'package:waterbus_sdk/core/ws/interfaces/ws_handler.dart';
import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';
import 'package:waterbus_sdk/native/picture-in-picture/index.dart';
import 'package:waterbus_sdk/native/replaykit.dart';
import 'package:waterbus_sdk/utils/logger/logger.dart';
import 'package:waterbus_sdk/utils/replaykit/replaykit_helper.dart';
import 'package:waterbus_sdk/waterbus_sdk_interface.dart';

@Singleton(as: WaterbusSdkInterface)
class SdkCore extends WaterbusSdkInterface {
  final WsHandler _wsHandler;
  final WsEmitter _wsEmitter;
  final RtcManager _rtcManager;
  final ReplayKitChannel _replayKitChannel;
  final BaseRemoteData _baseRepository;
  final AuthRepository _authRepository;
  final RoomRepository _roomRepository;
  final UserRepository _userRepository;
  final ChatRepository _chatRepository;
  final MessageRepository _messageRepository;
  final WaterbusLogger _logger;

  SdkCore(
    this._wsHandler,
    this._wsEmitter,
    this._rtcManager,
    this._replayKitChannel,
    this._baseRepository,
    this._authRepository,
    this._roomRepository,
    this._userRepository,
    this._chatRepository,
    this._messageRepository,
    this._logger,
  );

  @override
  Future<void> initializeApp() async {
    await _baseRepository.initialize();

    _wsHandler.establishConnection(forceConnection: true);
  }

  // Room
  @override
  Future<Result<Room>> createRoom({required RoomParams params}) async {
    return await _roomRepository.createRoom(params);
  }

  @override
  Future<Result<Room>> joinRoom({required JoinRoomParams params}) async {
    final Result<Room> roomCurrent = await _roomRepository.joinRoom(params);

    if (roomCurrent.isSuccess) {
      final Room? room = roomCurrent.value;

      if (room == null) {
        return Result.failure(roomCurrent.error ?? ServerFailure());
      }

      final int mParticipantIndex = room.participants.lastIndexWhere(
        (participant) => participant.isMe,
      );

      if (mParticipantIndex < 0) return Result.failure(ServerFailure());

      final List<String> targetIds = room.participants
          .where((participant) => !participant.isMe)
          .map((participant) => participant.id.toString())
          .toList();

      if (!_wsHandler.isConnected) return Result.failure(ServerFailure());

      await _joinRoom(
        roomId: room.id.toString(),
        participantId: room.participants[mParticipantIndex].id,
        connectionType:
            targetIds.length <= 1 ? ConnectionType.p2p : ConnectionType.sfu,
      );

      _subscribe(targetIds);

      return Result.success(room);
    } else {
      return Result.failure(roomCurrent.error ?? ServerFailure());
    }
  }

  @override
  Future<Result<bool>> updateRoom({required RoomParams params}) async {
    return await _roomRepository.updateRoom(params);
  }

  @override
  Future<Result<Room>> getRoomInfo(String code) async {
    return await _roomRepository.getInfoRoom(code);
  }

  @override
  Future<void> leaveRoom() async {
    try {
      await _rtcManager.leaveRoom();
      WakelockPlus.disable();
    } catch (error) {
      _logger.bug(error.toString());
    }
  }

  @override
  Future<void> reconnect() async {
    // _wsEmitter.reconnect();
    _wsHandler.reconnect(
      callbackConnected: () async {
        await _rtcManager.reconnectRoom();
      },
    );
  }

  @override
  Future<void> prepareMedia() async {
    await _rtcManager.initializeMediaDevices();
  }

  @override
  Future<void> updateMediaConfig(MediaConfig setting) async {
    await _rtcManager.updateMediaConfig(setting);
  }

  @override
  Future<void> switchCamera() async {
    await _rtcManager.switchCameraInput();
  }

  @override
  Future<void> toggleVideo() async {
    await _rtcManager.toggleVideoInput();
  }

  @override
  Future<void> toggleAudio() async {
    await _rtcManager.toggleAudioInput();
  }

  @override
  Future<void> changeAudioInputDevice({required String deviceId}) async {
    await _rtcManager.changeAudioInputDevice(deviceId: deviceId);
  }

  @override
  Future<void> changeVideoInputDevice({required String deviceId}) async {
    await _rtcManager.changeVideoInputDevice(deviceId: deviceId);
  }

  @override
  void toggleRaiseHand() {
    _rtcManager.toggleHandRaise();
  }

  @override
  Future<void> toggleSpeakerPhone() async {
    await _rtcManager.toggleSpeakerOutput();
  }

  @override
  void setSubscribeSubtitle(bool isEnabled) {
    _wsEmitter.toggleSubtitle(isEnabled);
  }

  @override
  Future<void> startScreenSharing({DesktopCapturerSource? source}) async {
    if (WebRTC.platformIsIOS) {
      ReplayKitHelper().openReplayKit();
      _replayKitChannel.startReplayKit();
      _replayKitChannel.listenEvents(_rtcManager);
    } else {
      await _rtcManager.startScreenShare(source: source);
    }
  }

  @override
  Future<void> stopScreenSharing() async {
    try {
      if (WebRTC.platformIsIOS) {
        ReplayKitHelper().openReplayKit();
      } else {
        await _rtcManager.stopScreenShare();
      }
    } catch (error) {
      _logger.bug(error.toString());
    }
  }

  @override
  Future<void> enableVirtualBg({
    required Uint8List backgroundImage,
    double thresholdConfidence = 0.7,
  }) async {
    await _rtcManager.enableVirtualBg(
      backgroundImage: backgroundImage,
      thresholdConfidence: thresholdConfidence,
    );
  }

  @override
  Future<void> disableVirtualBg() async {
    await _rtcManager.disableVirtualBg();
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
  Future<Result<List<Room>>> getConversations({
    required int skip,
    int limit = 10,
  }) async {
    return await _chatRepository.getConversations(
      limit: limit,
      skip: skip,
    );
  }

  @override
  Future<Result<List<Room>>> getArchivedConversations({
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
    required Room room,
    String? password,
  }) async {
    return await _chatRepository.updateConversation(
      room: room,
      password: password,
    );
  }

  @override
  Future<Result<Room>> addMember({
    required int roomId,
    required int userId,
  }) async {
    return await _chatRepository.addMember(roomId: roomId, userId: userId);
  }

  @override
  Future<Result<Room>> leaveConversation({required int roomId}) async {
    return await _chatRepository.leaveConversation(roomId: roomId);
  }

  @override
  Future<Result<Room>> archivedConversation({required int roomId}) async {
    return await _chatRepository.archivedConversation(roomId: roomId);
  }

  @override
  Future<Result<Room>> deleteMember({
    required int roomId,
    required int userId,
  }) async {
    return await _chatRepository.deleteMember(roomId: roomId, userId: userId);
  }

  // Messages
  @override
  Future<Result<List<Message>>> getMessageByRoom({
    required int roomId,
    required int skip,
    int limit = 10,
  }) async {
    return await _messageRepository.getMessageByRoom(
      roomId: roomId,
      limit: limit,
      skip: skip,
    );
  }

  @override
  Future<Result<Message>> sendMessage({
    required int roomId,
    required String data,
  }) async {
    return await _messageRepository.sendMessage(
      roomId: roomId,
      data: data,
    );
  }

  @override
  Future<Result<Message>> editMessage({
    required int messageId,
    required String data,
  }) async {
    return await _messageRepository.editMessage(
      messageId: messageId,
      data: data,
    );
  }

  @override
  Future<Result<Message>> deleteMessage({required int messageId}) async {
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
  Future<Result<PresignedUrl>> getPresignedUrl() async {
    return await _userRepository.getPresignedUrl();
  }

  @override
  Future<Result<String>> uploadAvatar({
    required Uint8List image,
    required String presignedUrl,
    required String sourceUrl,
  }) async {
    return await _userRepository.uploadAvatarToCloud(
      image: image,
      presignedUrl: presignedUrl,
      sourceUrl: sourceUrl,
    );
  }

  // Auth
  @override
  Future<Result<User>> createToken({
    required AuthPayload payload,
    Function()? callbackConnected,
  }) async {
    final Result<User> user = await _authRepository.createToken(payload);

    if (user.isSuccess) {
      _wsHandler.establishConnection(
        forceConnection: true,
        callbackConnected: callbackConnected,
      );
    }

    return user;
  }

  @override
  Future<Result<bool>> deleteToken() async {
    _wsHandler.disconnection();

    return await _authRepository.deleteToken();
  }

  @override
  Future<Result<bool>> renewToken() async {
    return await _authRepository.renewToken();
  }

  // MARK: Private
  Future<void> _joinRoom({
    required String roomId,
    required int participantId,
    required ConnectionType connectionType,
  }) async {
    try {
      WakelockPlus.enable();

      await _rtcManager.joinRoom(
        roomId: roomId,
        participantId: participantId,
        connectionType: connectionType,
      );
    } catch (error) {
      _logger.bug(error.toString());
    }
  }

  Future<void> _subscribe(List<String> targetIds) async {
    try {
      _rtcManager.subscribeToParticipants(targetIds);
    } catch (error) {
      _logger.bug(error.toString());
    }
  }

  @override
  RoomState get roomState => _rtcManager.roomState;

  @override
  Stream<T> on<T>() {
    return _rtcManager.on<T>();
  }
}
