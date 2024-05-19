library waterbus_sdk;

// Dart imports:
import 'dart:typed_data';

// Package imports:
import 'package:dartz/dartz.dart';
import 'package:flutter_webrtc_plus/flutter_webrtc_plus.dart';

// Project imports:
import 'package:waterbus_sdk/core/api/auth/datasources/auth_local_datasource.dart';
import 'package:waterbus_sdk/core/api/auth/usecases/auth_usecases.dart';
import 'package:waterbus_sdk/core/api/base/base_remote_data.dart';
import 'package:waterbus_sdk/core/api/meetings/usecases/meeting_usecases.dart';
import 'package:waterbus_sdk/core/api/user/usecases/use_usecases.dart';
import 'package:waterbus_sdk/core/webrtc/webrtc_interface.dart';
import 'package:waterbus_sdk/core/websocket/interfaces/socket_handler_interface.dart';
import 'package:waterbus_sdk/injection/injection_container.dart';
import 'package:waterbus_sdk/sdk_core.dart';
import 'package:waterbus_sdk/types/error/failures.dart';
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
  Future<Either<Failure, User>> getProfile() async {
    return await _useUsecases.getProfile();
  }

  Future<Either<Failure, User>> updateProfile({required User user}) async {
    return await _useUsecases.updateProfile(user);
  }

  Future<Either<Failure, bool>> updateUsername({
    required String username,
  }) async {
    return await _useUsecases.updateUsername(username);
  }

  Future<Either<Failure, bool>> checkUsername({
    required String username,
  }) async {
    return await _useUsecases.checkUsername(username);
  }

  Future<Either<Failure, String>> getPresignedUrl() async {
    return await _useUsecases.getPresignedUrl();
  }

  Future<Either<Failure, String>> uploadAvatar({
    required Uint8List image,
    required String uploadUrl,
  }) async {
    return await _useUsecases.uploadAvatar(image, uploadUrl);
  }

  // Auth
  Future<Either<Failure, User>> loginWithSocial({
    required AuthPayloadModel payloadModel,
  }) async {
    return await _authUsecases.loginWithSocial(payloadModel);
  }

  Future<Either<Failure, bool>> logOut() async {
    return await _authUsecases.logOut();
  }

  Future<Either<Failure, bool>> handleRefreshToken() async {
    return await _authUsecases.refreshToken();
  }

  // Meeting
  Future<Either<Failure, Meeting>> createMeeting({
    required Meeting meeting,
    required String password,
    required int? userId,
  }) async {
    return await _meetingUsecases.createMeeting(meeting, password, userId);
  }

  Future<Either<Failure, Meeting>> joinMeeting({
    required Meeting meeting,
    required String password,
    required int? userId,
  }) async {
    return await _meetingUsecases.joinMeeting(meeting, password, userId);
  }

  Future<Either<Failure, Meeting>> updateMeeting({
    required Meeting meeting,
    required String password,
    required int? userId,
  }) async {
    return await _meetingUsecases.updateMeeting(meeting, password, userId);
  }

  Future<Either<Failure, Meeting>> getInfoMeeting({required int code}) async {
    return await _meetingUsecases.getInfoMeeting(code);
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
  UseUsecases get _useUsecases => getIt<UseUsecases>();
  AuthUsecases get _authUsecases => getIt<AuthUsecases>();
  MeetingUsecases get _meetingUsecases => getIt<MeetingUsecases>();
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
