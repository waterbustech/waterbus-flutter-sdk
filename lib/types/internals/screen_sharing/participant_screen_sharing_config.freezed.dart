// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'participant_screen_sharing_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ParticipantScreenSharingConfig {
  String get participantId;
  bool get isSharing;
  String? get screenTrackId;

  /// Create a copy of ParticipantScreenSharingConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ParticipantScreenSharingConfigCopyWith<ParticipantScreenSharingConfig>
      get copyWith => _$ParticipantScreenSharingConfigCopyWithImpl<
              ParticipantScreenSharingConfig>(
          this as ParticipantScreenSharingConfig, _$identity);

  /// Serializes this ParticipantScreenSharingConfig to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ParticipantScreenSharingConfig &&
            (identical(other.participantId, participantId) ||
                other.participantId == participantId) &&
            (identical(other.isSharing, isSharing) ||
                other.isSharing == isSharing) &&
            (identical(other.screenTrackId, screenTrackId) ||
                other.screenTrackId == screenTrackId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, participantId, isSharing, screenTrackId);

  @override
  String toString() {
    return 'ParticipantScreenSharingConfig(participantId: $participantId, isSharing: $isSharing, screenTrackId: $screenTrackId)';
  }
}

/// @nodoc
abstract mixin class $ParticipantScreenSharingConfigCopyWith<$Res> {
  factory $ParticipantScreenSharingConfigCopyWith(
          ParticipantScreenSharingConfig value,
          $Res Function(ParticipantScreenSharingConfig) _then) =
      _$ParticipantScreenSharingConfigCopyWithImpl;
  @useResult
  $Res call({String participantId, bool isSharing, String? screenTrackId});
}

/// @nodoc
class _$ParticipantScreenSharingConfigCopyWithImpl<$Res>
    implements $ParticipantScreenSharingConfigCopyWith<$Res> {
  _$ParticipantScreenSharingConfigCopyWithImpl(this._self, this._then);

  final ParticipantScreenSharingConfig _self;
  final $Res Function(ParticipantScreenSharingConfig) _then;

  /// Create a copy of ParticipantScreenSharingConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? participantId = null,
    Object? isSharing = null,
    Object? screenTrackId = freezed,
  }) {
    return _then(_self.copyWith(
      participantId: null == participantId
          ? _self.participantId
          : participantId // ignore: cast_nullable_to_non_nullable
              as String,
      isSharing: null == isSharing
          ? _self.isSharing
          : isSharing // ignore: cast_nullable_to_non_nullable
              as bool,
      screenTrackId: freezed == screenTrackId
          ? _self.screenTrackId
          : screenTrackId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _ParticipantScreenSharingConfig
    implements ParticipantScreenSharingConfig {
  const _ParticipantScreenSharingConfig(
      {required this.participantId,
      required this.isSharing,
      this.screenTrackId});
  factory _ParticipantScreenSharingConfig.fromJson(Map<String, dynamic> json) =>
      _$ParticipantScreenSharingConfigFromJson(json);

  @override
  final String participantId;
  @override
  final bool isSharing;
  @override
  final String? screenTrackId;

  /// Create a copy of ParticipantScreenSharingConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ParticipantScreenSharingConfigCopyWith<_ParticipantScreenSharingConfig>
      get copyWith => __$ParticipantScreenSharingConfigCopyWithImpl<
          _ParticipantScreenSharingConfig>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ParticipantScreenSharingConfigToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ParticipantScreenSharingConfig &&
            (identical(other.participantId, participantId) ||
                other.participantId == participantId) &&
            (identical(other.isSharing, isSharing) ||
                other.isSharing == isSharing) &&
            (identical(other.screenTrackId, screenTrackId) ||
                other.screenTrackId == screenTrackId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, participantId, isSharing, screenTrackId);

  @override
  String toString() {
    return 'ParticipantScreenSharingConfig(participantId: $participantId, isSharing: $isSharing, screenTrackId: $screenTrackId)';
  }
}

/// @nodoc
abstract mixin class _$ParticipantScreenSharingConfigCopyWith<$Res>
    implements $ParticipantScreenSharingConfigCopyWith<$Res> {
  factory _$ParticipantScreenSharingConfigCopyWith(
          _ParticipantScreenSharingConfig value,
          $Res Function(_ParticipantScreenSharingConfig) _then) =
      __$ParticipantScreenSharingConfigCopyWithImpl;
  @override
  @useResult
  $Res call({String participantId, bool isSharing, String? screenTrackId});
}

/// @nodoc
class __$ParticipantScreenSharingConfigCopyWithImpl<$Res>
    implements _$ParticipantScreenSharingConfigCopyWith<$Res> {
  __$ParticipantScreenSharingConfigCopyWithImpl(this._self, this._then);

  final _ParticipantScreenSharingConfig _self;
  final $Res Function(_ParticipantScreenSharingConfig) _then;

  /// Create a copy of ParticipantScreenSharingConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? participantId = null,
    Object? isSharing = null,
    Object? screenTrackId = freezed,
  }) {
    return _then(_ParticipantScreenSharingConfig(
      participantId: null == participantId
          ? _self.participantId
          : participantId // ignore: cast_nullable_to_non_nullable
              as String,
      isSharing: null == isSharing
          ? _self.isSharing
          : isSharing // ignore: cast_nullable_to_non_nullable
              as bool,
      screenTrackId: freezed == screenTrackId
          ? _self.screenTrackId
          : screenTrackId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
