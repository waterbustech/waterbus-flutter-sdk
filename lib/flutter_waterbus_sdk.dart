library waterbus_sdk;

import 'package:flutter/foundation.dart';

import 'package:flutter_webrtc_plus/flutter_webrtc_plus.dart';

import 'package:waterbus_sdk/core/api/base/base_local_storage.dart';
import 'package:waterbus_sdk/core/webrtc/webrtc_interface.dart';
import 'package:waterbus_sdk/injection/injection_container.dart';
import 'package:waterbus_sdk/types/enums/draw_action.dart';
import 'package:waterbus_sdk/types/index.dart';
import 'package:waterbus_sdk/types/models/draw_model.dart';
import 'package:waterbus_sdk/types/models/record_model.dart';
import 'package:waterbus_sdk/utils/callkit/callkit_listener.dart';
import 'package:waterbus_sdk/waterbus_sdk_interface.dart';

export 'types/index.dart';
export './constants/constants.dart';
export 'package:flutter_webrtc_plus/flutter_webrtc_plus.dart';

class WaterbusSdk {
  static String apiUrl = '';
  static String wsUrl = '';
  static String apiKey = '';
  static String privateMessageKey = '';
  static Function(CallbackPayload)? onEventChanged;
  static Function(VideoSenderStats)? onStatsChanged;
  static Function(Subtitle)? onSubtitle;
  static Function(MessageSocketEvent)? onMesssageChanged;
  static Function(List<DrawModel> drawList)? onDrawChanged;

  set onMessageSocketChanged(Function(MessageSocketEvent) onMesssageChanged) {
    WaterbusSdk.onMesssageChanged = onMesssageChanged;
  }

  set onEventChangedRegister(Function(CallbackPayload) onEventChanged) {
    WaterbusSdk.onEventChanged = onEventChanged;
  }

  set setStatsChanged(Function(VideoSenderStats)? onStatsChanged) {
    WaterbusSdk.onStatsChanged = onStatsChanged;
  }

  set setOnSubtitle(Function(Subtitle)? onSubtitle) {
    WaterbusSdk.onSubtitle = onSubtitle;
  }

  set setOnDrawChanged(Function(List<DrawModel> drawList)? onDrawChanged) {
    WaterbusSdk.onDrawChanged = onDrawChanged;
  }

  Future<void> initializeApp({
    required String wsUrl,
    required String apiUrl,
    String apiKey = 'waterbus@2024',
    String privateMessageKey = '', // Disable message encrypted if empty
  }) async {
    WaterbusSdk.wsUrl = wsUrl;
    WaterbusSdk.apiUrl = apiUrl;
    WaterbusSdk.apiKey = apiKey;
    WaterbusSdk.privateMessageKey = privateMessageKey;

    // Init dependency injection if needed
    if (!getIt.isRegistered<WaterbusWebRTCManager>()) {
      await BaseLocalData.initialize();

      configureDependencies();

      if (WebRTC.platformIsIOS) {
        _callKitListener.listenerEvents();
      }
    }

    await _sdk.initializeApp();
  }

  // Meeting
  Future<Meeting?> createRoom({
    required Meeting meeting,
    required String password,
    required int? userId,
  }) async {
    return await _sdk.createRoom(
      meeting: meeting,
      password: password,
      userId: userId,
    );
  }

  Future<Meeting?> joinRoom({
    required Meeting meeting,
    required String password,
    required int? userId,
  }) async {
    return await _sdk.joinRoom(
      meeting: meeting,
      password: password,
      userId: userId,
    );
  }

  Future<Meeting?> updateRoom({
    required Meeting meeting,
    required String password,
    required int? userId,
  }) async {
    return await _sdk.updateRoom(
      meeting: meeting,
      password: password,
      userId: userId,
    );
  }

  Future<Meeting?> getRoomInfo({required int code}) async {
    return await _sdk.getRoomInfo(code);
  }

  Future<List<RecordModel>> getRecords({int skip = 0, int limit = 10}) async {
    return await _sdk.getRecords(skip: skip, limit: limit);
  }

  Future<int?> startRecord() async {
    return await _sdk.startRecord();
  }

  Future<bool> stopRecord() async {
    return await _sdk.stopRecord();
  }

  Future<void> leaveRoom() async {
    await _sdk.leaveRoom();
  }

  // MARK : White board
  Future<void> startWhiteBoard() async {
    await _sdk.startWhiteBoard();
  }

  Future<void> updateWhiteBoard(
    DrawModel draw,
    DrawActionEnum action,
  ) async {
    await _sdk.updateWhiteBoard(draw, action);
  }

  Future<void> cleanWhiteBoard() async {
    await _sdk.cleanWhiteBoard();
  }

  Future<void> undo() async {
    await _sdk.undoWhiteBoard();
  }

  Future<void> redo() async {
    await _sdk.redoWhiteBoard();
  }

  // Related to local media
  Future<void> reconnect() async => await _sdk.reconnect();

  Future<void> prepareMedia() async {
    await _sdk.prepareMedia();
  }

