// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_payload_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AuthPayloadModel {
  String get fullName;
  String? get facebookId;
  String? get googleId;
  String? get appleId;
  String? get email;

  /// Create a copy of AuthPayloadModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AuthPayloadModelCopyWith<AuthPayloadModel> get copyWith =>
      _$AuthPayloadModelCopyWithImpl<AuthPayloadModel>(
          this as AuthPayloadModel, _$identity);

  /// Serializes this AuthPayloadModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AuthPayloadModel &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName) &&
            (identical(other.facebookId, facebookId) ||
                other.facebookId == facebookId) &&
            (identical(other.googleId, googleId) ||
                other.googleId == googleId) &&
            (identical(other.appleId, appleId) || other.appleId == appleId) &&
            (identical(other.email, email) || other.email == email));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, fullName, facebookId, googleId, appleId, email);

  @override
  String toString() {
    return 'AuthPayloadModel(fullName: $fullName, facebookId: $facebookId, googleId: $googleId, appleId: $appleId, email: $email)';
  }
}

/// @nodoc
abstract mixin class $AuthPayloadModelCopyWith<$Res> {
  factory $AuthPayloadModelCopyWith(
          AuthPayloadModel value, $Res Function(AuthPayloadModel) _then) =
      _$AuthPayloadModelCopyWithImpl;
  @useResult
  $Res call(
      {String fullName,
      String? facebookId,
      String? googleId,
      String? appleId,
      String? email});
}

/// @nodoc
class _$AuthPayloadModelCopyWithImpl<$Res>
    implements $AuthPayloadModelCopyWith<$Res> {
  _$AuthPayloadModelCopyWithImpl(this._self, this._then);

  final AuthPayloadModel _self;
  final $Res Function(AuthPayloadModel) _then;

  /// Create a copy of AuthPayloadModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fullName = null,
    Object? facebookId = freezed,
    Object? googleId = freezed,
    Object? appleId = freezed,
    Object? email = freezed,
  }) {
    return _then(_self.copyWith(
      fullName: null == fullName
          ? _self.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String,
      facebookId: freezed == facebookId
          ? _self.facebookId
          : facebookId // ignore: cast_nullable_to_non_nullable
              as String?,
      googleId: freezed == googleId
          ? _self.googleId
          : googleId // ignore: cast_nullable_to_non_nullable
              as String?,
      appleId: freezed == appleId
          ? _self.appleId
          : appleId // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _self.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _AuthPayloadModel implements AuthPayloadModel {
  const _AuthPayloadModel(
      {required this.fullName,
      this.facebookId,
      this.googleId,
      this.appleId,
      this.email});
  factory _AuthPayloadModel.fromJson(Map<String, dynamic> json) =>
      _$AuthPayloadModelFromJson(json);

  @override
  final String fullName;
  @override
  final String? facebookId;
  @override
  final String? googleId;
  @override
  final String? appleId;
  @override
  final String? email;

  /// Create a copy of AuthPayloadModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$AuthPayloadModelCopyWith<_AuthPayloadModel> get copyWith =>
      __$AuthPayloadModelCopyWithImpl<_AuthPayloadModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$AuthPayloadModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _AuthPayloadModel &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName) &&
            (identical(other.facebookId, facebookId) ||
                other.facebookId == facebookId) &&
            (identical(other.googleId, googleId) ||
                other.googleId == googleId) &&
            (identical(other.appleId, appleId) || other.appleId == appleId) &&
            (identical(other.email, email) || other.email == email));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, fullName, facebookId, googleId, appleId, email);

  @override
  String toString() {
    return 'AuthPayloadModel(fullName: $fullName, facebookId: $facebookId, googleId: $googleId, appleId: $appleId, email: $email)';
  }
}

/// @nodoc
abstract mixin class _$AuthPayloadModelCopyWith<$Res>
    implements $AuthPayloadModelCopyWith<$Res> {
  factory _$AuthPayloadModelCopyWith(
          _AuthPayloadModel value, $Res Function(_AuthPayloadModel) _then) =
      __$AuthPayloadModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String fullName,
      String? facebookId,
      String? googleId,
      String? appleId,
      String? email});
}

/// @nodoc
class __$AuthPayloadModelCopyWithImpl<$Res>
    implements _$AuthPayloadModelCopyWith<$Res> {
  __$AuthPayloadModelCopyWithImpl(this._self, this._then);

  final _AuthPayloadModel _self;
  final $Res Function(_AuthPayloadModel) _then;

  /// Create a copy of AuthPayloadModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? fullName = null,
    Object? facebookId = freezed,
    Object? googleId = freezed,
    Object? appleId = freezed,
    Object? email = freezed,
  }) {
    return _then(_AuthPayloadModel(
      fullName: null == fullName
          ? _self.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String,
      facebookId: freezed == facebookId
          ? _self.facebookId
          : facebookId // ignore: cast_nullable_to_non_nullable
              as String?,
      googleId: freezed == googleId
          ? _self.googleId
          : googleId // ignore: cast_nullable_to_non_nullable
              as String?,
      appleId: freezed == appleId
          ? _self.appleId
          : appleId // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _self.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
