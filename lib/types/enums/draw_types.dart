
enum DrawTypes {
  normal,
  eraser,
  line,
  polygon,
  square,
  circle;

  static DrawTypes fromString(String value) {
    switch (value) {
      case 'normal':
        return DrawTypes.normal;
      case 'eraser':
        return DrawTypes.eraser;
      case 'line':
        return DrawTypes.line;
      case 'polygon':
        return DrawTypes.polygon;
      case 'square':
        return DrawTypes.square;
      case 'circle':
        return DrawTypes.circle;
      default:
        return DrawTypes.normal;
    }
  }

  @override
  String toString() {
    switch (this) {
      case DrawTypes.normal:
        return 'normal';
      case DrawTypes.eraser:
        return 'eraser';
      case DrawTypes.line:
        return 'line';
      case DrawTypes.polygon:
        return 'polygon';
      case DrawTypes.square:
        return 'square';
      case DrawTypes.circle:
        return 'circle';
    }
  }
}
