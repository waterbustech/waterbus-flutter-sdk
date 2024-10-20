import 'package:flutter/material.dart';

import 'package:equatable/equatable.dart';

import 'package:waterbus_sdk/types/enums/draw_shapes.dart';

class DrawModel extends Equatable {
  final List<Offset> points;
  final Color color;
  final double size;
  final bool isFilled;
  final bool showGrid;
  final int polygonSides;
  final DrawShapes drawShapes;
  final DateTime createdAt;

  DrawModel({
    required this.points,
    Color? color,
    double? size,
    bool? isFilled,
    bool? showGrid,
    int? polygonSides,
    DrawShapes? drawShapes,
    DateTime? createdAt,
  })  : color = color ?? Colors.black,
        size = size ?? 1,
        isFilled = isFilled ?? false,
        showGrid = showGrid ?? false,
        polygonSides = polygonSides ?? 3,
        drawShapes = drawShapes ?? DrawShapes.normal,
        createdAt = createdAt ?? DateTime.now().toUtc();

  DrawModel copyWith({
    List<Offset>? points,
    Color? color,
    double? size,
    bool? isFilled,
    bool? showGrid,
    int? polygonSides,
    DrawShapes? drawShapes,
    DateTime? createdAt,
  }) {
    return DrawModel(
      points: points ?? this.points,
      color: color ?? this.color,
      size: size ?? this.size,
      isFilled: isFilled ?? this.isFilled,
      showGrid: showGrid ?? this.showGrid,
      polygonSides: polygonSides ?? this.polygonSides,
      drawShapes: drawShapes ?? this.drawShapes,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory DrawModel.fromMap(Map<String, dynamic> map) {
    final String typeMap = map['type'];
    final drawShapes = typeMap.getDrawShapesEnum;

    switch (drawShapes) {
      case DrawShapes.normal:
        return NormalStroke.fromMap(map);
      case DrawShapes.eraser:
        return EraserStroke.fromMap(map);
      case DrawShapes.line:
        return LineStroke.fromMap(map);
      case DrawShapes.polygon:
        return PolygonStroke.fromMap(map);
      case DrawShapes.square:
        return SquareStroke.fromMap(map);
      case DrawShapes.circle:
        return CircleStroke.fromMap(map);
      default:
        throw UnimplementedError('Unknown stroke type: $drawShapes');
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'offsets': points.map((e) => {'dx': e.dx, 'dy': e.dy}).toList(),
      'color': colorToHexString(color),
      'width': size,
      'isFilled': isFilled,
      'poligonSides': polygonSides,
      'type': drawShapes.str,
      'createdAt': createdAt.toUtc().toString(),
    };
  }

  @override
  List<Object?> get props => [
        points,
        color,
        size,
        isFilled,
        showGrid,
        drawShapes,
        createdAt,
        polygonSides,
      ];
}

String colorToHexString(Color color, {bool includeAlpha = true}) {
  final String hex = color.value.toRadixString(16).padLeft(8, '0');
  return includeAlpha ? hex : hex.substring(2);
}

Color colorFromHexString(String hex) {
  final buffer = StringBuffer();
  if (hex.length == 6 || hex.length == 7) {
    buffer.write('ff');
  }
  buffer.write(hex.replaceFirst('#', ''));
  return Color(int.parse(buffer.toString(), radix: 16));
}

class NormalStroke extends DrawModel {
  NormalStroke({
    required super.points,
    super.color,
    super.size,
    super.createdAt,
  }) : super(drawShapes: DrawShapes.normal);

  @override
  NormalStroke copyWith({
    List<Offset>? points,
    Color? color,
    double? size,
    bool? isFilled,
    bool? showGrid,
    int? polygonSides,
    DrawShapes? drawShapes,
    DateTime? createdAt,
  }) {
    return NormalStroke(
      points: points ?? this.points,
      color: color ?? this.color,
      size: size ?? this.size,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory NormalStroke.fromMap(Map<String, dynamic> map) {
    return NormalStroke(
      points: (map['offsets'] as List)
          .map((e) => Offset(e['dx'], e['dy']))
          .toList(),
      color: colorFromHexString(map['color']),
      size: (map['width'] as num? ?? 0).toDouble(),
      createdAt: DateTime.parse(map['createdAt']).toLocal(),
    );
  }
}

class EraserStroke extends DrawModel {
  EraserStroke({
    required super.points,
    super.color,
    super.size,
    super.createdAt,
  }) : super(drawShapes: DrawShapes.eraser);

  @override
  EraserStroke copyWith({
    List<Offset>? points,
    Color? color,
    double? size,
    bool? isFilled,
    bool? showGrid,
    int? polygonSides,
    DrawShapes? drawShapes,
    DateTime? createdAt,
  }) {
    return EraserStroke(
      points: points ?? this.points,
      color: color ?? this.color,
      size: size ?? this.size,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory EraserStroke.fromMap(Map<String, dynamic> map) {
    return EraserStroke(
      points: (map['offsets'] as List)
          .map((e) => Offset(e['dx'], e['dy']))
          .toList(),
      color: colorFromHexString(map['color']),
      size: (map['width'] as num? ?? 0).toDouble(),
      createdAt: DateTime.parse(map['createdAt']).toLocal(),
    );
  }
}

class LineStroke extends DrawModel {
  LineStroke({
    required super.points,
    super.color,
    super.size,
    super.createdAt,
  }) : super(drawShapes: DrawShapes.line);

  @override
  LineStroke copyWith({
    List<Offset>? points,
    Color? color,
    double? size,
    bool? isFilled,
    bool? showGrid,
    int? polygonSides,
    DrawShapes? drawShapes,
    DateTime? createdAt,
  }) {
    return LineStroke(
      points: points ?? this.points,
      color: color ?? this.color,
      size: size ?? this.size,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory LineStroke.fromMap(Map<String, dynamic> map) {
    return LineStroke(
      points: (map['offsets'] as List)
          .map((e) => Offset(e['dx'], e['dy']))
          .toList(),
      color: colorFromHexString(map['color']),
      size: (map['width'] as num? ?? 0).toDouble(),
      createdAt: DateTime.parse(map['createdAt']).toLocal(),
    );
  }
}

class PolygonStroke extends DrawModel {
  final int sides;
  final bool filled;

  PolygonStroke({
    required super.points,
    required this.sides,
    this.filled = true,
    super.color,
    super.size,
    super.createdAt,
  }) : super(drawShapes: DrawShapes.polygon);

  @override
  PolygonStroke copyWith({
    List<Offset>? points,
    Color? color,
    double? size,
    bool? isFilled,
    bool? showGrid,
    int? polygonSides,
    DrawShapes? drawShapes,
    DateTime? createdAt,
  }) {
    return PolygonStroke(
      points: points ?? this.points,
      sides: sides,
      color: color ?? this.color,
      size: size ?? this.size,
      filled: filled,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory PolygonStroke.fromMap(Map<String, dynamic> map) {
    return PolygonStroke(
      points: (map['offsets'] as List)
          .map((e) => Offset(e['dx'], e['dy']))
          .toList(),
      sides: map['poligonSides'] ?? 0,
      filled: map['isFilled'] as bool? ?? false,
      color: colorFromHexString(map['color']),
      size: (map['width'] as num? ?? 0).toDouble(),
      createdAt: DateTime.parse(map['createdAt']).toLocal(),
    );
  }
}

class CircleStroke extends DrawModel {
  final bool filled;

  CircleStroke({
    required super.points,
    this.filled = false,
    super.color,
    super.size,
    super.createdAt,
  }) : super(drawShapes: DrawShapes.circle);

  @override
  CircleStroke copyWith({
    List<Offset>? points,
    Color? color,
    double? size,
    bool? isFilled,
    bool? showGrid,
    int? polygonSides,
    DrawShapes? drawShapes,
    DateTime? createdAt,
  }) {
    return CircleStroke(
      points: points ?? this.points,
      color: color ?? this.color,
      size: size ?? this.size,
      filled: filled,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory CircleStroke.fromMap(Map<String, dynamic> map) {
    return CircleStroke(
      points: (map['offsets'] as List)
          .map((e) => Offset(e['dx'], e['dy']))
          .toList(),
      filled: map['isFilled'] ?? false,
      color: colorFromHexString(map['color']),
      size: ((map['poligonSides'] ?? 0) as num).toDouble(),
      createdAt: DateTime.parse(map['createdAt']).toLocal(),
    );
  }
}

class SquareStroke extends DrawModel {
  final bool filled;

  SquareStroke({
    required super.points,
    this.filled = false,
    super.color,
    super.size,
    super.createdAt,
  }) : super(drawShapes: DrawShapes.square);

  @override
  SquareStroke copyWith({
    List<Offset>? points,
    Color? color,
    double? size,
    bool? isFilled,
    bool? showGrid,
    int? polygonSides,
    DrawShapes? drawShapes,
    DateTime? createdAt,
  }) {
    return SquareStroke(
      points: points ?? this.points,
      color: color ?? this.color,
      size: size ?? this.size,
      filled: filled,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory SquareStroke.fromMap(Map<String, dynamic> map) {
    return SquareStroke(
      points: (map['offsets'] as List)
          .map((e) => Offset(e['dx'], e['dy']))
          .toList(),
      filled: map['isFilled'] as bool? ?? false,
      color: colorFromHexString(map['color']),
      size: (map['width'] as num? ?? 0).toDouble(),
      createdAt: DateTime.parse(map['createdAt']).toLocal(),
    );
  }
}
