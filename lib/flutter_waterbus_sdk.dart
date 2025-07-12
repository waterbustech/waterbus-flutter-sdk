import 'package:flutter/foundation.dart';

import 'package:flutter_webrtc_plus/flutter_webrtc_plus.dart';
import 'package:rhttp/rhttp.dart';

import 'package:waterbus_sdk/core/api/base/base_local_storage.dart';
import 'package:waterbus_sdk/core/webrtc/webrtc_manager.dart';
import 'package:waterbus_sdk/injection/injection_container.dart';
import 'package:waterbus_sdk/types/externals/models/join_room_params.dart';
import 'package:waterbus_sdk/types/index.dart';
import 'package:waterbus_sdk/utils/callkit/callkit_listener.dart';
import 'package:waterbus_sdk/waterbus_event_listener.dart';
import 'package:waterbus_sdk/waterbus_sdk_interface.dart';

// Re-exports
export 'types/index.dart';
export 'package:waterbus_sdk/constants/constants.dart';
export 'package:flutter_webrtc_plus/flutter_webrtc_plus.dart';
export 'package:rhttp/rhttp.dart';
export 'ui/waterbus_media_view.dart';

/// Configuration class for WaterbusSdk initialization
class SdkConfig {
  final ServerConfig serverConfig;
  final String messageEncryptionKey;
  final String webrtcE2eeKey;
  final HttpVersionPref httpVersionPref;

  const SdkConfig({
    required this.serverConfig,
    this.messageEncryptionKey = '',
    this.webrtcE2eeKey = 'waterbus',
    this.httpVersionPref = HttpVersionPref.all,
  });
}

/// Main SDK class for Waterbus functionality
class WaterbusSdk {
  // Private constructor for singleton
  WaterbusSdk._internal();

  /// Singleton instance
  static final WaterbusSdk instance = WaterbusSdk._internal();

  /// Factory constructor returns singleton instance
  factory WaterbusSdk() => instance;

  // Static configuration
  static ServerConfig _serverConfig = ServerConfig(url: "", suffixUrl: "");
  static String _messageEncryptionKey = '';
  static String _webrtcE2eeKey = 'waterbus';
  static HttpVersionPref _httpVersionPref = HttpVersionPref.all;
  static WaterbusEventListener _listener = WaterbusEventListener();

  // Getters for configuration
  static ServerConfig get serverConfig => _serverConfig;
  static String get messageEncryptionKey => _messageEncryptionKey;
  static String get webrtcE2eeKey => _webrtcE2eeKey;
  static HttpVersionPref get httpVersionPref => _httpVersionPref;
  static WaterbusEventListener get listener => _listener;

  // Private getters for dependencies
  WaterbusSdkInterface get _sdk => getIt<WaterbusSdkInterface>();
  CallKitListener get _callKitListener => getIt<CallKitListener>();

  // Public getters
  CallState get callState => _sdk.callState;

  /// Event listener setters
  set onMessageSocketChanged(Function(MessageSocketEvent) onMessageChanged) {
    _listener = _listener.copyWith(onMesssageChanged: onMessageChanged);
  }

  set onEventChangedRegister(Function(CallbackPayload) onEventChanged) {
    _listener = _listener.copyWith(onEventChanged: onEventChanged);
  }

  set setOnSubtitle(Function(Subtitle)? onSubtitle) {
    _listener = _listener.copyWith(onSubtitle: onSubtitle);
  }

  // =============================================================================
  // INITIALIZATION
  // =============================================================================

  /// Initialize the Waterbus SDK with configuration
  Future<void> initialize({
    required SdkConfig config,
  }) async {
    await _initializeWithConfig(config);
  }

  Future<void> _initializeWithConfig(SdkConfig config) async {
    // Set static configuration
    _serverConfig = config.serverConfig;
    _messageEncryptionKey = config.messageEncryptionKey;
    _webrtcE2eeKey = config.webrtcE2eeKey;
    _httpVersionPref = config.httpVersionPref;

    // Initialize dependencies if not already registered
    if (!getIt.isRegistered<WebRTCManager>()) {
      await BaseLocalData.initialize();
      configureDependencies();

      // Setup CallKit for iOS
      if (WebRTC.platformIsIOS) {
        _callKitListener.listenerEvents();
      }
    }

    await _sdk.initializeApp();
  }

