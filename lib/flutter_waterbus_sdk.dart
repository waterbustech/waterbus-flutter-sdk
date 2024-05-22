library waterbus_sdk;

import 'dart:typed_data';

import 'package:flutter_webrtc_plus/flutter_webrtc_plus.dart';

import 'package:waterbus_sdk/core/api/auth/datasources/auth_local_datasource.dart';
import 'package:waterbus_sdk/core/api/base/base_remote_data.dart';
import 'package:waterbus_sdk/core/webrtc/webrtc_interface.dart';
import 'package:waterbus_sdk/core/websocket/interfaces/socket_handler_interface.dart';
import 'package:waterbus_sdk/injection/injection_container.dart';
import 'package:waterbus_sdk/types/index.dart';
import 'package:waterbus_sdk/utils/callkit/callkit_listener.dart';
import 'package:waterbus_sdk/waterbus_sdk_interface.dart';

export 'types/index.dart';
export './constants/constants.dart';
export 'package:flutter_webrtc_plus/flutter_webrtc_plus.dart';

class WaterbusSdk {
  static String recordBenchmarkPath = '';
  static String apiWaterbusUrl = '';
  static String wsWaterbusUrl = '';
  static Function(CallbackPayload)? onEventChanged;

  set onEventChangedRegister(Function(CallbackPayload) onEventChanged) {
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
    _socketHandler.establishConnection();

    _sdk.initialize();
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
  Future<User?> createToken(AuthPayloadModel payload) async {
    return await _sdk.createToken(payload: payload);
  }

  Future<bool> deleteToken() async {
    return await _sdk.deleteToken();
  }

  Future<bool?> renewToken() async {
    return await _sdk.refreshToken();
  }

  static overrideToken(String accessToken, String refreshToken) {
    AuthLocalDataSourceImpl()
        .saveTokens(accessToken: accessToken, refreshToken: refreshToken);
  }

  CallState get callState => _sdk.callState;

  String get accessToken => _authLocalDataSourceImpl.accessToken;

  String get refreshToken => _authLocalDataSourceImpl.refreshToken;

  // Private
  WaterbusSdkInterface get _sdk => getIt<WaterbusSdkInterface>();
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
