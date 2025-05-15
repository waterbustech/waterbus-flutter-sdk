// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_payload.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AuthPayload {
  String get fullName;
  String? get externalId;

  /// Create a copy of AuthPayload
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AuthPayloadCopyWith<AuthPayload> get copyWith =>
      _$AuthPayloadCopyWithImpl<AuthPayload>(this as AuthPayload, _$identity);

  /// Serializes this AuthPayload to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AuthPayload &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName) &&
            (identical(other.externalId, externalId) ||
                other.externalId == externalId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, fullName, externalId);

  @override
  String toString() {
    return 'AuthPayload(fullName: $fullName, externalId: $externalId)';
  }
}

/// @nodoc
abstract mixin class $AuthPayloadCopyWith<$Res> {
  factory $AuthPayloadCopyWith(
          AuthPayload value, $Res Function(AuthPayload) _then) =
      _$AuthPayloadCopyWithImpl;
  @useResult
  $Res call({String fullName, String? externalId});
}

/// @nodoc
class _$AuthPayloadCopyWithImpl<$Res> implements $AuthPayloadCopyWith<$Res> {
  _$AuthPayloadCopyWithImpl(this._self, this._then);

  final AuthPayload _self;
  final $Res Function(AuthPayload) _then;

  /// Create a copy of AuthPayload
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fullName = null,
    Object? externalId = freezed,
  }) {
    return _then(_self.copyWith(
      fullName: null == fullName
          ? _self.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String,
      externalId: freezed == externalId
          ? _self.externalId
          : externalId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _AuthPayload implements AuthPayload {
  const _AuthPayload({required this.fullName, this.externalId});
  factory _AuthPayload.fromJson(Map<String, dynamic> json) =>
      _$AuthPayloadFromJson(json);

  @override
  final String fullName;
  @override
  final String? externalId;

  /// Create a copy of AuthPayload
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$AuthPayloadCopyWith<_AuthPayload> get copyWith =>
      __$AuthPayloadCopyWithImpl<_AuthPayload>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$AuthPayloadToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _AuthPayload &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName) &&
            (identical(other.externalId, externalId) ||
                other.externalId == externalId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, fullName, externalId);

  @override
  String toString() {
    return 'AuthPayload(fullName: $fullName, externalId: $externalId)';
  }
}

/// @nodoc
abstract mixin class _$AuthPayloadCopyWith<$Res>
    implements $AuthPayloadCopyWith<$Res> {
  factory _$AuthPayloadCopyWith(
          _AuthPayload value, $Res Function(_AuthPayload) _then) =
      __$AuthPayloadCopyWithImpl;
  @override
  @useResult
  $Res call({String fullName, String? externalId});
}

/// @nodoc
class __$AuthPayloadCopyWithImpl<$Res> implements _$AuthPayloadCopyWith<$Res> {
  __$AuthPayloadCopyWithImpl(this._self, this._then);

  final _AuthPayload _self;
  final $Res Function(_AuthPayload) _then;

  /// Create a copy of AuthPayload
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? fullName = null,
    Object? externalId = freezed,
  }) {
    return _then(_AuthPayload(
      fullName: null == fullName
          ? _self.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String,
      externalId: freezed == externalId
          ? _self.externalId
          : externalId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