  // =============================================================================
  // ROOM MANAGEMENT
  // =============================================================================

  /// Create a new room
  Future<Result<Room>> createRoom({required RoomParams params}) async {
    return await _sdk.createRoom(params: params);
  }

  /// Join an existing room
  Future<Result<Room>> joinRoom({required JoinRoomParams params}) async {
    return await _sdk.joinRoom(params: params);
  }

  /// Update room settings
  Future<Result<bool>> updateRoom({required RoomParams params}) async {
    return await _sdk.updateRoom(params: params);
  }

  /// Get room information by code
  Future<Result<Room>> getRoomInfo({required String code}) async {
    return await _sdk.getRoomInfo(code);
  }

  /// Leave the current room
  Future<void> leaveRoom() async {
    await _sdk.leaveRoom();
  }

  // =============================================================================
  // MEDIA CONTROLS
  // =============================================================================

  /// Reconnect to the current session
  Future<void> reconnect() async {
    await _sdk.reconnect();
  }

  /// Prepare media devices for use
  Future<void> prepareMedia() async {
    await _sdk.prepareMedia();
  }

  /// Start screen sharing
  Future<void> startScreenSharing({DesktopCapturerSource? source}) async {
    await _sdk.startScreenSharing(source: source);
  }

  /// Stop screen sharing
  Future<void> stopScreenSharing() async {
    await _sdk.stopScreenSharing();
  }

  /// Switch between front and back camera
  Future<void> switchCamera() async {
    await _sdk.switchCamera();
  }

  /// Toggle video on/off
  Future<void> toggleVideo() async {
    await _sdk.toggleVideo();
  }

  /// Toggle audio on/off
  Future<void> toggleAudio() async {
    await _sdk.toggleAudio();
  }

  Future<void> changeAudioInputDevice({required String deviceId}) async {
    await _sdk.changeAudioInputDevice(deviceId: deviceId);
  }

  Future<void> changeVideoInputDevice({required String deviceId}) async {
    await _sdk.changeVideoInputDevice(deviceId: deviceId);
  }

  void toggleRaiseHand() {
    _sdk.toggleRaiseHand();
  }

  /// Toggle speaker phone
  Future<void> toggleSpeakerPhone() async {
    await _sdk.toggleSpeakerPhone();
  }

  /// Enable/disable subtitle subscription
  void setSubscribeSubtitle({bool isEnabled = true}) {
    _sdk.setSubscribeSubtitle(isEnabled);
  }

  /// Change call media settings
  Future<void> updateMediaConfig(MediaConfig setting) async {
    await _sdk.updateMediaConfig(setting);
  }

  // =============================================================================
  // VIRTUAL BACKGROUND
  // =============================================================================

  /// Enable virtual background with custom image
  Future<void> enableVirtualBackground({
    required Uint8List backgroundImage,
    double thresholdConfidence = 0.7,
  }) async {
    await _sdk.enableVirtualBg(
      backgroundImage: backgroundImage,
      thresholdConfidence: thresholdConfidence,
    );
  }

  /// Disable virtual background
  Future<void> disableVirtualBackground() async {
    await _sdk.disableVirtualBg();
  }

  // =============================================================================
  // PICTURE-IN-PICTURE
  // =============================================================================

  /// Enable/disable Picture-in-Picture mode
  Future<void> setPictureInPictureEnabled({
    required String textureId,
    bool enabled = true,
  }) async {
    await _sdk.setPiPEnabled(textureId: textureId, enabled: enabled);
  }

  // =============================================================================
  // CODEC SUPPORT
  // =============================================================================

