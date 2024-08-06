import 'package:socket_io_client/socket_io_client.dart';

abstract class SocketHandler {
  void establishConnection({bool forceConnection = false});
  void disconnection();
  void reconnect({required Function callbackConnected});

  Socket? get socket;

  bool get isConnected;
}
