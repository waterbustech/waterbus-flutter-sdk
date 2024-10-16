import 'package:waterbus_sdk/types/models/draw_model.dart';

enum DrawSocketEnum { start, update, delete }

enum UpdateDrawEnum { add, remove;

  static UpdateDrawEnum fromString(String value) {
    switch (value) {
      case 'add':
        return UpdateDrawEnum.add;
      case 'remove':
        return UpdateDrawEnum.remove;
      default:
        throw ArgumentError('Invalid action type: $value');
    }
  }
}

class DrawSocketEvent {
  final DrawSocketEnum event;
  final UpdateDrawEnum? action;
  final List<DrawModel> draw;
  DrawSocketEvent({
    required this.event,
    this.action,
    required this.draw,
  });
}
