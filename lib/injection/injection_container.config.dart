// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import '../helpers/e2ee/frame_crypto.dart' as _i10;
import '../helpers/logger/logger.dart' as _i4;
import '../helpers/stats/webrtc_audio_stats.dart' as _i6;
import '../helpers/stats/webrtc_video_stats.dart' as _i7;
import '../interfaces/socket_emiter_interface.dart' as _i8;
import '../interfaces/socket_handler_interface.dart' as _i15;
import '../interfaces/webrtc_interface.dart' as _i11;
import '../method_channels/native_channel.dart' as _i3;
import '../method_channels/replaykit.dart' as _i5;
import '../sdk_core.dart' as _i13;
import '../services/callkit/callkit_listener.dart' as _i14;
import '../services/socket/socket_emiter.dart' as _i9;
import '../services/socket/socket_handler.dart' as _i16;
import '../services/webrtc/webrtc.dart' as _i12;

// initializes the registration of main-scope dependencies inside of GetIt
_i1.GetIt $initGetIt(
  _i1.GetIt getIt, {
  String? environment,
  _i2.EnvironmentFilter? environmentFilter,
}) {
  final gh = _i2.GetItHelper(
    getIt,
    environment,
    environmentFilter,
  );
  gh.factory<_i3.NativeService>(() => _i3.NativeService());
  gh.factory<_i4.WaterbusLogger>(() => _i4.WaterbusLogger());
  gh.singleton<_i5.ReplayKitChannel>(() => _i5.ReplayKitChannel());
  gh.singleton<_i6.WebRTCAudioStats>(() => _i6.WebRTCAudioStats());
  gh.singleton<_i7.WebRTCVideoStats>(() => _i7.WebRTCVideoStats());
  gh.factory<_i8.SocketEmiter>(() => _i9.SocketEmiterImpl());
  gh.singleton<_i10.WebRTCFrameCrypto>(
      () => _i10.WebRTCFrameCrypto(gh<_i4.WaterbusLogger>()));
  gh.lazySingleton<_i11.WaterbusWebRTCManager>(
      () => _i12.WaterbusWebRTCManagerIpml(
            gh<_i10.WebRTCFrameCrypto>(),
            gh<_i8.SocketEmiter>(),
            gh<_i5.ReplayKitChannel>(),
            gh<_i3.NativeService>(),
            gh<_i7.WebRTCVideoStats>(),
            gh<_i6.WebRTCAudioStats>(),
          ));
  gh.singleton<_i13.SdkCore>(() => _i13.SdkCore(
        gh<_i11.WaterbusWebRTCManager>(),
        gh<_i5.ReplayKitChannel>(),
        gh<_i4.WaterbusLogger>(),
      ));
  gh.singleton<_i14.CallKitListener>(() => _i14.CallKitListener(
        gh<_i4.WaterbusLogger>(),
        gh<_i11.WaterbusWebRTCManager>(),
      ));
  gh.singleton<_i15.SocketHandler>(() => _i16.SocketHandlerImpl(
        gh<_i11.WaterbusWebRTCManager>(),
        gh<_i4.WaterbusLogger>(),
      ));
  return getIt;
}
