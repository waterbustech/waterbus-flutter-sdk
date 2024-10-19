import 'package:flutter/material.dart';

import 'package:waterbus_sdk/types/enums/draw_shapes.dart';
import 'package:waterbus_sdk/types/models/draw_model.dart';

class CurrentStroke {
  DrawModel? value;

  bool get hasStroke => value != null;

  void startStroke(
    Offset point, {
    Color color = Colors.blueAccent,
    double size = 10,
    DrawShapes type = DrawShapes.normal,
    int sides = 5,
    bool filled = true,
  }) {
    value = () {
      if (type == DrawShapes.eraser) {
        return EraserStroke(
          points: [point],
          color: color,
          size: size,
        );
      }

      if (type == DrawShapes.line) {
        return LineStroke(
          points: [point],
          color: color,
          size: size,
        );
      }

      if (type == DrawShapes.polygon) {
        return PolygonStroke(
          points: [point],
          color: color,
          sides: sides,
          filled: filled,
        );
      }

      if (type == DrawShapes.circle) {
        return CircleStroke(
          points: [point],
          color: color,
          size: size,
          filled: filled,
        );
      }

      if (type == DrawShapes.square) {
        return SquareStroke(
          points: [point],
          color: color,
          size: size,
          filled: filled,
        );
      }

      return NormalStroke(
        points: [point],
        color: color,
        size: size,
      );
    }();
  }

  void addPoint(Offset point) {
    final points = List<Offset>.from(value?.points ?? [])..add(point);
    value = value?.copyWith(points: points);
  }

  void clear() {
    value = null;
  }
}
