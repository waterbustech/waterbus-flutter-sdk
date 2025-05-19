import 'package:freezed_annotation/freezed_annotation.dart';

class IntConverter implements JsonConverter<int?, Object?> {
  const IntConverter();

  @override
  int? fromJson(Object? json) {
    if (json is int) return json;

    if (json is Map<String, dynamic>) return json['id'];

    return null;
  }

  @override
  Object? toJson(int? object) => object;
}
