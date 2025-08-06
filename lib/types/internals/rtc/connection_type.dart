import 'package:freezed_annotation/freezed_annotation.dart';

@JsonEnum()
enum ConnectionType {
  @JsonValue(0)
  p2p,
  @JsonValue(1)
  sfu,
}

extension ConnectionTypeX on int? {
  ConnectionType toConnectionType() {
    return switch (this) {
      0 => ConnectionType.p2p,
      _ => ConnectionType.sfu,
    };
  }
}
