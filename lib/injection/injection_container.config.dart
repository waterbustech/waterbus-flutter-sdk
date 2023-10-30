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
import '../interfaces/socket_emiter_interface.dart' as _i3;
import '../interfaces/socket_handler_interface.dart' as _i7;
import '../interfaces/webrtc_interface.dart' as _i5;
import '../services/socket/socket_emiter.dart' as _i4;
import '../services/socket/socket_handler.dart' as _i8;
import '../services/webrtc/webrtc.dart' as _i6;

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
  gh.factory<_i3.SocketEmiter>(() => _i4.SocketEmiterImpl());
  gh.lazySingleton<_i5.WaterbusWebRTCManager>(
      () => _i6.WaterbusWebRTCManagerIpml(gh<_i3.SocketEmiter>()));
  gh.singleton<_i7.SocketHandler>(
      _i8.SocketHandlerImpl(gh<_i5.WaterbusWebRTCManager>()));
  return getIt;
}
