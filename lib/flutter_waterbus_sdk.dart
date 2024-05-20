library waterbus_sdk;

// Dart imports:
import 'dart:typed_data';

// Package imports:
import 'package:flutter_webrtc_plus/flutter_webrtc_plus.dart';

// Project imports:
import 'package:waterbus_sdk/core/api/auth/datasources/auth_local_datasource.dart';
import 'package:waterbus_sdk/core/api/base/base_remote_data.dart';
import 'package:waterbus_sdk/core/webrtc/webrtc_interface.dart';
import 'package:waterbus_sdk/core/websocket/interfaces/socket_handler_interface.dart';
import 'package:waterbus_sdk/injection/injection_container.dart';
import 'package:waterbus_sdk/sdk_core.dart';
import 'package:waterbus_sdk/types/index.dart';
import 'package:waterbus_sdk/types/models/auth_payload_model.dart';
import 'package:waterbus_sdk/utils/callkit/callkit_listener.dart';

export 'types/index.dart';
export './constants/constants.dart';
export 'package:flutter_webrtc_plus/flutter_webrtc_plus.dart';

class WaterbusSdk {
  static String recordBenchmarkPath = '';
  static String apiWaterbusUrl = '';
  static String wsWaterbusUrl = '';
  static Function(CallbackPayload)? onEventChanged;

  // ignore: use_setters_to_change_properties
  void onEventChangedRegister(Function(CallbackPayload) onEventChanged) {
    WaterbusSdk.onEventChanged = onEventChanged;
  }

  Future<void> initial({
    required String waterbusUrl,
    required String apiWaterbusUrl,
    String recordBenchmarkPath = '',
  }) async {
    // Init dependency injection if needed
    if (!getIt.isRegistered<WaterbusWebRTCManager>()) {
      configureDependencies();

      if (WebRTC.platformIsIOS) {
        _callKitListener.listenerEvents();
      }
    }

    WaterbusSdk.wsWaterbusUrl = waterbusUrl;
    WaterbusSdk.apiWaterbusUrl = apiWaterbusUrl;
    WaterbusSdk.recordBenchmarkPath = recordBenchmarkPath;

    await _baseRemoteData.initialize();

    _socketHandler.disconnection();
    _socketHandler.establishConnection(
      accessToken: AuthLocalDataSourceImpl().accessToken,
    );
  }

  Future<void> joinRoom({
    required String roomId,
    required int participantId,
  }) async {
    await _sdk.joinRoom(
      roomId: roomId,
      participantId: participantId,
    );
  }

  Future<void> subscribe(List<String> targetIds) async {
    await _sdk.subscribe(targetIds);
  }

  Future<void> leaveRoom() async {
    await _sdk.leaveRoom();
  }

  // Related to local media
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

  // Auth
  Future<User?> loginWithSocial({
    required AuthPayloadModel payloadModel,
  }) async {
    return await _sdk.loginWithSocial(payloadModel: payloadModel);
  }

  Future<bool> logOut() async {
    return await _sdk.logOut();
  }

  Future<bool?> handleRefreshToken() async {
    return await _sdk.handleRefreshToken();
  }

  // Meeting
  Future<Meeting?> createMeeting({
    required Meeting meeting,
    required String password,
    required int? userId,
  }) async {
    return await _sdk.createMeeting(
      meeting: meeting,
      password: password,
      userId: userId,
    );
  }

  Future<Meeting?> joinMeeting({
    required Meeting meeting,
    required String password,
    required int? userId,
  }) async {
    return await _sdk.joinMeeting(
      meeting: meeting,
      password: password,
      userId: userId,
    );
  }

  Future<Meeting?> updateMeeting({
    required Meeting meeting,
    required String password,
    required int? userId,
  }) async {
    return await _sdk.updateMeeting(
      meeting: meeting,
      password: password,
      userId: userId,
    );
  }

  Future<Meeting?> getInfoMeeting({required int code}) async {
    return await _sdk.getInfoMeeting(code: code);
  }

  static overrideToken(String accessToken, String refreshToken) {
    AuthLocalDataSourceImpl()
        .saveTokens(accessToken: accessToken, refreshToken: refreshToken);
  }

  CallState get callState => _sdk.callState;

  String get accessToken => _authLocalDataSourceImpl.accessToken;

  String get refreshToken => _authLocalDataSourceImpl.refreshToken;

  // Private
  SdkCore get _sdk => getIt<SdkCore>();
  SocketHandler get _socketHandler => getIt<SocketHandler>();
  CallKitListener get _callKitListener => getIt<CallKitListener>();
  BaseRemoteData get _baseRemoteData => getIt<BaseRemoteData>();
  AuthLocalDataSourceImpl get _authLocalDataSourceImpl =>
      AuthLocalDataSourceImpl();

  ///Singleton factory
  static final WaterbusSdk instance = WaterbusSdk._internal();

  factory WaterbusSdk() {
    return instance;
  }

  WaterbusSdk._internal();
}
