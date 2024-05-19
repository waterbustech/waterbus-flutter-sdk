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
import '../core/api/auth/datasources/auth_local_datasource.dart' as _i11;
import '../core/api/auth/datasources/auth_remote_datasource.dart' as _i14;
import '../core/api/auth/repositories/auth_repository.dart' as _i16;
import '../core/api/auth/usecases/auth_usecases.dart' as _i36;
import '../core/api/auth/usecases/index.dart' as _i37;
import '../core/api/auth/usecases/login_with_social.dart' as _i24;
import '../core/api/auth/usecases/logout.dart' as _i25;
import '../core/api/auth/usecases/refresh_token.dart' as _i26;
import '../core/api/base/base_remote_data.dart' as _i5;
import '../core/api/base/dio_configuration.dart' as _i17;
import '../core/api/meetings/repositories/meeting_repository.dart' as _i18;
import '../core/api/meetings/usecases/create_meeting.dart' as _i20;
import '../core/api/meetings/usecases/get_info_meeting.dart' as _i23;
import '../core/api/meetings/usecases/index.dart' as _i44;
import '../core/api/meetings/usecases/join_meeting.dart' as _i21;
import '../core/api/meetings/usecases/meeting_usecases.dart' as _i43;
import '../core/api/meetings/usecases/update_meeting.dart' as _i22;
import '../core/api/user/datasources/user_remote_datasource.dart' as _i12;
import '../core/api/user/repositories/user_repository.dart' as _i19;
import '../core/api/user/usecases/check_username.dart' as _i32;
import '../core/api/user/usecases/get_presigned_url.dart' as _i31;
import '../core/api/user/usecases/get_profile.dart' as _i33;
import '../core/api/user/usecases/index.dart' as _i40;
import '../core/api/user/usecases/update_profile.dart' as _i30;
import '../core/api/user/usecases/update_username.dart' as _i29;
import '../core/api/user/usecases/upload_avatar.dart' as _i34;
import '../core/api/user/usecases/use_usecases.dart' as _i39;
import '../core/webrtc/webrtc.dart' as _i28;
import '../core/webrtc/webrtc_interface.dart' as _i27;
import '../core/websocket/interfaces/socket_emiter_interface.dart' as _i9;
import '../core/websocket/interfaces/socket_handler_interface.dart' as _i41;
import '../core/websocket/socket_emiter.dart' as _i10;
import '../core/websocket/socket_handler.dart' as _i42;
import '../e2ee/frame_crypto.dart' as _i15;
import '../native/native_channel.dart' as _i3;
import '../native/replaykit.dart' as _i6;
import '../sdk_core.dart' as _i38;
import '../stats/webrtc_audio_stats.dart' as _i7;
import '../stats/webrtc_video_stats.dart' as _i8;
import '../utils/callkit/callkit_listener.dart' as _i35;
import '../utils/logger/logger.dart' as _i4;

