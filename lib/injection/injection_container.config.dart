// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes

// Package imports:
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

// Project imports:
import '../core/api/auth/auth_repository.dart' as _i11;
import '../core/api/base/base_remote_data.dart' as _i5;
import '../core/api/base/dio_configuration.dart' as _i14;
import '../core/api/meetings/meeting_repository.dart' as _i13;
import '../core/api/user/user_repository.dart' as _i12;
import '../core/webrtc/webrtc.dart' as _i17;
import '../core/webrtc/webrtc_interface.dart' as _i16;
import '../core/websocket/interfaces/socket_emiter_interface.dart' as _i9;
import '../core/websocket/interfaces/socket_handler_interface.dart' as _i20;
import '../core/websocket/socket_emiter.dart' as _i10;
import '../core/websocket/socket_handler.dart' as _i21;
import '../e2ee/frame_crypto.dart' as _i15;
import '../native/native_channel.dart' as _i3;
import '../native/replaykit.dart' as _i6;
import '../sdk_core.dart' as _i19;
import '../stats/webrtc_audio_stats.dart' as _i7;
import '../stats/webrtc_video_stats.dart' as _i8;
import '../utils/callkit/callkit_listener.dart' as _i18;
import '../utils/logger/logger.dart' as _i4;

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
  gh.singleton<_i5.BaseRemoteData>(() => _i5.BaseRemoteData());
  gh.singleton<_i6.ReplayKitChannel>(() => _i6.ReplayKitChannel());
  gh.singleton<_i7.WebRTCAudioStats>(() => _i7.WebRTCAudioStats());
  gh.singleton<_i8.WebRTCVideoStats>(() => _i8.WebRTCVideoStats());
  gh.factory<_i9.SocketEmiter>(() => _i10.SocketEmiterImpl());
  gh.lazySingleton<_i11.AuthRemoteDataSource>(
      () => _i11.AuthRemoteDataSourceImpl(gh<_i5.BaseRemoteData>()));
  gh.lazySingleton<_i12.UserRemoteDataSource>(
      () => _i12.UserRemoteDataSourceImpl(gh<_i5.BaseRemoteData>()));
  gh.lazySingleton<_i13.MeetingRemoteDataSource>(
      () => _i13.MeetingRemoteDataSourceImpl(gh<_i5.BaseRemoteData>()));
  gh.singleton<_i14.DioConfiguration>(
      () => _i14.DioConfiguration(gh<_i5.BaseRemoteData>()));
  gh.singleton<_i15.WebRTCFrameCrypto>(
      () => _i15.WebRTCFrameCrypto(gh<_i4.WaterbusLogger>()));
  gh.lazySingleton<_i16.WaterbusWebRTCManager>(
      () => _i17.WaterbusWebRTCManagerIpml(
            gh<_i15.WebRTCFrameCrypto>(),
            gh<_i9.SocketEmiter>(),
            gh<_i6.ReplayKitChannel>(),
            gh<_i3.NativeService>(),
            gh<_i8.WebRTCVideoStats>(),
            gh<_i7.WebRTCAudioStats>(),
          ));
  gh.singleton<_i18.CallKitListener>(() => _i18.CallKitListener(
        gh<_i4.WaterbusLogger>(),
        gh<_i16.WaterbusWebRTCManager>(),
      ));
  gh.singleton<_i19.SdkCore>(() => _i19.SdkCore(
        gh<_i16.WaterbusWebRTCManager>(),
        gh<_i6.ReplayKitChannel>(),
        gh<_i4.WaterbusLogger>(),
      ));
  gh.singleton<_i20.SocketHandler>(() => _i21.SocketHandlerImpl(
        gh<_i16.WaterbusWebRTCManager>(),
        gh<_i4.WaterbusLogger>(),
      ));
  return getIt;
}
