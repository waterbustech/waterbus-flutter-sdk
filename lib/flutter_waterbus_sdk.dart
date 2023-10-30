library waterbus;

import 'package:waterbus/injection/injection_container.dart';
import 'package:waterbus/models/index.dart';
import 'package:waterbus/sdk_core.dart';

export './models/index.dart';

class WaterbusSdk {
  static String recordBenchmarkPath = '';
  static String waterbusUrl = '';

  void initial({
    required String waterbusUrl,
    String recordBenchmarkPath = '',
  }) {
    WaterbusSdk.waterbusUrl = waterbusUrl;
    WaterbusSdk.recordBenchmarkPath = recordBenchmarkPath;
  }

  Future<void> joinRoom({
    required String roomId,
    required int participantId,
    required Function(CallbackPayload) onNewEvent,
  }) async {
    await sdk.joinRoom(
      roomId: roomId,
      participantId: participantId,
      onNewEvent: onNewEvent,
    );
  }

  Future<void> leaveRoom() async {
    await sdk.leaveRoom();
  }

  // Related to local media
  Future<void> prepareMedia() async {
    await sdk.prepareMedia();
  }

  Future<void> toggleVideo() async {
    await sdk.toggleVideo();
  }

  Future<void> toggleAudio() async {
    await sdk.toggleAudio();
  }

  Future<void> changeCallSetting(CallSetting setting) async {
    await sdk.changeCallSettings(setting);
  }

  // Private
  SdkCore get sdk => getIt.get<SdkCore>();

  ///Singleton factory
  static final WaterbusSdk instance = WaterbusSdk._internal();

  factory WaterbusSdk() {
    return instance;
  }

  WaterbusSdk._internal();
}