import '../core/api/meetings/datasources/meeting_remote_datesource.dart'
    as _i13;

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
  gh.lazySingleton<_i11.AuthLocalDataSource>(
      () => _i11.AuthLocalDataSourceImpl());
  gh.lazySingleton<_i12.UserRemoteDataSource>(
      () => _i12.UserRemoteDataSourceImpl(gh<_i5.BaseRemoteData>()));
  gh.lazySingleton<_i13.MeetingRemoteDataSource>(
      () => _i13.MeetingRemoteDataSourceImpl(gh<_i5.BaseRemoteData>()));
  gh.lazySingleton<_i14.AuthRemoteDataSource>(
      () => _i14.AuthRemoteDataSourceImpl(
            gh<_i5.BaseRemoteData>(),
            gh<_i11.AuthLocalDataSource>(),
          ));
  gh.singleton<_i15.WebRTCFrameCrypto>(
      () => _i15.WebRTCFrameCrypto(gh<_i4.WaterbusLogger>()));
  gh.lazySingleton<_i16.AuthRepository>(() => _i16.AuthRepositoryImpl(
        gh<_i11.AuthLocalDataSource>(),
        gh<_i14.AuthRemoteDataSource>(),
      ));
  gh.singleton<_i17.DioConfiguration>(() => _i17.DioConfiguration(
        gh<_i5.BaseRemoteData>(),
        gh<_i11.AuthLocalDataSource>(),
      ));
  gh.lazySingleton<_i18.MeetingRepository>(
      () => _i18.MeetingRepositoryImpl(gh<_i13.MeetingRemoteDataSource>()));
  gh.lazySingleton<_i19.UserRepository>(
      () => _i19.UserRepositoryImpl(gh<_i12.UserRemoteDataSource>()));
  gh.factory<_i20.CreateMeeting>(
      () => _i20.CreateMeeting(gh<_i18.MeetingRepository>()));
  gh.factory<_i21.JoinMeeting>(
      () => _i21.JoinMeeting(gh<_i18.MeetingRepository>()));
  gh.factory<_i22.UpdateMeeting>(
      () => _i22.UpdateMeeting(gh<_i18.MeetingRepository>()));
  gh.factory<_i23.GetInfoMeeting>(
      () => _i23.GetInfoMeeting(gh<_i18.MeetingRepository>()));
  gh.factory<_i24.LoginWithSocial>(
      () => _i24.LoginWithSocial(gh<_i16.AuthRepository>()));
  gh.factory<_i25.LogOut>(() => _i25.LogOut(gh<_i16.AuthRepository>()));
  gh.factory<_i26.RefreshToken>(
      () => _i26.RefreshToken(gh<_i16.AuthRepository>()));
  gh.lazySingleton<_i27.WaterbusWebRTCManager>(
      () => _i28.WaterbusWebRTCManagerIpml(
            gh<_i15.WebRTCFrameCrypto>(),
            gh<_i9.SocketEmiter>(),
            gh<_i6.ReplayKitChannel>(),
            gh<_i3.NativeService>(),
            gh<_i8.WebRTCVideoStats>(),
            gh<_i7.WebRTCAudioStats>(),
          ));
  gh.factory<_i29.UpdateUsername>(
      () => _i29.UpdateUsername(gh<_i19.UserRepository>()));
  gh.factory<_i30.UpdateProfile>(
      () => _i30.UpdateProfile(gh<_i19.UserRepository>()));
  gh.factory<_i31.GetPresignedUrl>(
      () => _i31.GetPresignedUrl(gh<_i19.UserRepository>()));
  gh.factory<_i32.CheckUsername>(
      () => _i32.CheckUsername(gh<_i19.UserRepository>()));
  gh.factory<_i33.GetProfile>(() => _i33.GetProfile(gh<_i19.UserRepository>()));
  gh.factory<_i34.UploadAvatar>(
      () => _i34.UploadAvatar(gh<_i19.UserRepository>()));
  gh.singleton<_i35.CallKitListener>(() => _i35.CallKitListener(
        gh<_i4.WaterbusLogger>(),
        gh<_i27.WaterbusWebRTCManager>(),
      ));
  gh.singleton<_i36.AuthUsecases>(() => _i36.AuthUsecases(
        gh<_i37.LogOut>(),
        gh<_i37.LoginWithSocial>(),
        gh<_i37.RefreshToken>(),
      ));
  gh.singleton<_i38.SdkCore>(() => _i38.SdkCore(
        gh<_i27.WaterbusWebRTCManager>(),
        gh<_i6.ReplayKitChannel>(),
        gh<_i4.WaterbusLogger>(),
      ));
  gh.singleton<_i39.UseUsecases>(() => _i39.UseUsecases(
        gh<_i40.GetProfile>(),
        gh<_i40.UpdateProfile>(),
        gh<_i40.UpdateUsername>(),
        gh<_i40.CheckUsername>(),
        gh<_i40.GetPresignedUrl>(),
        gh<_i40.UploadAvatar>(),
      ));
  gh.singleton<_i41.SocketHandler>(() => _i42.SocketHandlerImpl(
        gh<_i27.WaterbusWebRTCManager>(),
        gh<_i4.WaterbusLogger>(),
      ));
  gh.singleton<_i43.MeetingUsecases>(() => _i43.MeetingUsecases(
        gh<_i44.CreateMeeting>(),
        gh<_i44.JoinMeeting>(),
        gh<_i44.GetInfoMeeting>(),
        gh<_i44.UpdateMeeting>(),
      ));
  return getIt;
}
