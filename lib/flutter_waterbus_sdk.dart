import 'package:flutter/foundation.dart';

import 'package:flutter_webrtc_plus/flutter_webrtc_plus.dart';
import 'package:logging/logging.dart';
import 'package:rhttp/rhttp.dart';

import 'package:waterbus_sdk/core/api/base/base_local_storage.dart';
import 'package:waterbus_sdk/core/rtc/rtc_manager.dart';
import 'package:waterbus_sdk/injection/injection_container.dart';
import 'package:waterbus_sdk/types/index.dart';
import 'package:waterbus_sdk/utils/callkit/callkit_listener.dart';
import 'package:waterbus_sdk/waterbus_sdk_interface.dart';

export 'types/index.dart';
export 'package:waterbus_sdk/constants/constants.dart';
export 'package:flutter_webrtc_plus/flutter_webrtc_plus.dart';
export 'package:rhttp/rhttp.dart';
export 'ui/waterbus_media_view.dart';

class SdkConfig {
  /// Server configuration containing URL and suffix settings
  final ServerConfig serverConfig;

  /// Encryption key for message encryption (optional, defaults to empty string)
  final String messageEncryptionKey;

  /// Encryption key for WebRTC end-to-end encryption (defaults to 'waterbus')
  final String webrtcE2eeKey;

  /// HTTP version preference for API requests (defaults to HttpVersionPref.all)
  final HttpVersionPref httpVersionPref;

  const SdkConfig({
    required this.serverConfig,
    this.messageEncryptionKey = '',
    this.webrtcE2eeKey = 'waterbus',
    this.httpVersionPref = HttpVersionPref.all,
  });
}

/// Main SDK class for Waterbus functionality
///
/// WaterbusSdk provides a comprehensive API for video conferencing, messaging,
/// and room management. It follows a singleton pattern to ensure consistent
/// state management across the application.
///
/// Example usage:
/// ```dart
/// // Initialize the SDK
/// await WaterbusSdk.instance.initialize(
///   config: SdkConfig(
///     serverConfig: ServerConfig(url: "https://services.waterbus.tech", suffixUrl: "/v1"),
///     messageEncryptionKey: "your-encryption-key",
///   ),
/// );
///
/// // Join a room
/// final result = await WaterbusSdk.instance.joinRoom(
///   params: JoinRoomParams(roomCode: "ABC123"),
/// );
/// ```
class WaterbusSdk {
  // Private constructor for singleton
  WaterbusSdk._internal();

  /// Singleton instance of WaterbusSdk
  static final WaterbusSdk instance = WaterbusSdk._internal();

  /// Factory constructor returns singleton instance
  factory WaterbusSdk() => instance;

  // Static configuration
  static ServerConfig _serverConfig = ServerConfig(url: "", suffixUrl: "");
  static String _messageEncryptionKey = '';
  static String _webrtcE2eeKey = 'waterbus';
  static HttpVersionPref _httpVersionPref = HttpVersionPref.all;

  // Getters for configuration
  static ServerConfig get serverConfig => _serverConfig;
  static String get messageEncryptionKey => _messageEncryptionKey;
  static String get webrtcE2eeKey => _webrtcE2eeKey;
  static HttpVersionPref get httpVersionPref => _httpVersionPref;

  // Private getters for dependencies
  WaterbusSdkInterface get _sdk => getIt<WaterbusSdkInterface>();
  CallKitListener get _callKitListener => getIt<CallKitListener>();

  // Public getters
  RoomState get roomState => _sdk.roomState;

  // =============================================================================
  // EVENT SUBSCRIPTION
  // =============================================================================

  /// Subscribe to specific event types
  ///
  /// Returns a stream of events of the specified type. This allows you to listen
  /// to various SDK events such as room state changes, participant updates, etc.
  ///
  /// [T] The type of event to subscribe to (e.g., RoomEvent, ParticipantEvent)
  ///
  /// Returns a [Stream<T>] that emits events of the specified type
  ///
  /// Example:
  /// ```dart
  /// // Listen to room events
  /// WaterbusSdk.instance.on<RoomEvent>().listen((event) {
  ///   print('Room event: ${event.type}');
  /// });
  ///
  /// // Listen to participant events
  /// WaterbusSdk.instance.on<ParticipantEvent>().listen((event) {
  ///   print('Participant ${event.participant.id} ${event.type}');
  /// });
  /// ```
  Stream<T> on<T>() {
    return _sdk.on<T>();
  }

