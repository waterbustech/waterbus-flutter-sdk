// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import '../core/api/auth/datasources/auth_local_datasource.dart' as _i11;
import '../core/api/auth/datasources/auth_remote_datasource.dart' as _i20;
import '../core/api/auth/repositories/auth_repository.dart' as _i21;
import '../core/api/base/base_local_storage.dart' as _i5;
import '../core/api/base/base_remote_data.dart' as _i13;
import '../core/api/base/dio_configuration.dart' as _i18;
import '../core/api/meetings/repositories/meeting_repository.dart' as _i22;
import '../core/api/user/datasources/user_remote_datasource.dart' as _i16;
import '../core/api/user/repositories/user_repository.dart' as _i23;
import '../core/webrtc/webrtc.dart' as _i15;
import '../core/webrtc/webrtc_interface.dart' as _i14;
import '../core/websocket/interfaces/socket_emiter_interface.dart' as _i9;
import '../core/websocket/interfaces/socket_handler_interface.dart' as _i24;
import '../core/websocket/socket_emiter.dart' as _i10;
import '../core/websocket/socket_handler.dart' as _i25;
import '../e2ee/frame_crypto.dart' as _i12;
import '../native/native_channel.dart' as _i3;
import '../native/replaykit.dart' as _i6;
import '../stats/webrtc_audio_stats.dart' as _i7;
import '../stats/webrtc_video_stats.dart' as _i8;
import '../utils/callkit/callkit_listener.dart' as _i19;
import '../utils/logger/logger.dart' as _i4;
import '../waterbus_sdk_impl.dart' as _i27;
import '../waterbus_sdk_interface.dart' as _i26;

import '../core/api/meetings/datasources/meeting_remote_datesource.dart'
    as _i17;

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
  gh.singleton<_i5.BaseLocalData>(() => _i5.BaseLocalData());
  gh.singleton<_i6.ReplayKitChannel>(() => _i6.ReplayKitChannel());
  gh.singleton<_i7.WebRTCAudioStats>(() => _i7.WebRTCAudioStats());
  gh.singleton<_i8.WebRTCVideoStats>(() => _i8.WebRTCVideoStats());
  gh.factory<_i9.SocketEmiter>(() => _i10.SocketEmiterImpl());
  gh.lazySingleton<_i11.AuthLocalDataSource>(
      () => _i11.AuthLocalDataSourceImpl());
  gh.singleton<_i12.WebRTCFrameCrypto>(
      () => _i12.WebRTCFrameCrypto(gh<_i4.WaterbusLogger>()));
  gh.singleton<_i13.BaseRemoteData>(
      () => _i13.BaseRemoteData(gh<_i11.AuthLocalDataSource>()));
  gh.lazySingleton<_i14.WaterbusWebRTCManager>(
      () => _i15.WaterbusWebRTCManagerIpml(
            gh<_i12.WebRTCFrameCrypto>(),
            gh<_i9.SocketEmiter>(),
            gh<_i6.ReplayKitChannel>(),
            gh<_i3.NativeService>(),
            gh<_i8.WebRTCVideoStats>(),
            gh<_i7.WebRTCAudioStats>(),
          ));
  gh.lazySingleton<_i16.UserRemoteDataSource>(
      () => _i16.UserRemoteDataSourceImpl(gh<_i13.BaseRemoteData>()));
  gh.lazySingleton<_i17.MeetingRemoteDataSource>(
      () => _i17.MeetingRemoteDataSourceImpl(gh<_i13.BaseRemoteData>()));
  gh.singleton<_i18.DioConfiguration>(() => _i18.DioConfiguration(
        gh<_i13.BaseRemoteData>(),
        gh<_i11.AuthLocalDataSource>(),
      ));
  gh.singleton<_i19.CallKitListener>(() => _i19.CallKitListener(
        gh<_i4.WaterbusLogger>(),
        gh<_i14.WaterbusWebRTCManager>(),
      ));
  gh.lazySingleton<_i20.AuthRemoteDataSource>(
      () => _i20.AuthRemoteDataSourceImpl(
            gh<_i13.BaseRemoteData>(),
            gh<_i11.AuthLocalDataSource>(),
          ));
  gh.lazySingleton<_i21.AuthRepository>(() => _i21.AuthRepositoryImpl(
        gh<_i11.AuthLocalDataSource>(),
        gh<_i20.AuthRemoteDataSource>(),
      ));
  gh.lazySingleton<_i22.MeetingRepository>(
      () => _i22.MeetingRepositoryImpl(gh<_i17.MeetingRemoteDataSource>()));
  gh.lazySingleton<_i23.UserRepository>(
      () => _i23.UserRepositoryImpl(gh<_i16.UserRemoteDataSource>()));
  gh.singleton<_i24.SocketHandler>(() => _i25.SocketHandlerImpl(
        gh<_i14.WaterbusWebRTCManager>(),
        gh<_i4.WaterbusLogger>(),
        gh<_i11.AuthLocalDataSource>(),
        gh<_i18.DioConfiguration>(),
      ));
  gh.singleton<_i26.WaterbusSdkInterface>(() => _i27.SdkCore(
        gh<_i24.SocketHandler>(),
        gh<_i14.WaterbusWebRTCManager>(),
        gh<_i6.ReplayKitChannel>(),
        gh<_i5.BaseLocalData>(),
        gh<_i13.BaseRemoteData>(),
        gh<_i21.AuthRepository>(),
        gh<_i22.MeetingRepository>(),
        gh<_i23.UserRepository>(),
        gh<_i4.WaterbusLogger>(),
      ));
  return getIt;
}
