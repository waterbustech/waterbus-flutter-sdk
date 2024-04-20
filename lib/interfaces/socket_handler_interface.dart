// Package imports:
import 'package:socket_io_client/socket_io_client.dart';

abstract class SocketHandler {
  void establishConnection({
    required String accessToken,
    bool forceConnection = false,
  });
  void disconnection();

  Socket? get socket;
}
