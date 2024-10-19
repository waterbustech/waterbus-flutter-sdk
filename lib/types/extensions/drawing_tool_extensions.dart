import 'package:flutter/material.dart';

import 'package:waterbus_sdk/types/enums/draw_shapes.dart';

extension DrawShapesExtensions on DrawShapes {
  DrawShapes get strokeType {
    switch (this) {
      case DrawShapes.normal:
        return DrawShapes.normal;
      case DrawShapes.eraser:
        return DrawShapes.eraser;
      case DrawShapes.line:
        return DrawShapes.line;
      case DrawShapes.polygon:
        return DrawShapes.polygon;
      case DrawShapes.square:
        return DrawShapes.square;
      case DrawShapes.circle:
        return DrawShapes.circle;
    }
  }

  MouseCursor get cursor {
    switch (this) {
      case DrawShapes.normal:
      case DrawShapes.line:
      case DrawShapes.polygon:
      case DrawShapes.square:
      case DrawShapes.circle:
      case DrawShapes.eraser:
        return SystemMouseCursors.precise;
    }
  }
}
