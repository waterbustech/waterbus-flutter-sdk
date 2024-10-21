enum DrawShapes {
  normal('normal'),
  eraser('eraser'),
  line('line'),
  polygon('polygon'),
  square('square'),
  circle('circle');

  const DrawShapes(this.str);

  final String str;

  bool get isEraser => this == DrawShapes.eraser;
  bool get isLine => this == DrawShapes.line;
  bool get isPencil => this == DrawShapes.normal;
  bool get isPolygon => this == DrawShapes.polygon;
  bool get isSquare => this == DrawShapes.square;
  bool get isCircle => this == DrawShapes.circle;
}

extension DrawShapesX on String {
  DrawShapes get getDrawShapesEnum {
    final int index = DrawShapes.values.indexWhere((type) => type.str == this);

    if (index == -1) return DrawShapes.normal;

    return DrawShapes.values[index];
  }
}
