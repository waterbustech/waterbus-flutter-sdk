import 'package:flutter/material.dart';
import 'package:waterbus_sdk/types/enums/draw_types.dart';

abstract class DrawModel {
  final List<Offset> points;
  final Color color;
  final double size;
  final bool? isFilled;
  final int? polygonSides;
  final DrawTypes strokeType;
  final DateTime createdAt;

  DrawModel({
    required this.points,
    Color? color,
    double? size,
    bool? isFilled,
    int? polygonSides,
    DrawTypes? strokeType,
    DateTime? createdAt,
  })  : color = color ?? Colors.black,
        size = size ?? 1,
        isFilled = isFilled ?? false,
        polygonSides = polygonSides ?? 0,
        strokeType = strokeType ?? DrawTypes.normal,
        createdAt = createdAt ?? DateTime.now().toUtc();

  DrawModel copyWith({
    List<Offset>? points,
    Color? color,
    DateTime? createdAt,
  });

  factory DrawModel.fromMap(Map<String, dynamic> map) {
    final strokeType = DrawTypes.fromString(map['type']);
    switch (strokeType) {
      case DrawTypes.normal:
        return NormalStroke.fromMap(map);
      case DrawTypes.eraser:
        return EraserStroke.fromMap(map);
      case DrawTypes.line:
        return LineStroke.fromMap(map);
      case DrawTypes.polygon:
        return PolygonStroke.fromMap(map);
      case DrawTypes.square:
        return SquareStroke.fromMap(map);
      case DrawTypes.circle:
        return CircleStroke.fromMap(map);
      default:
        throw UnimplementedError('Unknown stroke type: $strokeType');
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'offsets': points.map((e) => {'dx': e.dx, 'dy': e.dy}).toList(),
      'color': colorToHexString(color),
      'width': size,
      'isFilled': isFilled,
      'poligonSides': polygonSides,
      'type': strokeType.toString(),
      'createdAt': createdAt.toUtc().toString(),
    };
  }
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
  }) : super(strokeType: DrawTypes.normal);

  @override
  NormalStroke copyWith({
    List<Offset>? points,
    Color? color,
    double? size,
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
      size: (map['width'] as num).toDouble(),
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}

class EraserStroke extends DrawModel {
  EraserStroke({
    required super.points,
    super.color,
    super.size,
    super.createdAt,
  }) : super(strokeType: DrawTypes.eraser);

  @override
  EraserStroke copyWith({
    List<Offset>? points,
    Color? color,
    double? size,
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
      points:
          (map['points'] as List).map((e) => Offset(e['dx'], e['dy'])).toList(),
      color: colorFromHexString(map['color']),
      size: (map['size'] as num).toDouble(),
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}

class LineStroke extends DrawModel {
  LineStroke({
    required super.points,
    super.color,
    super.size,
    super.createdAt,
  }) : super(strokeType: DrawTypes.line);

  @override
  LineStroke copyWith({
    List<Offset>? points,
    Color? color,
    double? size,
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
      points:
          (map['points'] as List).map((e) => Offset(e['dx'], e['dy'])).toList(),
      color: colorFromHexString(map['color']),
      size: (map['size'] as num).toDouble(),
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}

class PolygonStroke extends DrawModel {
  final int sides;
  final bool filled;

  PolygonStroke({
    required super.points,
    required this.sides,
    this.filled = false,
    super.color,
    super.size,
    super.createdAt,
  }) : super(strokeType: DrawTypes.polygon);

  @override
  PolygonStroke copyWith({
    List<Offset>? points,
    int? sides,
    Color? color,
    double? size,
    bool? filled,
    DateTime? createdAt,
  }) {
    return PolygonStroke(
      points: points ?? this.points,
      sides: sides ?? this.sides,
      color: color ?? this.color,
      size: size ?? this.size,
      filled: filled ?? this.filled,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory PolygonStroke.fromMap(Map<String, dynamic> map) {
    return PolygonStroke(
      points:
          (map['points'] as List).map((e) => Offset(e['dx'], e['dy'])).toList(),
      sides: map['sides'] as int,
      filled: map['filled'] as bool? ?? false,
      color: colorFromHexString(map['color']),
      size: (map['size'] as num).toDouble(),
      createdAt: DateTime.parse(map['createdAt']),
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
  }) : super(strokeType: DrawTypes.circle);

  @override
  CircleStroke copyWith({
    List<Offset>? points,
    Color? color,
    double? size,
    bool? filled,
    DateTime? createdAt,
  }) {
    return CircleStroke(
      points: points ?? this.points,
      color: color ?? this.color,
      size: size ?? this.size,
      filled: filled ?? this.filled,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory CircleStroke.fromMap(Map<String, dynamic> map) {
    return CircleStroke(
      points:
          (map['points'] as List).map((e) => Offset(e['dx'], e['dy'])).toList(),
      filled: map['filled'] as bool? ?? false,
      color: colorFromHexString(map['color']),
      size: (map['size'] as num).toDouble(),
      createdAt: DateTime.parse(map['createdAt']),
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
  }) : super(strokeType: DrawTypes.square);

  @override
  SquareStroke copyWith({
    List<Offset>? points,
    Color? color,
    double? size,
    bool? filled,
    DateTime? createdAt,
  }) {
    return SquareStroke(
      points: points ?? this.points,
      color: color ?? this.color,
      size: size ?? this.size,
      filled: filled ?? this.filled,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory SquareStroke.fromMap(Map<String, dynamic> map) {
    return SquareStroke(
      points:
          (map['points'] as List).map((e) => Offset(e['dx'], e['dy'])).toList(),
      filled: map['filled'] as bool? ?? false,
      color: colorFromHexString(map['color']),
      size: (map['size'] as num).toDouble(),
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}
