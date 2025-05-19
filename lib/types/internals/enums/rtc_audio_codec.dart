import 'package:freezed_annotation/freezed_annotation.dart';

@JsonEnum()
enum RTCAudioCodec {
  @JsonValue('opus')
  opus('opus');

  const RTCAudioCodec(this.codec);
  final String codec;
}
