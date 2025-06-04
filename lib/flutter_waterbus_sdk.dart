import 'package:flutter/foundation.dart';

import 'package:flutter_webrtc_plus/flutter_webrtc_plus.dart';
import 'package:rhttp/rhttp.dart';

import 'package:waterbus_sdk/core/api/base/base_local_storage.dart';
import 'package:waterbus_sdk/core/webrtc/webrtc_manager.dart';
import 'package:waterbus_sdk/injection/injection_container.dart';
import 'package:waterbus_sdk/types/index.dart';
import 'package:waterbus_sdk/utils/callkit/callkit_listener.dart';
import 'package:waterbus_sdk/waterbus_event_listener.dart';
import 'package:waterbus_sdk/waterbus_sdk_interface.dart';

export 'types/index.dart';
export 'package:waterbus_sdk/constants/constants.dart';
export 'package:flutter_webrtc_plus/flutter_webrtc_plus.dart';
export 'package:rhttp/rhttp.dart';
export 'ui/waterbus_media_view.dart';

class WaterbusSdk {
  static BaseUrl baseUrl = BaseUrl(url: "", suffixUrl: "");
  static String messageEncryptionKey = '';
  static String webrtcE2eeKey = 'waterbus';

  static HttpVersionPref httpVersionPref = HttpVersionPref.all;
  static WaterbusEventListener listener = WaterbusEventListener();

  set onMessageSocketChanged(Function(MessageSocketEvent) onMesssageChanged) {
    WaterbusSdk.listener =
        WaterbusSdk.listener.copyWith(onMesssageChanged: onMesssageChanged);
  }

  set onEventChangedRegister(Function(CallbackPayload) onEventChanged) {
    WaterbusSdk.listener =
        WaterbusSdk.listener.copyWith(onEventChanged: onEventChanged);
  }

  set setOnSubtitle(Function(Subtitle)? onSubtitle) {
    WaterbusSdk.listener =
        WaterbusSdk.listener.copyWith(onSubtitle: onSubtitle);
  }

  Future<void> initializeApp({
    required BaseUrl baseUrl,

    /// Encryption message will be disabled if the key is empty
    String messageEncryptionKey = '',
    String webrtcE2eeKey = '',
    HttpVersionPref httpVersionPref = HttpVersionPref.all,
  }) async {
    WaterbusSdk.baseUrl = baseUrl;
    WaterbusSdk.messageEncryptionKey = messageEncryptionKey;
    WaterbusSdk.webrtcE2eeKey = webrtcE2eeKey;
    WaterbusSdk.httpVersionPref = httpVersionPref;

    // Init dependency injection if needed
    if (!getIt.isRegistered<WebRTCManager>()) {
      await BaseLocalData.initialize();

      configureDependencies();

      if (WebRTC.platformIsIOS) {
        _callKitListener.listenerEvents();
      }
    }

    await _sdk.initializeApp();
  }

  // Rooms
  Future<Result<Room>> createRoom({required RoomParams params}) async {
    return await _sdk.createRoom(params: params);
  }

  Future<Result<Room>> joinRoom({required RoomParams params}) async {
    return await _sdk.joinRoom(params: params);
  }

  Future<Result<bool>> updateRoom({required RoomParams params}) async {
    return await _sdk.updateRoom(params: params);
  }

  Future<Result<Room>> getRoomInfo({required String code}) async {
    return await _sdk.getRoomInfo(code);
  }