  Future<void> startScreenSharing({DesktopCapturerSource? source}) async {
    await _sdk.startScreenSharing(source: source);
  }

  Future<void> stopScreenSharing() async {
    await _sdk.stopScreenSharing();
  }

  Future<void> switchCamera() async {
    await _sdk.switchCamera();
  }

  Future<void> toggleVideo() async {
    await _sdk.toggleVideo();
  }

  Future<void> toggleAudio() async {
    await _sdk.toggleAudio();
  }

  Future<void> toggleSpeakerPhone() async {
    await _sdk.toggleSpeakerPhone();
  }

  void setSubscribeSubtitle({bool isEnabled = true}) {
    _sdk.setSubscribeSubtitle(isEnabled);
  }

  Future<void> changeCallSetting(CallSetting setting) async {
    await _sdk.changeCallSettings(setting);
  }

  Future<void> enableVirtualBackground({
    required Uint8List backgroundImage,
    double thresholdConfidence = 0.7,
  }) async {
    await _sdk.enableVirtualBackground(
      backgroundImage: backgroundImage,
      thresholdConfidence: thresholdConfidence,
    );
  }

  Future<void> disableVirtualBackground() async {
    await _sdk.disableVirtualBackground();
  }

  Future<void> setPiPEnabled({
    required String textureId,
    bool enabled = true,
  }) async {
    await _sdk.setPiPEnabled(textureId: textureId, enabled: enabled);
  }

  Future<List<WebRTCCodec>> filterSupportedCodecs() async {
    final List<WebRTCCodec> supportedCodecs = [];

    for (final codec in WebRTCCodec.values) {
      if (await codec.isPlatformSupported()) {
        supportedCodecs.add(codec);
      }
    }

    return supportedCodecs;
  }

  // User
  Future<User?> getProfile() async {
    return await _sdk.getProfile();
  }

  Future<User?> updateProfile({required User user}) async {
    return await _sdk.updateProfile(user: user);
  }

  Future<bool?> updateUsername({
    required String username,
  }) async {
    return await _sdk.updateUsername(username: username);
  }

  Future<bool> checkUsername({
    required String username,
  }) async {
    return await _sdk.checkUsername(username: username);
  }

  Future<String?> getPresignedUrl() async {
    return await _sdk.getPresignedUrl();
  }

  Future<String?> uploadAvatar({
    required Uint8List image,
    required String uploadUrl,
  }) async {
    return await _sdk.uploadAvatar(image: image, uploadUrl: uploadUrl);
  }

  Future<List<User>> searchUsers({
    required String keyword,
    required int skip,
    int limit = 10,
  }) async {
    return await _sdk.searchUsers(keyword: keyword, skip: skip, limit: limit);
  }

  // Chat
  Future<Meeting?> addMember(int code, int userId) async {
    return await _sdk.addMember(code: code, userId: userId);
  }

  Future<Meeting?> deleteMember(int code, int userId) async {
    return await _sdk.deleteMember(code: code, userId: userId);
  }

  Future<Meeting?> acceptInvite(int code) async {
    return await _sdk.acceptInvite(code: code);
  }

  Future<Meeting?> leaveConversation(int code) async {
    return await _sdk.leaveConversation(code: code);
  }

  Future<bool> deleteConversation(int conversationId) async {
    return await _sdk.deleteConversation(conversationId);
  }

  Future<List<Meeting>> getConversations({
    required int skip,
    int limit = 10,
    int status = 2,
  }) async {
    return await _sdk.getConversations(
      status: status,
      limit: limit,
      skip: skip,
    );
  }

  // Messages
  Future<List<MessageModel>> getMessageByRoom({
    required int meetingId,
    required int skip,
    int limit = 10,
  }) async {
    return await _sdk.getMessageByRoom(
      meetingId: meetingId,
      limit: limit,
      skip: skip,
    );
  }

  Future<MessageModel?> sendMessage({
    required int meetingId,
    required String data,
  }) async {
    return await _sdk.sendMessage(meetingId: meetingId, data: data);
  }

  Future<MessageModel?> editMessage({
    required int messageId,
    required String data,
  }) async {
    return await _sdk.editMessage(messageId: messageId, data: data);
  }

  Future<MessageModel?> deleteMessage({required int messageId}) async {
    return await _sdk.deleteMessage(messageId: messageId);
  }

  // Auth
  Future<User?> createToken(AuthPayloadModel payload) async {
    return await _sdk.createToken(payload: payload);
  }

  Future<bool> deleteToken() async {
    return await _sdk.deleteToken();
  }

  Future<bool?> renewToken() async {
    return await _sdk.refreshToken();
  }

  CallState get callState => _sdk.callState;

  // Private
  WaterbusSdkInterface get _sdk => getIt<WaterbusSdkInterface>();
  CallKitListener get _callKitListener => getIt<CallKitListener>();

  ///Singleton factory
  static final WaterbusSdk instance = WaterbusSdk._internal();

  factory WaterbusSdk() {
    return instance;
  }

  WaterbusSdk._internal();
}
