// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'participant_e2ee_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ParticipantE2eeConfig {
  RTCRtpReceiver get receiver;
  String get targetId;
  bool get isEnabled;

  /// Create a copy of ParticipantE2eeConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ParticipantE2eeConfigCopyWith<ParticipantE2eeConfig> get copyWith =>
      _$ParticipantE2eeConfigCopyWithImpl<ParticipantE2eeConfig>(
          this as ParticipantE2eeConfig, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ParticipantE2eeConfig &&
            (identical(other.receiver, receiver) ||
                other.receiver == receiver) &&
            (identical(other.targetId, targetId) ||
                other.targetId == targetId) &&
            (identical(other.isEnabled, isEnabled) ||
                other.isEnabled == isEnabled));
  }

  @override
  int get hashCode => Object.hash(runtimeType, receiver, targetId, isEnabled);

  @override
  String toString() {
    return 'ParticipantE2eeConfig(receiver: $receiver, targetId: $targetId, isEnabled: $isEnabled)';
  }
}

/// @nodoc
abstract mixin class $ParticipantE2eeConfigCopyWith<$Res> {
  factory $ParticipantE2eeConfigCopyWith(ParticipantE2eeConfig value,
          $Res Function(ParticipantE2eeConfig) _then) =
      _$ParticipantE2eeConfigCopyWithImpl;
  @useResult
  $Res call({RTCRtpReceiver receiver, String targetId, bool isEnabled});
}

/// @nodoc
class _$ParticipantE2eeConfigCopyWithImpl<$Res>
    implements $ParticipantE2eeConfigCopyWith<$Res> {
  _$ParticipantE2eeConfigCopyWithImpl(this._self, this._then);

  final ParticipantE2eeConfig _self;
  final $Res Function(ParticipantE2eeConfig) _then;

  /// Create a copy of ParticipantE2eeConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? receiver = null,
    Object? targetId = null,
    Object? isEnabled = null,
  }) {
    return _then(_self.copyWith(
      receiver: null == receiver
          ? _self.receiver
          : receiver // ignore: cast_nullable_to_non_nullable
              as RTCRtpReceiver,
      targetId: null == targetId
          ? _self.targetId
          : targetId // ignore: cast_nullable_to_non_nullable
              as String,
      isEnabled: null == isEnabled
          ? _self.isEnabled
          : isEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _ParticipantE2eeConfig implements ParticipantE2eeConfig {
  const _ParticipantE2eeConfig(
      {required this.receiver,
      required this.targetId,
      required this.isEnabled});

  @override
  final RTCRtpReceiver receiver;
  @override
  final String targetId;
  @override
  final bool isEnabled;

  /// Create a copy of ParticipantE2eeConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ParticipantE2eeConfigCopyWith<_ParticipantE2eeConfig> get copyWith =>
      __$ParticipantE2eeConfigCopyWithImpl<_ParticipantE2eeConfig>(
          this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ParticipantE2eeConfig &&
            (identical(other.receiver, receiver) ||
                other.receiver == receiver) &&
            (identical(other.targetId, targetId) ||
                other.targetId == targetId) &&
            (identical(other.isEnabled, isEnabled) ||
                other.isEnabled == isEnabled));
  }

  @override
  int get hashCode => Object.hash(runtimeType, receiver, targetId, isEnabled);

  @override
  String toString() {
    return 'ParticipantE2eeConfig(receiver: $receiver, targetId: $targetId, isEnabled: $isEnabled)';
  }
}

/// @nodoc
abstract mixin class _$ParticipantE2eeConfigCopyWith<$Res>
    implements $ParticipantE2eeConfigCopyWith<$Res> {
  factory _$ParticipantE2eeConfigCopyWith(_ParticipantE2eeConfig value,
          $Res Function(_ParticipantE2eeConfig) _then) =
      __$ParticipantE2eeConfigCopyWithImpl;
  @override
  @useResult
  $Res call({RTCRtpReceiver receiver, String targetId, bool isEnabled});
}

/// @nodoc
class __$ParticipantE2eeConfigCopyWithImpl<$Res>
    implements _$ParticipantE2eeConfigCopyWith<$Res> {
  __$ParticipantE2eeConfigCopyWithImpl(this._self, this._then);

  final _ParticipantE2eeConfig _self;
  final $Res Function(_ParticipantE2eeConfig) _then;

  /// Create a copy of ParticipantE2eeConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? receiver = null,
    Object? targetId = null,
    Object? isEnabled = null,
  }) {
    return _then(_ParticipantE2eeConfig(
      receiver: null == receiver
          ? _self.receiver
          : receiver // ignore: cast_nullable_to_non_nullable
              as RTCRtpReceiver,
      targetId: null == targetId
          ? _self.targetId
          : targetId // ignore: cast_nullable_to_non_nullable
              as String,
      isEnabled: null == isEnabled
          ? _self.isEnabled
          : isEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

// dart format on
