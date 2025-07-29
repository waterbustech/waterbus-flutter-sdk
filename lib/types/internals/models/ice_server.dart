import 'package:freezed_annotation/freezed_annotation.dart';

part 'ice_server.freezed.dart';
part 'ice_server.g.dart';

@freezed
abstract class IceServer with _$IceServer {
  const factory IceServer({
    required List<String> urls,
    String? username,
    String? credential,
  }) = _IceServer;

  factory IceServer.fromJson(Map<String, dynamic> json) =>
      _$IceServerFromJson(json);
}
