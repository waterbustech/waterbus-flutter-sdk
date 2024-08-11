// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../core/api/auth/datasources/auth_local_datasource.dart' as _i828;
import '../core/api/auth/datasources/auth_remote_datasource.dart' as _i997;
import '../core/api/auth/repositories/auth_repository.dart' as _i824;
import '../core/api/base/base_remote_data.dart' as _i182;
import '../core/api/base/dio_configuration.dart' as _i314;
import '../core/api/chat/datasources/chat_remote_datasource.dart' as _i712;
import '../core/api/chat/repositories/chat_repository.dart' as _i613;
import '../core/api/meetings/repositories/meeting_repository.dart' as _i1023;
import '../core/api/messages/repositories/message_repository.dart' as _i575;
import '../core/api/user/datasources/user_remote_datasource.dart' as _i1054;
import '../core/api/user/repositories/user_repository.dart' as _i895;
import '../core/webrtc/webrtc.dart' as _i388;
import '../core/webrtc/webrtc_interface.dart' as _i413;
import '../core/websocket/interfaces/socket_emiter_interface.dart' as _i530;
import '../core/websocket/interfaces/socket_handler_interface.dart' as _i976;
import '../core/websocket/socket_emiter.dart' as _i515;
import '../core/websocket/socket_handler.dart' as _i1068;
import '../e2ee/frame_crypto.dart' as _i602;
import '../native/native_channel.dart' as _i235;
import '../native/replaykit.dart' as _i124;
import '../stats/webrtc_audio_stats.dart' as _i245;
import '../stats/webrtc_video_stats.dart' as _i232;
import '../utils/callkit/callkit_listener.dart' as _i324;
import '../utils/logger/logger.dart' as _i944;
import '../waterbus_sdk_impl.dart' as _i1039;
import '../waterbus_sdk_interface.dart' as _i513;

import '../core/api/meetings/datasources/meeting_remote_datesource.dart'
    as _i377;
import '../core/api/messages/datasources/message_remote_datasource.dart'
    as _i242;

// initializes the registration of main-scope dependencies inside of GetIt
_i174.GetIt $initGetIt(
  _i174.GetIt getIt, {
  String? environment,
  _i526.EnvironmentFilter? environmentFilter,
}) {
  final gh = _i526.GetItHelper(
    getIt,
    environment,
    environmentFilter,
  );
  gh.factory<_i235.NativeService>(() => _i235.NativeService());
  gh.factory<_i944.WaterbusLogger>(() => _i944.WaterbusLogger());
  gh.singleton<_i124.ReplayKitChannel>(() => _i124.ReplayKitChannel());
  gh.singleton<_i245.WebRTCAudioStats>(() => _i245.WebRTCAudioStats());
  gh.singleton<_i232.WebRTCVideoStats>(() => _i232.WebRTCVideoStats());
  gh.factory<_i530.SocketEmiter>(() => _i515.SocketEmiterImpl());
  gh.lazySingleton<_i828.AuthLocalDataSource>(
      () => _i828.AuthLocalDataSourceImpl());
  gh.singleton<_i602.WebRTCFrameCrypto>(
      () => _i602.WebRTCFrameCrypto(gh<_i944.WaterbusLogger>()));
  gh.singleton<_i182.BaseRemoteData>(
      () => _i182.BaseRemoteData(gh<_i828.AuthLocalDataSource>()));
  gh.lazySingleton<_i413.WaterbusWebRTCManager>(
      () => _i388.WaterbusWebRTCManagerIpml(
            gh<_i602.WebRTCFrameCrypto>(),
            gh<_i530.SocketEmiter>(),
            gh<_i124.ReplayKitChannel>(),
            gh<_i235.NativeService>(),
            gh<_i232.WebRTCVideoStats>(),
            gh<_i245.WebRTCAudioStats>(),
          ));
  gh.lazySingleton<_i1054.UserRemoteDataSource>(
      () => _i1054.UserRemoteDataSourceImpl(gh<_i182.BaseRemoteData>()));
  gh.lazySingleton<_i377.MeetingRemoteDataSource>(
      () => _i377.MeetingRemoteDataSourceImpl(gh<_i182.BaseRemoteData>()));
  gh.lazySingleton<_i242.MessageRemoteDataSource>(
      () => _i242.MessageRemoteDataSourceImpl(gh<_i182.BaseRemoteData>()));
  gh.singleton<_i314.DioConfiguration>(() => _i314.DioConfiguration(
        gh<_i182.BaseRemoteData>(),
        gh<_i828.AuthLocalDataSource>(),
      ));
  gh.singleton<_i324.CallKitListener>(() => _i324.CallKitListener(
        gh<_i944.WaterbusLogger>(),
        gh<_i413.WaterbusWebRTCManager>(),
      ));
  gh.lazySingleton<_i997.AuthRemoteDataSource>(
      () => _i997.AuthRemoteDataSourceImpl(
            gh<_i182.BaseRemoteData>(),
            gh<_i828.AuthLocalDataSource>(),
          ));
  gh.lazySingleton<_i712.ChatRemoteDataSource>(
      () => _i712.ChatRemoteDataSourceImpl(gh<_i182.BaseRemoteData>()));
  gh.lazySingleton<_i824.AuthRepository>(() => _i824.AuthRepositoryImpl(
        gh<_i828.AuthLocalDataSource>(),
        gh<_i997.AuthRemoteDataSource>(),
      ));
  gh.lazySingleton<_i1023.MeetingRepository>(
      () => _i1023.MeetingRepositoryImpl(gh<_i377.MeetingRemoteDataSource>()));
  gh.lazySingleton<_i575.MessageRepository>(
      () => _i575.MessageRepositoryImpl(gh<_i242.MessageRemoteDataSource>()));
  gh.lazySingleton<_i895.UserRepository>(
      () => _i895.UserRepositoryImpl(gh<_i1054.UserRemoteDataSource>()));
  gh.lazySingleton<_i613.ChatRepository>(
      () => _i613.ChatRepositoryImpl(gh<_i712.ChatRemoteDataSource>()));
  gh.singleton<_i976.SocketHandler>(() => _i1068.SocketHandlerImpl(
        gh<_i413.WaterbusWebRTCManager>(),
        gh<_i944.WaterbusLogger>(),
        gh<_i828.AuthLocalDataSource>(),
        gh<_i314.DioConfiguration>(),
      ));
  gh.singleton<_i513.WaterbusSdkInterface>(() => _i1039.SdkCore(
        gh<_i976.SocketHandler>(),
        gh<_i530.SocketEmiter>(),
        gh<_i413.WaterbusWebRTCManager>(),
        gh<_i124.ReplayKitChannel>(),
        gh<_i182.BaseRemoteData>(),
        gh<_i824.AuthRepository>(),
        gh<_i1023.MeetingRepository>(),
        gh<_i895.UserRepository>(),
        gh<_i613.ChatRepository>(),
        gh<_i575.MessageRepository>(),
        gh<_i944.WaterbusLogger>(),
      ));
  return getIt;
}
