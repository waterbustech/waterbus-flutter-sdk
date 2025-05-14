import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_payload_model.freezed.dart';
part 'auth_payload_model.g.dart';

@freezed
abstract class AuthPayloadModel with _$AuthPayloadModel {
  const factory AuthPayloadModel({
    required String fullName,
    String? authId,
  }) = _AuthPayloadModel;

  factory AuthPayloadModel.fromJson(Map<String, Object?> json) =>
      _$AuthPayloadModelFromJson(json);
}
