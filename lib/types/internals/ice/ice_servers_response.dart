import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:waterbus_sdk/types/internals/ice/ice_server.dart';

part 'ice_servers_response.freezed.dart';
part 'ice_servers_response.g.dart';

@freezed
abstract class IceServersResponse with _$IceServersResponse {
  const factory IceServersResponse({
    required List<IceServer> iceServers,
  }) = _IceServersResponse;

  factory IceServersResponse.fromJson(Map<String, dynamic> json) =>
      _$IceServersResponseFromJson(json);
}

extension IceServersResponseToMap on IceServersResponse {
  List<Map<String, dynamic>> toMap() {
    return iceServers.map((server) {
      final map = <String, dynamic>{
        'urls': server.urls,
      };

      if (server.username != null) {
        map['username'] = server.username;
      }
      if (server.credential != null) {
        map['credential'] = server.credential;
      }

      return map;
    }).toList();
  }
}
