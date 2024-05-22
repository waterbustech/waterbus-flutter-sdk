import 'package:socket_io_client/socket_io_client.dart';

abstract class SocketHandler {
  void establishConnection({bool forceConnection = false});
  void disconnection();

  Socket? get socket;
}
