import 'package:freezed_annotation/freezed_annotation.dart';

@JsonEnum()
enum DescriptionType {
  @JsonValue('offer')
  offer('offer'),
  @JsonValue('answer')
  answer('answer');

  const DescriptionType(this.type);
  final String type;
}
