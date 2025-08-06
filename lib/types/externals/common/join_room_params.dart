class JoinRoomParams {
  final int roomId;
  final String password;
  final int? userId;

  const JoinRoomParams({
    required this.roomId,
    required this.password,
    this.userId,
  });
}