  /// Get list of supported video codecs on current platform
  Future<List<RTCVideoCodec>> getSupportedVideoCodecs() async {
    final List<RTCVideoCodec> supportedCodecs = [];

    for (final codec in RTCVideoCodec.values) {
      if (await codec.isPlatformSupported()) {
        supportedCodecs.add(codec);
      }
    }

    return supportedCodecs;
  }

  // =============================================================================
  // USER MANAGEMENT
  // =============================================================================

  /// Get current user profile
  Future<Result<User>> getProfile() async {
    return await _sdk.getProfile();
  }

  /// Update user profile
  Future<Result<bool>> updateProfile({required User user}) async {
    return await _sdk.updateProfile(user: user);
  }

  /// Update username
  Future<Result<bool>> updateUsername({required String username}) async {
    return await _sdk.updateUsername(username: username);
  }

  /// Check if username is available
  Future<Result<bool>> checkUsername({required String username}) async {
    return await _sdk.checkUsername(username: username);
  }

  /// Get presigned URL for file upload
  Future<Result<PresignedUrl>> getPresignedUrl() async {
    return await _sdk.getPresignedUrl();
  }

  /// Upload user avatar
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

  // =============================================================================
  // CONVERSATION MANAGEMENT
  // =============================================================================

  /// Add member to room
  Future<Result<Room>> addMember({
    required int roomId,
    required int userId,
  }) async {
    return await _sdk.addMember(roomId: roomId, userId: userId);
  }

  /// Remove member from room
  Future<Result<Room>> removeMember({
    required int roomId,
    required int userId,
  }) async {
    return await _sdk.deleteMember(roomId: roomId, userId: userId);
  }

  /// Leave a conversation
  Future<Result<Room>> leaveConversation({required int roomId}) async {
    return await _sdk.leaveConversation(roomId: roomId);
  }

  /// Archive a conversation
  Future<Result<Room>> archiveConversation({required int roomId}) async {
    return await _sdk.archivedConversation(roomId: roomId);
  }

  /// Delete a conversation
  Future<Result<bool>> deleteConversation({required int conversationId}) async {
    return await _sdk.deleteConversation(conversationId);
  }

  /// Get list of conversations with pagination
  Future<Result<List<Room>>> getConversations({
    required int skip,
    int limit = 10,
  }) async {
    return await _sdk.getConversations(limit: limit, skip: skip);
  }

  /// Get list of archived conversations with pagination
  Future<Result<List<Room>>> getArchivedConversations({
    required int skip,
    int limit = 10,
  }) async {
    return await _sdk.getArchivedConversations(limit: limit, skip: skip);
  }

  /// Update conversation settings
  Future<Result<bool>> updateConversation({
    required Room room,
    String? password,
  }) async {
    return await _sdk.updateConversation(room: room, password: password);
  }

  // =============================================================================
  // MESSAGE MANAGEMENT
  // =============================================================================

  /// Get messages for a room with pagination
  Future<Result<List<Message>>> getMessages({
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

  /// Send a message to a room
  Future<Result<Message?>> sendMessage({
    required int roomId,
    required String data,
  }) async {
    return await _sdk.sendMessage(roomId: roomId, data: data);
  }

  /// Edit an existing message
  Future<Result<Message>> editMessage({
    required int messageId,
    required String data,
  }) async {
    return await _sdk.editMessage(messageId: messageId, data: data);
  }

  /// Delete a message
  Future<Result<Message>> deleteMessage({required int messageId}) async {
    return await _sdk.deleteMessage(messageId: messageId);
  }

  // =============================================================================
  // AUTHENTICATION
  // =============================================================================

  /// Create authentication token
  Future<Result<User>> createToken(
    AuthPayload payload, {
    Function()? callbackConnected,
  }) async {
    return await _sdk.createToken(
      payload: payload,
      callbackConnected: callbackConnected,
    );
  }

  /// Delete authentication token
  Future<Result<bool>> deleteToken() async {
    return await _sdk.deleteToken();
  }

  /// Renew authentication token
  Future<Result<bool>> renewToken() async {
    return await _sdk.renewToken();
  }
}
