library waterbus_sdk;

// Project imports:
import 'dart:typed_data';

import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:waterbus_sdk/injection/injection_container.dart';
import 'package:waterbus_sdk/interfaces/socket_handler_interface.dart';
import 'package:waterbus_sdk/models/index.dart';
import 'package:waterbus_sdk/sdk_core.dart';
import 'package:waterbus_sdk/services/callkit/callkit_listener.dart';

export './models/index.dart';
export 'package:flutter_webrtc/flutter_webrtc.dart';

class WaterbusSdk {
  static String recordBenchmarkPath = '';
  static String waterbusUrl = '';
  static Function(CallbackPayload)? onEventChanged;

  // ignore: use_setters_to_change_properties
  void onEventChangedRegister(Function(CallbackPayload) onEventChanged) {
    WaterbusSdk.onEventChanged = onEventChanged;
  }

  void initial({
    required String waterbusUrl,
    String recordBenchmarkPath = '',
  }) {
    // Init dependency injection
    configureDependencies();

    WaterbusSdk.waterbusUrl = waterbusUrl;
    WaterbusSdk.recordBenchmarkPath = recordBenchmarkPath;

    if (WebRTC.platformIsIOS) {
      _callKitListener.listenerEvents();
    }

    _socketHandler.establishConnection();
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

  Future<List<WebRTCCodec>> filterSupportedCodecs() async {
    final List<WebRTCCodec> supportedCodecs = [];

    for (final codec in WebRTCCodec.values) {
      if (await codec.isPlatformSupported()) {
        supportedCodecs.add(codec);
      }
    }

    return supportedCodecs;
  }

  CallState get callState => _sdk.callState;

  // Private
  SdkCore get _sdk => getIt<SdkCore>();
  SocketHandler get _socketHandler => getIt<SocketHandler>();
  CallKitListener get _callKitListener => getIt<CallKitListener>();

  ///Singleton factory
  static final WaterbusSdk instance = WaterbusSdk._internal();

  factory WaterbusSdk() {
    return instance;
  }

  WaterbusSdk._internal();
}
