import 'package:freezed_annotation/freezed_annotation.dart';

part 'avatar_model.freezed.dart';
part 'avatar_model.g.dart';

@freezed
abstract class AvatarModel with _$AvatarModel {
  const factory AvatarModel({
    String? id,
    required String name,
    required String src,
    required String location,
    required int version,
  }) = _AvatarModel;

  factory AvatarModel.fromJson(Map<String, Object?> json) =>
      _$AvatarModelFromJson(json);
}
