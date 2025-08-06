// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'subscribe_payload.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SubscribePayload {
  String get roomId;
  String get participantId;
  String get targetId;
  bool get isIpv6Supported;

  /// Create a copy of SubscribePayload
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SubscribePayloadCopyWith<SubscribePayload> get copyWith =>
      _$SubscribePayloadCopyWithImpl<SubscribePayload>(
          this as SubscribePayload, _$identity);

  /// Serializes this SubscribePayload to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SubscribePayload &&
            (identical(other.roomId, roomId) || other.roomId == roomId) &&
            (identical(other.participantId, participantId) ||
                other.participantId == participantId) &&
            (identical(other.targetId, targetId) ||
                other.targetId == targetId) &&
            (identical(other.isIpv6Supported, isIpv6Supported) ||
                other.isIpv6Supported == isIpv6Supported));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, roomId, participantId, targetId, isIpv6Supported);

  @override
  String toString() {
    return 'SubscribePayload(roomId: $roomId, participantId: $participantId, targetId: $targetId, isIpv6Supported: $isIpv6Supported)';
  }
}

/// @nodoc
abstract mixin class $SubscribePayloadCopyWith<$Res> {
  factory $SubscribePayloadCopyWith(
          SubscribePayload value, $Res Function(SubscribePayload) _then) =
      _$SubscribePayloadCopyWithImpl;
  @useResult
  $Res call(
      {String roomId,
      String participantId,
      String targetId,
      bool isIpv6Supported});
}

/// @nodoc
class _$SubscribePayloadCopyWithImpl<$Res>
    implements $SubscribePayloadCopyWith<$Res> {
  _$SubscribePayloadCopyWithImpl(this._self, this._then);

  final SubscribePayload _self;
  final $Res Function(SubscribePayload) _then;

  /// Create a copy of SubscribePayload
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? roomId = null,
    Object? participantId = null,
    Object? targetId = null,
    Object? isIpv6Supported = null,
  }) {
    return _then(_self.copyWith(
      roomId: null == roomId
          ? _self.roomId
          : roomId // ignore: cast_nullable_to_non_nullable
              as String,
      participantId: null == participantId
          ? _self.participantId
          : participantId // ignore: cast_nullable_to_non_nullable
              as String,
      targetId: null == targetId
          ? _self.targetId
          : targetId // ignore: cast_nullable_to_non_nullable
              as String,
      isIpv6Supported: null == isIpv6Supported
          ? _self.isIpv6Supported
          : isIpv6Supported // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _SubscribePayload implements SubscribePayload {
  const _SubscribePayload(
      {required this.roomId,
      required this.participantId,
      required this.targetId,
      this.isIpv6Supported = false});
  factory _SubscribePayload.fromJson(Map<String, dynamic> json) =>
      _$SubscribePayloadFromJson(json);

  @override
  final String roomId;
  @override
  final String participantId;
  @override
  final String targetId;
  @override
  @JsonKey()
  final bool isIpv6Supported;

  /// Create a copy of SubscribePayload
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$SubscribePayloadCopyWith<_SubscribePayload> get copyWith =>
      __$SubscribePayloadCopyWithImpl<_SubscribePayload>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$SubscribePayloadToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SubscribePayload &&
            (identical(other.roomId, roomId) || other.roomId == roomId) &&
            (identical(other.participantId, participantId) ||
                other.participantId == participantId) &&
            (identical(other.targetId, targetId) ||
                other.targetId == targetId) &&
            (identical(other.isIpv6Supported, isIpv6Supported) ||
                other.isIpv6Supported == isIpv6Supported));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, roomId, participantId, targetId, isIpv6Supported);

  @override
  String toString() {
    return 'SubscribePayload(roomId: $roomId, participantId: $participantId, targetId: $targetId, isIpv6Supported: $isIpv6Supported)';
  }
}

/// @nodoc
abstract mixin class _$SubscribePayloadCopyWith<$Res>
    implements $SubscribePayloadCopyWith<$Res> {
  factory _$SubscribePayloadCopyWith(
          _SubscribePayload value, $Res Function(_SubscribePayload) _then) =
      __$SubscribePayloadCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String roomId,
      String participantId,
      String targetId,
      bool isIpv6Supported});
}

/// @nodoc
class __$SubscribePayloadCopyWithImpl<$Res>
    implements _$SubscribePayloadCopyWith<$Res> {
  __$SubscribePayloadCopyWithImpl(this._self, this._then);

  final _SubscribePayload _self;
  final $Res Function(_SubscribePayload) _then;

  /// Create a copy of SubscribePayload
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? roomId = null,
    Object? participantId = null,
    Object? targetId = null,
    Object? isIpv6Supported = null,
  }) {
    return _then(_SubscribePayload(
      roomId: null == roomId
          ? _self.roomId
          : roomId // ignore: cast_nullable_to_non_nullable
              as String,
      participantId: null == participantId
          ? _self.participantId
          : participantId // ignore: cast_nullable_to_non_nullable
              as String,
      targetId: null == targetId
          ? _self.targetId
          : targetId // ignore: cast_nullable_to_non_nullable
              as String,
      isIpv6Supported: null == isIpv6Supported
          ? _self.isIpv6Supported
          : isIpv6Supported // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

// dart format on