  Future<void> leaveRoom() async {
    await _sdk.leaveRoom();
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

  void toggleRaiseHand() {
    _sdk.toggleRaiseHand();
  }

  Future<void> toggleSpeakerPhone() async {
    await _sdk.toggleSpeakerPhone();
  }

  void setSubscribeSubtitle({bool isEnabled = true}) {
    _sdk.setSubscribeSubtitle(isEnabled);
  }

  Future<void> changeCallSetting(MediaConfig setting) async {
    await _sdk.changeCallSettings(setting);
  }

  Future<void> enableVirtualBackground({
    required Uint8List backgroundImage,
    double thresholdConfidence = 0.7,
  }) async {
    await _sdk.enableVirtualBg(
      backgroundImage: backgroundImage,
      thresholdConfidence: thresholdConfidence,
    );
  }

  Future<void> disableVirtualBg() async {
    await _sdk.disableVirtualBg();
  }

  Future<void> setPiPEnabled({
    required String textureId,
    bool enabled = true,
  }) async {
    await _sdk.setPiPEnabled(textureId: textureId, enabled: enabled);
  }

  Future<List<RTCVideoCodec>> filterSupportedCodecs() async {
    final List<RTCVideoCodec> supportedCodecs = [];

    for (final codec in RTCVideoCodec.values) {
      if (await codec.isPlatformSupported()) {
        supportedCodecs.add(codec);
      }
    }

    return supportedCodecs;
  }

  // User
  Future<Result<User>> getProfile() async {
    return await _sdk.getProfile();
  }

  Future<Result<bool>> updateProfile({required User user}) async {
    return await _sdk.updateProfile(user: user);
  }

  Future<Result<bool>> updateUsername({
    required String username,
  }) async {
    return await _sdk.updateUsername(username: username);
  }

  Future<Result<bool>> checkUsername({
    required String username,
  }) async {
    return await _sdk.checkUsername(username: username);
  }

  Future<Result<PresignedUrl>> getPresignedUrl() async {
    return await _sdk.getPresignedUrl();
  }

  Future<Result<String>> uploadAvatar({
    required Uint8List image,
    required String presignedUrl,
    required String sourceUrl,
  }) async {
    return await _sdk.uploadAvatar(
      image: image,
      presignedUrl: presignedUrl,
      sourceUrl: sourceUrl,
    );
  }

  // Chat
  Future<Result<Room>> addMember(int roomId, int userId) async {
    return await _sdk.addMember(roomId: roomId, userId: userId);
  }

  Future<Result<Room>> deleteMember(int roomId, int userId) async {
    return await _sdk.deleteMember(roomId: roomId, userId: userId);
  }

  Future<Result<Room>> leaveConversation(int roomId) async {
    return await _sdk.leaveConversation(roomId: roomId);
  }

  Future<Result<Room>> archivedConversation(int roomId) async {
    return await _sdk.archivedConversation(roomId: roomId);
  }

  Future<Result<bool>> deleteConversation(int conversationId) async {
    return await _sdk.deleteConversation(conversationId);
  }

  Future<Result<List<Room>>> getConversations({
    required int skip,
    int limit = 10,
  }) async {
    return await _sdk.getConversations(
      limit: limit,
      skip: skip,
    );
  }

  Future<Result<List<Room>>> getArchivedConversations({
    required int skip,
    int limit = 10,
  }) async {
    return await _sdk.getArchivedConversations(
      limit: limit,
      skip: skip,
    );
  }

  Future<Result<bool>> updateConversation({
    required Room room,
    String? password,
  }) async {
    return await _sdk.updateConversation(
      room: room,
      password: password,
    );
  }

  // Messages
  Future<Result<List<Message>>> getMessageByRoom({
    required int roomId,
    required int skip,
    int limit = 10,
  }) async {
    return await _sdk.getMessageByRoom(
      roomId: roomId,
      limit: limit,
      skip: skip,
    );
  }

  Future<Result<Message?>> sendMessage({
    required int roomId,
    required String data,
  }) async {
    return await _sdk.sendMessage(roomId: roomId, data: data);
  }

  Future<Result<Message>> editMessage({
    required int messageId,
    required String data,
  }) async {
    return await _sdk.editMessage(messageId: messageId, data: data);
  }

  Future<Result<Message>> deleteMessage({required int messageId}) async {
    return await _sdk.deleteMessage(messageId: messageId);
  }

  // Auth
  Future<Result<User>> createToken(AuthPayload payload) async {
    return await _sdk.createToken(payload: payload);
  }

  Future<Result<bool>> deleteToken() async {
    return await _sdk.deleteToken();
  }

  Future<Result<bool>> renewToken() async {
    return await _sdk.renewToken();
  }

  CallState get callState => _sdk.callState;

  // Private
  WaterbusSdkInterface get _sdk => getIt<WaterbusSdkInterface>();
  CallKitListener get _callKitListener => getIt<CallKitListener>();

  /// Singleton factory
  static final WaterbusSdk instance = WaterbusSdk._internal();

  factory WaterbusSdk() {
    return instance;
  }

  WaterbusSdk._internal();
}
