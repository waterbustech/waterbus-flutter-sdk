import 'package:waterbus_sdk/types/enums/draw_socket_enum.dart';
import 'package:waterbus_sdk/types/models/draw_model.dart';

class DrawSocketEvent {
  final DrawActionEnum action;
  final List<DrawModel> draw;
  DrawSocketEvent({
    required this.action,
    required this.draw,
  });
}
