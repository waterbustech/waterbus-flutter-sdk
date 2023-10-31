library waterbus;

// Project imports:
import 'package:waterbus_sdk/injection/injection_container.dart';
import 'package:waterbus_sdk/interfaces/socket_handler_interface.dart';
import 'package:waterbus_sdk/models/index.dart';
import 'package:waterbus_sdk/sdk_core.dart';

export './models/index.dart';
export 'package:flutter_webrtc/flutter_webrtc.dart';

class WaterbusSdk {
  static String recordBenchmarkPath = '';
  static String waterbusUrl = '';

  void initial({
    required String waterbusUrl,
    String recordBenchmarkPath = '',
  }) {
    // Init dependency injection
    configureDependencies();

    WaterbusSdk.waterbusUrl = waterbusUrl;
    WaterbusSdk.recordBenchmarkPath = recordBenchmarkPath;
    _socketHandler.establishConnection();
  }

  Future<void> joinRoom({
    required String roomId,
    required int participantId,
    required Function(CallbackPayload) onNewEvent,
  }) async {
    await _sdk.joinRoom(
      roomId: roomId,
      participantId: participantId,
      onNewEvent: onNewEvent,
    );
  }

  Future<void> leaveRoom() async {
    await _sdk.leaveRoom();
  }

  // Related to local media
  Future<void> prepareMedia() async {
    await _sdk.prepareMedia();
  }

  Future<void> toggleVideo() async {
    await _sdk.toggleVideo();
  }

  Future<void> toggleAudio() async {
    await _sdk.toggleAudio();
  }

  Future<void> changeCallSetting(CallSetting setting) async {
    await _sdk.changeCallSettings(setting);
  }

  CallState get callState => _sdk.callState;

  // Private
  SdkCore get _sdk => getIt<SdkCore>();
  SocketHandler get _socketHandler => getIt<SocketHandler>();

  ///Singleton factory
  static final WaterbusSdk instance = WaterbusSdk._internal();

  factory WaterbusSdk() {
    return instance;
  }

  WaterbusSdk._internal();
}
