import 'package:freezed_annotation/freezed_annotation.dart';

@JsonEnum()
enum MemberStatusEnum {
  @JsonValue(0)
  inviting(0),
  @JsonValue(1)
  invisible(1),
  @JsonValue(2)
  joined(2);

  const MemberStatusEnum(this.value);

  final int value;

  static MemberStatusEnum fromValue(int value) {
    switch (value) {
      case 0:
        return MemberStatusEnum.inviting;
      case 1:
        return MemberStatusEnum.invisible;
      case 2:
        return MemberStatusEnum.joined;
      default:
        throw Exception('Unknown Room Role value: $value');
    }
  }
}
