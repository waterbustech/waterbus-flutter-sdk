enum MemberStatusEnum {
  inviting(0),
  invisible(1),
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
        throw Exception('Unknown MeetingRole value: $value');
    }
  }
}
