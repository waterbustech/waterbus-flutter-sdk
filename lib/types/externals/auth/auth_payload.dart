import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_payload.freezed.dart';
part 'auth_payload.g.dart';

@freezed
abstract class AuthPayload with _$AuthPayload {
  const factory AuthPayload({
    required String fullName,
    required String externalId,
  }) = _AuthPayload;

  factory AuthPayload.fromJson(Map<String, Object?> json) =>
      _$AuthPayloadFromJson(json);
}
