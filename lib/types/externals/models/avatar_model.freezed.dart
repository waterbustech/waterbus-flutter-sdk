// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'avatar_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AvatarModel {
  String? get id;
  String get name;
  String get src;
  String get location;
  int? get version;

  /// Create a copy of AvatarModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AvatarModelCopyWith<AvatarModel> get copyWith =>
      _$AvatarModelCopyWithImpl<AvatarModel>(this as AvatarModel, _$identity);

  /// Serializes this AvatarModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AvatarModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.src, src) || other.src == src) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.version, version) || other.version == version));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, name, src, location, version);

  @override
  String toString() {
    return 'AvatarModel(id: $id, name: $name, src: $src, location: $location, version: $version)';
  }
}

/// @nodoc
abstract mixin class $AvatarModelCopyWith<$Res> {
  factory $AvatarModelCopyWith(
          AvatarModel value, $Res Function(AvatarModel) _then) =
      _$AvatarModelCopyWithImpl;
  @useResult
  $Res call(
      {String? id, String name, String src, String location, int? version});
}

/// @nodoc
class _$AvatarModelCopyWithImpl<$Res> implements $AvatarModelCopyWith<$Res> {
  _$AvatarModelCopyWithImpl(this._self, this._then);

  final AvatarModel _self;
  final $Res Function(AvatarModel) _then;

  /// Create a copy of AvatarModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = null,
    Object? src = null,
    Object? location = null,
    Object? version = freezed,
  }) {
    return _then(_self.copyWith(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      src: null == src
          ? _self.src
          : src // ignore: cast_nullable_to_non_nullable
              as String,
      location: null == location
          ? _self.location
          : location // ignore: cast_nullable_to_non_nullable
              as String,
      version: freezed == version
          ? _self.version
          : version // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _AvatarModel implements AvatarModel {
  const _AvatarModel(
      {this.id,
      required this.name,
      required this.src,
      required this.location,
      this.version});
  factory _AvatarModel.fromJson(Map<String, dynamic> json) =>
      _$AvatarModelFromJson(json);

  @override
  final String? id;
  @override
  final String name;
  @override
  final String src;
  @override
  final String location;
  @override
  final int? version;

  /// Create a copy of AvatarModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$AvatarModelCopyWith<_AvatarModel> get copyWith =>
      __$AvatarModelCopyWithImpl<_AvatarModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$AvatarModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _AvatarModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.src, src) || other.src == src) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.version, version) || other.version == version));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, name, src, location, version);

  @override
  String toString() {
    return 'AvatarModel(id: $id, name: $name, src: $src, location: $location, version: $version)';
  }
}

/// @nodoc
abstract mixin class _$AvatarModelCopyWith<$Res>
    implements $AvatarModelCopyWith<$Res> {
  factory _$AvatarModelCopyWith(
          _AvatarModel value, $Res Function(_AvatarModel) _then) =
      __$AvatarModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String? id, String name, String src, String location, int? version});
}

/// @nodoc
class __$AvatarModelCopyWithImpl<$Res> implements _$AvatarModelCopyWith<$Res> {
  __$AvatarModelCopyWithImpl(this._self, this._then);

  final _AvatarModel _self;
  final $Res Function(_AvatarModel) _then;

  /// Create a copy of AvatarModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = freezed,
    Object? name = null,
    Object? src = null,
    Object? location = null,
    Object? version = freezed,
  }) {
    return _then(_AvatarModel(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      src: null == src
          ? _self.src
          : src // ignore: cast_nullable_to_non_nullable
              as String,
      location: null == location
          ? _self.location
          : location // ignore: cast_nullable_to_non_nullable
              as String,
      version: freezed == version
          ? _self.version
          : version // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

// dart format on