  // =============================================================================
  // INITIALIZATION
  // =============================================================================

  /// Initialize the Waterbus SDK with configuration
  ///
  /// This method must be called before using any other SDK functionality.
  /// It sets up the SDK with the provided configuration and initializes
  /// all necessary dependencies.
  ///
  /// [config] The SDK configuration containing server settings, encryption keys, etc.
  ///
  /// Throws an exception if initialization fails
  ///
  /// Example:
  /// ```dart
  /// await WaterbusSdk.instance.initialize(
  ///   config: SdkConfig(
  ///     serverConfig: ServerConfig(
  ///       url: "https://api.waterbus.com",
  ///       suffixUrl: "/v1",
  ///     ),
  ///     messageEncryptionKey: "your-secret-key",
  ///     webrtcE2eeKey: "your-e2ee-key",
  ///   ),
  /// );
  /// ```
  Future<void> initialize({
    required SdkConfig config,
  }) async {
    await _initializeWithConfig(config);
  }

  Future<void> _initializeWithConfig(SdkConfig config) async {
    hierarchicalLoggingEnabled = true;
    // Logger.root.level = Level.ALL;
    // Logger.root.onRecord.listen((record) {
    //   debugPrint(
    //     '[${record.level.name}][${record.loggerName}]: ${record.message}',
    //   );
    // });

    // Set static configuration
    _serverConfig = config.serverConfig;
    _messageEncryptionKey = config.messageEncryptionKey;
    _webrtcE2eeKey = config.webrtcE2eeKey;
    _httpVersionPref = config.httpVersionPref;

    // Initialize dependencies if not already registered
    if (!getIt.isRegistered<RtcManager>()) {
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
  ///
  /// Creates a new room with the specified parameters. The room will be
  /// immediately available for participants to join.
  ///
  /// [params] Room creation parameters including name, type, and settings
  ///
  /// Returns a [Result<Room>] containing the created room or an error
  ///
  /// Example:
  /// ```dart
  /// final result = await WaterbusSdk.instance.createRoom(
  ///   params: RoomParams(
  ///     name: "Team Meeting",
  ///     type: RoomType.private,
  ///     password: "secret123",
  ///   ),
  /// );
  ///
  /// if (result.isSuccess) {
  ///   print('Room created: ${result.data!.code}');
  /// }
  /// ```
  Future<Result<Room>> createRoom({required RoomParams params}) async {
    return await _sdk.createRoom(params: params);
  }

  /// Join an existing room
  ///
  /// Joins a room using the provided parameters. This will establish
  /// a connection to the room and prepare media devices.
  ///
  /// [params] Room joining parameters including room code and optional password
  ///
  /// Returns a [Result<Room>] containing the room information or an error
  ///
  /// Example:
  /// ```dart
  /// final result = await WaterbusSdk.instance.joinRoom(
  ///   params: JoinRoomParams(
  ///     roomCode: "ABC123",
  ///     password: "secret123", // optional
  ///   ),
  /// );
  ///
  /// if (result.isSuccess) {
  ///   print('Joined room: ${result.data!.name}');
  /// }
  /// ```
  Future<Result<Room>> joinRoom({required JoinRoomParams params}) async {
    return await _sdk.joinRoom(params: params);
  }

  /// Update room settings
  ///
  /// Updates the current room's settings. Only room owners can modify
  /// room settings.
  ///
  /// [params] Updated room parameters
  ///
  /// Returns a [Result<bool>] indicating success or failure
  ///
  /// Example:
  /// ```dart
  /// final result = await WaterbusSdk.instance.updateRoom(
  ///   params: RoomParams(
  ///     name: "Updated Meeting Name",
  ///     password: "newpassword",
  ///   ),
  /// );
  /// ```
  Future<Result<bool>> updateRoom({required RoomParams params}) async {
    return await _sdk.updateRoom(params: params);
  }

  /// Get room information by code
  ///
  /// Retrieves detailed information about a room without joining it.
  ///
  /// [code] The room code to look up
  ///
  /// Returns a [Result<Room>] containing room information or an error
  ///
  /// Example:
  /// ```dart
  /// final result = await WaterbusSdk.instance.getRoomInfo(code: "ABC123");
  /// if (result.isSuccess) {
  ///   print('Room: ${result.data!.name}');
  ///   print('Participants: ${result.data!.participantCount}');
  /// }
  /// ```
  Future<Result<Room>> getRoomInfo({required String code}) async {
    return await _sdk.getRoomInfo(code);
  }

  /// Leave the current room
  ///
  /// Disconnects from the current room and cleans up all resources.
  /// This should be called when the user wants to exit the room.
  ///
  /// Example:
  /// ```dart
  /// await WaterbusSdk.instance.leaveRoom();
  /// print('Left the room');
  /// ```
  Future<void> leaveRoom() async {
    await _sdk.leaveRoom();
  }

  // =============================================================================
  // MEDIA CONTROLS
  // =============================================================================

  /// Reconnect to the current session
  ///
  /// Attempts to reconnect to the current room session if the connection
  /// has been lost. This is useful for handling network interruptions.
  ///
  /// Example:
  /// ```dart
  /// // Called when network connection is restored
  /// await WaterbusSdk.instance.reconnect();
  /// ```
  Future<void> reconnect() async {
    await _sdk.reconnect();
  }

  /// Prepare media devices for use
  ///
  /// Initializes and prepares audio/video devices for use in the room.
  /// This should be called before joining a room to ensure devices are ready.
  ///
  /// Example:
  /// ```dart
  /// await WaterbusSdk.instance.prepareMedia();
  /// // Now ready to join room
  /// ```
  Future<void> prepareMedia() async {
    await _sdk.prepareMedia();
  }

  /// Start screen sharing
  ///
  /// Begins screen sharing with the specified source. If no source is provided,
  /// the user will be prompted to select a screen or window to share.
  ///
  /// [source] Optional screen capture source (desktop only)
  ///
  /// Example:
  /// ```dart
  /// await WaterbusSdk.instance.startScreenSharing();
  ///
  /// // Or with specific source (desktop)
  /// await WaterbusSdk.instance.startScreenSharing(source: selectedSource);
  /// ```
  Future<void> startScreenSharing({DesktopCapturerSource? source}) async {
    await _sdk.startScreenSharing(source: source);
  }

  /// Stop screen sharing
  ///
  /// Stops the current screen sharing session and returns to normal video mode.
  ///
  /// Example:
  /// ```dart
  /// await WaterbusSdk.instance.stopScreenSharing();
  /// ```
  Future<void> stopScreenSharing() async {
    await _sdk.stopScreenSharing();
  }

  /// Switch between front and back camera
  ///
  /// Toggles between the front-facing and back-facing cameras on mobile devices.
  /// This method only works on devices with multiple cameras.
  ///
  /// Example:
  /// ```dart
  /// await WaterbusSdk.instance.switchCamera();
  /// ```
  Future<void> switchCamera() async {
    await _sdk.switchCamera();
  }

  /// Toggle video on/off
  ///
  /// Enables or disables the local video stream. When disabled, other
  /// participants will see a placeholder or black screen.
  ///
  /// Example:
  /// ```dart
  /// await WaterbusSdk.instance.toggleVideo();
  /// ```
  Future<void> toggleVideo() async {
    await _sdk.toggleVideo();
  }

  /// Toggle audio on/off
  ///
  /// Enables or disables the local audio stream. When disabled, other
  /// participants will not hear your audio.
  ///
  /// Example:
  /// ```dart
  /// await WaterbusSdk.instance.toggleAudio();
  /// ```
  Future<void> toggleAudio() async {
    await _sdk.toggleAudio();
  }

  /// Change audio input device
  ///
  /// Switches to a different audio input device (microphone).
  ///
  /// [deviceId] The ID of the target audio input device
  ///
  /// Example:
  /// ```dart
  /// await WaterbusSdk.instance.changeAudioInputDevice(deviceId: "mic-123");
  /// ```
  Future<void> changeAudioInputDevice({required String deviceId}) async {
    await _sdk.changeAudioInputDevice(deviceId: deviceId);
  }

  /// Change video input device
  ///
  /// Switches to a different video input device (camera).
  ///
  /// [deviceId] The ID of the target video input device
  ///
  /// Example:
  /// ```dart
  /// await WaterbusSdk.instance.changeVideoInputDevice(deviceId: "camera-456");
  /// ```
  Future<void> changeVideoInputDevice({required String deviceId}) async {
    await _sdk.changeVideoInputDevice(deviceId: deviceId);
  }

  /// Toggle raise hand status
  ///
  /// Raises or lowers the virtual hand to indicate the need to speak.
  /// This is useful in large meetings where participants need to request permission to speak.
  ///
  /// Example:
  /// ```dart
  /// WaterbusSdk.instance.toggleRaiseHand();
  /// ```
  void toggleRaiseHand() {
    _sdk.toggleRaiseHand();
  }

  /// Toggle speaker phone
  ///
  /// Switches between speaker phone and earpiece on mobile devices.
  /// This affects how audio is routed on the local device.
  ///
  /// Example:
  /// ```dart
  /// await WaterbusSdk.instance.toggleSpeakerPhone();
  /// ```
  Future<void> toggleSpeakerPhone() async {
    await _sdk.toggleSpeakerPhone();
  }

  /// Enable/disable subtitle subscription
  ///
  /// Controls whether the client subscribes to live subtitles/transcriptions
  /// in the current room.
  ///
  /// [isEnabled] Whether to enable subtitle subscription (default: true)
  ///
  /// Example:
  /// ```dart
  /// // Enable subtitles
  /// WaterbusSdk.instance.setSubscribeSubtitle(isEnabled: true);
  ///
  /// // Disable subtitles
  /// WaterbusSdk.instance.setSubscribeSubtitle(isEnabled: false);
  /// ```
  void setSubscribeSubtitle({bool isEnabled = true}) {
    _sdk.setSubscribeSubtitle(isEnabled);
  }

  /// Change call media settings
  ///
  /// Updates the media configuration for the current call, including
  /// video quality, audio settings, and other media-related parameters.
  ///
  /// [setting] The new media configuration to apply
  ///
  /// Example:
  /// ```dart
  /// await WaterbusSdk.instance.updateMediaConfig(
  ///   MediaConfig(
  ///     videoConfig: VideoConfig(
  ///       quality: VideoQuality.high,
  ///       maxBitrate: 2000000,
  ///     ),
  ///     audioConfig: AudioConfig(
  ///       echoCancellation: true,
  ///       noiseSuppression: true,
  ///     ),
  ///   ),
  /// );
  /// ```
  Future<void> updateMediaConfig(MediaConfig setting) async {
    await _sdk.updateMediaConfig(setting);
  }

  // =============================================================================
  // VIRTUAL BACKGROUND
  // =============================================================================

  /// Enable virtual background with custom image
  ///
  /// Applies a virtual background using the provided image. The background
  /// will replace the real background behind the participant.
  ///
  /// [backgroundImage] The background image as bytes
  /// [thresholdConfidence] Confidence threshold for background detection (0.0-1.0)
  ///
  /// Example:
  /// ```dart
  /// final imageBytes = await loadImageBytes('background.jpg');
  /// await WaterbusSdk.instance.enableVirtualBackground(
  ///   backgroundImage: imageBytes,
  ///   thresholdConfidence: 0.8,
  /// );
  /// ```
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
  ///
  /// Removes the virtual background and returns to the real background.
  ///
  /// Example:
  /// ```dart
  /// await WaterbusSdk.instance.disableVirtualBackground();
  /// ```
  Future<void> disableVirtualBackground() async {
    await _sdk.disableVirtualBg();
  }

  // =============================================================================
  // PICTURE-IN-PICTURE
  // =============================================================================

  /// Enable/disable Picture-in-Picture mode
  ///
  /// Controls Picture-in-Picture mode for the specified video texture.
  /// This allows the video to be displayed in a floating window.
  ///
  /// [textureId] The ID of the video texture to control
  /// [enabled] Whether to enable PiP mode (default: true)
  ///
  /// Example:
  /// ```dart
  /// // Enable PiP for a video texture
  /// await WaterbusSdk.instance.setPictureInPictureEnabled(
  ///   textureId: "video-texture-123",
  ///   enabled: true,
  /// );
  ///
  /// // Disable PiP
  /// await WaterbusSdk.instance.setPictureInPictureEnabled(
  ///   textureId: "video-texture-123",
  ///   enabled: false,
  /// );
  /// ```
  Future<void> setPictureInPictureEnabled({
    required String textureId,
    bool enabled = true,
  }) async {
    await _sdk.setPiPEnabled(textureId: textureId, enabled: enabled);
  }

  // =============================================================================
  // USER MANAGEMENT
  // =============================================================================

  /// Get current user profile
  ///
  /// Retrieves the profile information of the currently authenticated user.
  ///
  /// Returns a [Result<User>] containing user profile or an error
  ///
  /// Example:
  /// ```dart
  /// final result = await WaterbusSdk.instance.getProfile();
  /// if (result.isSuccess) {
  ///   print('Username: ${result.data!.username}');
  ///   print('Email: ${result.data!.email}');
  /// }
  /// ```
  Future<Result<User>> getProfile() async {
    return await _sdk.getProfile();
  }

  /// Update user profile
  ///
  /// Updates the current user's profile information.
  ///
  /// [user] The updated user information
  ///
  /// Returns a [Result<bool>] indicating success or failure
  ///
  /// Example:
  /// ```dart
  /// final result = await WaterbusSdk.instance.updateProfile(
  ///   user: User(
  ///     username: "newusername",
  ///     email: "newemail@example.com",
  ///   ),
  /// );
  /// ```
  Future<Result<bool>> updateProfile({required User user}) async {
    return await _sdk.updateProfile(user: user);
  }

  /// Update username
  ///
  /// Updates only the username of the current user.
  ///
  /// [username] The new username
  ///
  /// Returns a [Result<bool>] indicating success or failure
  ///
  /// Example:
  /// ```dart
  /// final result = await WaterbusSdk.instance.updateUsername(username: "newusername");
  /// ```
  Future<Result<bool>> updateUsername({required String username}) async {
    return await _sdk.updateUsername(username: username);
  }

  /// Check if username is available
  ///
  /// Verifies whether a username is available for registration.
  ///
  /// [username] The username to check
  ///
  /// Returns a [Result<bool>] where true means available, false means taken
  ///
  /// Example:
  /// ```dart
  /// final result = await WaterbusSdk.instance.checkUsername(username: "testuser");
  /// if (result.isSuccess && result.data!) {
  ///   print('Username is available');
  /// } else {
  ///   print('Username is already taken');
  /// }
  /// ```
  Future<Result<bool>> checkUsername({required String username}) async {
    return await _sdk.checkUsername(username: username);
  }

  /// Get presigned URL for file upload
  ///
  /// Retrieves a presigned URL that can be used to upload files directly
  /// to cloud storage.
  ///
  /// Returns a [Result<PresignedUrl>] containing upload URL and metadata
  ///
  /// Example:
  /// ```dart
  /// final result = await WaterbusSdk.instance.getPresignedUrl();
  /// if (result.isSuccess) {
  ///   final presignedUrl = result.data!;
  ///   // Use presignedUrl.url to upload file
  /// }
  /// ```
  Future<Result<PresignedUrl>> getPresignedUrl() async {
    return await _sdk.getPresignedUrl();
  }

  /// Upload user avatar
  ///
  /// Uploads a user avatar image using the provided presigned URL.
  ///
  /// [image] The avatar image as bytes
  /// [presignedUrl] The presigned URL for upload
  /// [sourceUrl] The source URL where the image will be accessible
  ///
  /// Returns a [Result<String>] containing the uploaded image URL or an error
  ///
  /// Example:
  /// ```dart
  /// final imageBytes = await loadImageBytes('avatar.jpg');
  /// final presignedResult = await WaterbusSdk.instance.getPresignedUrl();
  ///
  /// if (presignedResult.isSuccess) {
  ///   final uploadResult = await WaterbusSdk.instance.uploadAvatar(
  ///     image: imageBytes,
  ///     presignedUrl: presignedResult.data!.url,
  ///     sourceUrl: presignedResult.data!.sourceUrl,
  ///   );
  ///
  ///   if (uploadResult.isSuccess) {
  ///     print('Avatar uploaded: ${uploadResult.data}');
  ///   }
  /// }
  /// ```
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
  ///
  /// Adds a user as a member to the specified room.
  ///
  /// [roomId] The ID of the room
  /// [userId] The ID of the user to add
  ///
  /// Returns a [Result<Room>] containing updated room information or an error
  ///
  /// Example:
  /// ```dart
  /// final result = await WaterbusSdk.instance.addMember(
  ///   roomId: 123,
  ///   userId: 456,
  /// );
  /// ```
  Future<Result<Room>> addMember({
    required int roomId,
    required int userId,
  }) async {
    return await _sdk.addMember(roomId: roomId, userId: userId);
  }

  /// Remove member from room
  ///
  /// Removes a user from the specified room.
  ///
  /// [roomId] The ID of the room
  /// [userId] The ID of the user to remove
  ///
  /// Returns a [Result<Room>] containing updated room information or an error
  ///
  /// Example:
  /// ```dart
  /// final result = await WaterbusSdk.instance.removeMember(
  ///   roomId: 123,
  ///   userId: 456,
  /// );
  /// ```
  Future<Result<Room>> removeMember({
    required int roomId,
    required int userId,
  }) async {
    return await _sdk.deleteMember(roomId: roomId, userId: userId);
  }

  /// Leave a conversation
  ///
  /// Leaves the specified conversation/room.
  ///
  /// [roomId] The ID of the room to leave
  ///
  /// Returns a [Result<Room>] containing updated room information or an error
  ///
  /// Example:
  /// ```dart
  /// final result = await WaterbusSdk.instance.leaveConversation(roomId: 123);
  /// ```
  Future<Result<Room>> leaveConversation({required int roomId}) async {
    return await _sdk.leaveConversation(roomId: roomId);
  }

  /// Archive a conversation
  ///
  /// Archives the specified conversation, moving it to the archived list.
  ///
  /// [roomId] The ID of the room to archive
  ///
  /// Returns a [Result<Room>] containing updated room information or an error
  ///
  /// Example:
  /// ```dart
  /// final result = await WaterbusSdk.instance.archiveConversation(roomId: 123);
  /// ```
  Future<Result<Room>> archiveConversation({required int roomId}) async {
    return await _sdk.archivedConversation(roomId: roomId);
  }

  /// Delete a conversation
  ///
  /// Permanently deletes the specified conversation.
  ///
  /// [conversationId] The ID of the conversation to delete
  ///
  /// Returns a [Result<bool>] indicating success or failure
  ///
  /// Example:
  /// ```dart
  /// final result = await WaterbusSdk.instance.deleteConversation(conversationId: 123);
  /// ```
  Future<Result<bool>> deleteConversation({required int conversationId}) async {
    return await _sdk.deleteConversation(conversationId);
  }

  /// Get list of conversations with pagination
  ///
  /// Retrieves a paginated list of conversations for the current user.
  ///
  /// [skip] Number of conversations to skip (for pagination)
  /// [limit] Maximum number of conversations to return (default: 10)
  ///
  /// Returns a [Result<List<Room>>] containing conversations or an error
  ///
  /// Example:
  /// ```dart
  /// final result = await WaterbusSdk.instance.getConversations(
  ///   skip: 0,
  ///   limit: 20,
  /// );
  ///
  /// if (result.isSuccess) {
  ///   for (final room in result.data!) {
  ///     print('Room: ${room.name}');
  ///   }
  /// }
  /// ```
  Future<Result<List<Room>>> getConversations({
    required int skip,
    int limit = 10,
  }) async {
    return await _sdk.getConversations(limit: limit, skip: skip);
  }

  /// Get list of archived conversations with pagination
  ///
  /// Retrieves a paginated list of archived conversations for the current user.
  ///
  /// [skip] Number of conversations to skip (for pagination)
  /// [limit] Maximum number of conversations to return (default: 10)
  ///
  /// Returns a [Result<List<Room>>] containing archived conversations or an error
  ///
  /// Example:
  /// ```dart
  /// final result = await WaterbusSdk.instance.getArchivedConversations(
  ///   skip: 0,
  ///   limit: 20,
  /// );
  /// ```
  Future<Result<List<Room>>> getArchivedConversations({
    required int skip,
    int limit = 10,
  }) async {
    return await _sdk.getArchivedConversations(limit: limit, skip: skip);
  }

  /// Update conversation settings
  ///
  /// Updates the settings of the specified conversation.
  ///
  /// [room] The room with updated settings
  /// [password] Optional new password for the room
  ///
  /// Returns a [Result<bool>] indicating success or failure
  ///
  /// Example:
  /// ```dart
  /// final result = await WaterbusSdk.instance.updateConversation(
  ///   room: updatedRoom,
  ///   password: "newpassword", // optional
  /// );
  /// ```
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
  ///
  /// Retrieves a paginated list of messages from the specified room.
  ///
  /// [roomId] The ID of the room
  /// [skip] Number of messages to skip (for pagination)
  /// [limit] Maximum number of messages to return (default: 10)
  ///
  /// Returns a [Result<List<Message>>] containing messages or an error
  ///
  /// Example:
  /// ```dart
  /// final result = await WaterbusSdk.instance.getMessages(
  ///   roomId: 123,
  ///   skip: 0,
  ///   limit: 50,
  /// );
  ///
  /// if (result.isSuccess) {
  ///   for (final message in result.data!) {
  ///     print('${message.sender.username}: ${message.data}');
  ///   }
  /// }
  /// ```
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
  ///
  /// Sends a text message to the specified room.
  ///
  /// [roomId] The ID of the room to send the message to
  /// [data] The message content
  ///
  /// Returns a [Result<Message?>] containing the sent message or an error
  ///
  /// Example:
  /// ```dart
  /// final result = await WaterbusSdk.instance.sendMessage(
  ///   roomId: 123,
  ///   data: "Hello, everyone!",
  /// );
  ///
  /// if (result.isSuccess && result.data != null) {
  ///   print('Message sent: ${result.data!.id}');
  /// }
  /// ```
  Future<Result<Message?>> sendMessage({
    required int roomId,
    required String data,
  }) async {
    return await _sdk.sendMessage(roomId: roomId, data: data);
  }

  /// Edit an existing message
  ///
  /// Updates the content of an existing message.
  ///
  /// [messageId] The ID of the message to edit
  /// [data] The new message content
  ///
  /// Returns a [Result<Message>] containing the updated message or an error
  ///
  /// Example:
  /// ```dart
  /// final result = await WaterbusSdk.instance.editMessage(
  ///   messageId: 456,
  ///   data: "Updated message content",
  /// );
  /// ```
  Future<Result<Message>> editMessage({
    required int messageId,
    required String data,
  }) async {
    return await _sdk.editMessage(messageId: messageId, data: data);
  }

  /// Delete a message
  ///
  /// Permanently deletes a message from the room.
  ///
  /// [messageId] The ID of the message to delete
  ///
  /// Returns a [Result<Message>] containing the deleted message or an error
  ///
  /// Example:
  /// ```dart
  /// final result = await WaterbusSdk.instance.deleteMessage(messageId: 456);
  /// ```
  Future<Result<Message>> deleteMessage({required int messageId}) async {
    return await _sdk.deleteMessage(messageId: messageId);
  }

  // =============================================================================
  // AUTHENTICATION
  // =============================================================================

  /// Create authentication token
  ///
  /// Authenticates the user and creates a session token for API access.
  ///
  /// [payload] Authentication payload containing credentials
  /// [callbackConnected] Optional callback function called when connection is established
  ///
  /// Returns a [Result<User>] containing user information or an error
  ///
  /// Example:
  /// ```dart
  /// final result = await WaterbusSdk.instance.createToken(
  ///   AuthPayload(
  ///     username: "user@example.com",
  ///     password: "password123",
  ///   ),
  ///   callbackConnected: () {
  ///     print('Successfully connected to Waterbus');
  ///   },
  /// );
  ///
  /// if (result.isSuccess) {
  ///   print('Authenticated as: ${result.data!.username}');
  /// }
  /// ```
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
  ///
  /// Logs out the current user and invalidates the session token.
  ///
  /// Returns a [Result<bool>] indicating success or failure
  ///
  /// Example:
  /// ```dart
  /// final result = await WaterbusSdk.instance.deleteToken();
  /// if (result.isSuccess) {
  ///   print('Successfully logged out');
  /// }
  /// ```
  Future<Result<bool>> deleteToken() async {
    return await _sdk.deleteToken();
  }

  /// Renew authentication token
  ///
  /// Refreshes the current authentication token to extend the session.
  ///
  /// Returns a [Result<bool>] indicating success or failure
  ///
  /// Example:
  /// ```dart
  /// final result = await WaterbusSdk.instance.renewToken();
  /// if (result.isSuccess) {
  ///   print('Token renewed successfully');
  /// }
  /// ```
  Future<Result<bool>> renewToken() async {
    return await _sdk.renewToken();
  }
}
