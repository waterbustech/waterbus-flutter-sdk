import 'package:socket_io_client/socket_io_client.dart';

abstract class WsHandler {
  void establishConnection({
    bool forceConnection = false,
    Function()? callbackConnected,
  });
  void disconnection();
  void reconnect({required Function callbackConnected});

  Socket? get socket;

  bool get isConnected;
}
