// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import '../core/api/auth/datasources/auth_local_datasource.dart' as _i10;
import '../core/api/auth/datasources/auth_remote_datasource.dart' as _i20;
import '../core/api/auth/repositories/auth_repository.dart' as _i22;
import '../core/api/base/base_remote_data.dart' as _i12;
import '../core/api/base/dio_configuration.dart' as _i18;
import '../core/api/chat/datasources/chat_remote_datasource.dart' as _i21;
import '../core/api/chat/repositories/chat_repository.dart' as _i26;
import '../core/api/meetings/repositories/meeting_repository.dart' as _i23;
import '../core/api/messages/repositories/message_repository.dart' as _i24;
import '../core/api/user/datasources/user_remote_datasource.dart' as _i15;
import '../core/api/user/repositories/user_repository.dart' as _i25;
import '../core/webrtc/webrtc.dart' as _i14;
import '../core/webrtc/webrtc_interface.dart' as _i13;
import '../core/websocket/interfaces/socket_emiter_interface.dart' as _i8;
import '../core/websocket/interfaces/socket_handler_interface.dart' as _i27;
import '../core/websocket/socket_emiter.dart' as _i9;
import '../core/websocket/socket_handler.dart' as _i28;
import '../e2ee/frame_crypto.dart' as _i11;
import '../native/native_channel.dart' as _i3;
import '../native/replaykit.dart' as _i5;
import '../stats/webrtc_audio_stats.dart' as _i6;
import '../stats/webrtc_video_stats.dart' as _i7;
import '../utils/callkit/callkit_listener.dart' as _i19;
import '../utils/logger/logger.dart' as _i4;
import '../waterbus_sdk_impl.dart' as _i30;
import '../waterbus_sdk_interface.dart' as _i29;

import '../core/api/meetings/datasources/meeting_remote_datesource.dart'
    as _i16;
import '../core/api/messages/datasources/message_remote_datasource.dart'
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
  gh.singleton<_i5.ReplayKitChannel>(() => _i5.ReplayKitChannel());
  gh.singleton<_i6.WebRTCAudioStats>(() => _i6.WebRTCAudioStats());
  gh.singleton<_i7.WebRTCVideoStats>(() => _i7.WebRTCVideoStats());
  gh.factory<_i8.SocketEmiter>(() => _i9.SocketEmiterImpl());
  gh.lazySingleton<_i10.AuthLocalDataSource>(
      () => _i10.AuthLocalDataSourceImpl());
  gh.singleton<_i11.WebRTCFrameCrypto>(
      () => _i11.WebRTCFrameCrypto(gh<_i4.WaterbusLogger>()));
  gh.singleton<_i12.BaseRemoteData>(
      () => _i12.BaseRemoteData(gh<_i10.AuthLocalDataSource>()));
  gh.lazySingleton<_i13.WaterbusWebRTCManager>(
      () => _i14.WaterbusWebRTCManagerIpml(
            gh<_i11.WebRTCFrameCrypto>(),
            gh<_i8.SocketEmiter>(),
            gh<_i5.ReplayKitChannel>(),
            gh<_i3.NativeService>(),
            gh<_i7.WebRTCVideoStats>(),
            gh<_i6.WebRTCAudioStats>(),
          ));
  gh.lazySingleton<_i15.UserRemoteDataSource>(
      () => _i15.UserRemoteDataSourceImpl(gh<_i12.BaseRemoteData>()));
  gh.lazySingleton<_i16.MeetingRemoteDataSource>(
      () => _i16.MeetingRemoteDataSourceImpl(gh<_i12.BaseRemoteData>()));
  gh.lazySingleton<_i17.MessageRemoteDataSource>(
      () => _i17.MessageRemoteDataSourceImpl(gh<_i12.BaseRemoteData>()));
  gh.singleton<_i18.DioConfiguration>(() => _i18.DioConfiguration(
        gh<_i12.BaseRemoteData>(),
        gh<_i10.AuthLocalDataSource>(),
      ));
  gh.singleton<_i19.CallKitListener>(() => _i19.CallKitListener(
        gh<_i4.WaterbusLogger>(),
        gh<_i13.WaterbusWebRTCManager>(),
      ));
  gh.lazySingleton<_i20.AuthRemoteDataSource>(
      () => _i20.AuthRemoteDataSourceImpl(
            gh<_i12.BaseRemoteData>(),
            gh<_i10.AuthLocalDataSource>(),
          ));
  gh.lazySingleton<_i21.ChatRemoteDataSource>(
      () => _i21.ChatRemoteDataSourceImpl(gh<_i12.BaseRemoteData>()));
  gh.lazySingleton<_i22.AuthRepository>(() => _i22.AuthRepositoryImpl(
        gh<_i10.AuthLocalDataSource>(),
        gh<_i20.AuthRemoteDataSource>(),
      ));
  gh.lazySingleton<_i23.MeetingRepository>(
      () => _i23.MeetingRepositoryImpl(gh<_i16.MeetingRemoteDataSource>()));
  gh.lazySingleton<_i24.MessageRepository>(
      () => _i24.MessageRepositoryImpl(gh<_i17.MessageRemoteDataSource>()));
  gh.lazySingleton<_i25.UserRepository>(
      () => _i25.UserRepositoryImpl(gh<_i15.UserRemoteDataSource>()));
  gh.lazySingleton<_i26.ChatRepository>(
      () => _i26.ChatRepositoryImpl(gh<_i21.ChatRemoteDataSource>()));
  gh.singleton<_i27.SocketHandler>(() => _i28.SocketHandlerImpl(
        gh<_i13.WaterbusWebRTCManager>(),
        gh<_i4.WaterbusLogger>(),
        gh<_i10.AuthLocalDataSource>(),
        gh<_i18.DioConfiguration>(),
      ));
  gh.singleton<_i29.WaterbusSdkInterface>(() => _i30.SdkCore(
        gh<_i27.SocketHandler>(),
        gh<_i13.WaterbusWebRTCManager>(),
        gh<_i5.ReplayKitChannel>(),
        gh<_i12.BaseRemoteData>(),
        gh<_i22.AuthRepository>(),
        gh<_i23.MeetingRepository>(),
        gh<_i25.UserRepository>(),
        gh<_i26.ChatRepository>(),
        gh<_i24.MessageRepository>(),
        gh<_i4.WaterbusLogger>(),
      ));
  return getIt;
}
