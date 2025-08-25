// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../core/api/auth/datasources/auth_local_data_source.dart' as _i801;
import '../core/api/auth/datasources/auth_remote_data_source.dart' as _i418;
import '../core/api/auth/repositories/auth_repository.dart' as _i824;
import '../core/api/base/base_remote_data.dart' as _i182;
import '../core/api/chat/datasources/chat_remote_data_source.dart' as _i692;
import '../core/api/chat/repositories/chat_repository.dart' as _i613;
import '../core/api/messages/repositories/message_repository.dart' as _i575;
import '../core/api/rooms/datasources/room_remote_data_source.dart' as _i652;
import '../core/api/rooms/repositories/room_repository.dart' as _i933;
import '../core/api/user/datasources/user_remote_data_source.dart' as _i76;
import '../core/api/user/repositories/user_repository.dart' as _i895;
import '../core/events/waterbus_event_system.dart' as _i405;
import '../core/rtc/e2ee/e2ee_manager.dart' as _i750;
import '../core/rtc/rtc_manager.dart' as _i937;
import '../core/rtc/rtc_manager_impl.dart' as _i1004;
import '../core/rtc/stats/rtc_audio_stats.dart' as _i2;
import '../core/rtc/stats/rtc_video_stats.dart' as _i980;
import '../core/ws/interfaces/ws_emitter.dart' as _i379;
import '../core/ws/interfaces/ws_handler.dart' as _i392;
import '../core/ws/ws_emitter_impl.dart' as _i407;
import '../core/ws/ws_handler_impl.dart' as _i694;
import '../native/native_channel.dart' as _i235;
import '../native/replaykit.dart' as _i124;
import '../utils/callkit/callkit_listener.dart' as _i324;
import '../utils/dio/dio_configuration.dart' as _i514;
import '../waterbus_sdk_impl.dart' as _i1039;
import '../waterbus_sdk_interface.dart' as _i513;

import '../core/api/messages/datasources/message_remote_data_source.dart'
    as _i647;

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
  gh.singleton<_i750.EncryptionManager>(() => _i750.EncryptionManager());
  gh.singleton<_i980.RtcVideoStats>(() => _i980.RtcVideoStats());
  gh.singleton<_i2.RtcAudioStats>(() => _i2.RtcAudioStats());
  gh.singleton<_i124.ReplayKitChannel>(() => _i124.ReplayKitChannel());
  gh.lazySingleton<_i405.WaterbusEventSystem>(
      () => _i405.WaterbusEventSystem());
  gh.factory<_i379.WsEmitter>(() => _i407.WsEmitterImpl());
  gh.lazySingleton<_i801.AuthLocalDataSource>(
      () => _i801.AuthLocalDataSourceImpl());
  gh.singleton<_i182.BaseRemoteData>(
      () => _i182.BaseRemoteData(gh<_i801.AuthLocalDataSource>()));
  gh.lazySingleton<_i418.AuthRemoteDataSource>(
      () => _i418.AuthRemoteDataSourceImpl(
            gh<_i182.BaseRemoteData>(),
            gh<_i801.AuthLocalDataSource>(),
          ));
  gh.lazySingleton<_i824.AuthRepository>(() => _i824.AuthRepositoryImpl(
        gh<_i801.AuthLocalDataSource>(),
        gh<_i418.AuthRemoteDataSource>(),
      ));
  gh.lazySingleton<_i76.UserRemoteDataSource>(
      () => _i76.UserRemoteDataSourceImpl(gh<_i182.BaseRemoteData>()));
  gh.lazySingleton<_i652.RoomRemoteDataSource>(
      () => _i652.RoomRemoteDataSourceImpl(gh<_i182.BaseRemoteData>()));
  gh.factory<_i692.ChatRemoteDataSource>(
      () => _i692.ChatRemoteDataSourceImpl(gh<_i182.BaseRemoteData>()));
  gh.factory<_i647.MessageRemoteDataSource>(
      () => _i647.MessageRemoteDataSourceImpl(gh<_i182.BaseRemoteData>()));
  gh.factory<_i575.MessageRepository>(
      () => _i575.MessageRepositoryImpl(gh<_i647.MessageRemoteDataSource>()));
  gh.singleton<_i514.DioConfiguration>(() => _i514.DioConfiguration(
        gh<_i182.BaseRemoteData>(),
        gh<_i801.AuthLocalDataSource>(),
      ));
  gh.lazySingleton<_i895.UserRepository>(
      () => _i895.UserRepositoryImpl(gh<_i76.UserRemoteDataSource>()));
  gh.lazySingleton<_i937.RtcManager>(() => _i1004.RtcManagerIpml(
        gh<_i750.EncryptionManager>(),
        gh<_i379.WsEmitter>(),
        gh<_i124.ReplayKitChannel>(),
        gh<_i235.NativeService>(),
        gh<_i980.RtcVideoStats>(),
        gh<_i2.RtcAudioStats>(),
        gh<_i824.AuthRepository>(),
      ));
  gh.lazySingleton<_i933.RoomRepository>(
      () => _i933.RoomRepositoryImpl(gh<_i652.RoomRemoteDataSource>()));
  gh.factory<_i613.ChatRepository>(
      () => _i613.ChatRepositoryImpl(gh<_i692.ChatRemoteDataSource>()));
  gh.singleton<_i324.CallKitListener>(
      () => _i324.CallKitListener(gh<_i937.RtcManager>()));
  gh.singleton<_i392.WsHandler>(() => _i694.WsHandlerImpl(
        gh<_i937.RtcManager>(),
        gh<_i801.AuthLocalDataSource>(),
        gh<_i514.DioConfiguration>(),
        gh<_i405.WaterbusEventSystem>(),
      ));
  gh.singleton<_i513.WaterbusSdkInterface>(() => _i1039.SdkCore(
        gh<_i392.WsHandler>(),
        gh<_i379.WsEmitter>(),
        gh<_i937.RtcManager>(),
        gh<_i124.ReplayKitChannel>(),
        gh<_i182.BaseRemoteData>(),
        gh<_i824.AuthRepository>(),
        gh<_i933.RoomRepository>(),
        gh<_i895.UserRepository>(),
        gh<_i613.ChatRepository>(),
        gh<_i575.MessageRepository>(),
      ));
  return getIt;
}
