// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'audio_stats_params.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AudioStatsParams {
  String get ownerId;
  Function(AudioLevel) get callBack;
  RTCPeerConnection? get pc;
  List<RTCRtpReceiver> get receivers;

  /// Create a copy of AudioStatsParams
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AudioStatsParamsCopyWith<AudioStatsParams> get copyWith =>
      _$AudioStatsParamsCopyWithImpl<AudioStatsParams>(
          this as AudioStatsParams, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AudioStatsParams &&
            (identical(other.ownerId, ownerId) || other.ownerId == ownerId) &&
            (identical(other.callBack, callBack) ||
                other.callBack == callBack) &&
            (identical(other.pc, pc) || other.pc == pc) &&
            const DeepCollectionEquality().equals(other.receivers, receivers));
  }

  @override
  int get hashCode => Object.hash(runtimeType, ownerId, callBack, pc,
      const DeepCollectionEquality().hash(receivers));

  @override
  String toString() {
    return 'AudioStatsParams(ownerId: $ownerId, callBack: $callBack, pc: $pc, receivers: $receivers)';
  }
}

/// @nodoc
abstract mixin class $AudioStatsParamsCopyWith<$Res> {
  factory $AudioStatsParamsCopyWith(
          AudioStatsParams value, $Res Function(AudioStatsParams) _then) =
      _$AudioStatsParamsCopyWithImpl;
  @useResult
  $Res call(
      {String ownerId,
      Function(AudioLevel) callBack,
      RTCPeerConnection? pc,
      List<RTCRtpReceiver> receivers});
}

/// @nodoc
class _$AudioStatsParamsCopyWithImpl<$Res>
    implements $AudioStatsParamsCopyWith<$Res> {
  _$AudioStatsParamsCopyWithImpl(this._self, this._then);

  final AudioStatsParams _self;
  final $Res Function(AudioStatsParams) _then;

  /// Create a copy of AudioStatsParams
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? ownerId = null,
    Object? callBack = null,
    Object? pc = freezed,
    Object? receivers = null,
  }) {
    return _then(_self.copyWith(
      ownerId: null == ownerId
          ? _self.ownerId
          : ownerId // ignore: cast_nullable_to_non_nullable
              as String,
      callBack: null == callBack
          ? _self.callBack
          : callBack // ignore: cast_nullable_to_non_nullable
              as Function(AudioLevel),
      pc: freezed == pc
          ? _self.pc
          : pc // ignore: cast_nullable_to_non_nullable
              as RTCPeerConnection?,
      receivers: null == receivers
          ? _self.receivers
          : receivers // ignore: cast_nullable_to_non_nullable
              as List<RTCRtpReceiver>,
    ));
  }
}

/// @nodoc

class _AudioStatsParams implements AudioStatsParams {
  const _AudioStatsParams(
      {required this.ownerId,
      required this.callBack,
      this.pc,
      required final List<RTCRtpReceiver> receivers})
      : _receivers = receivers;

  @override
  final String ownerId;
  @override
  final Function(AudioLevel) callBack;
  @override
  final RTCPeerConnection? pc;
  final List<RTCRtpReceiver> _receivers;
  @override
  List<RTCRtpReceiver> get receivers {
    if (_receivers is EqualUnmodifiableListView) return _receivers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_receivers);
  }

  /// Create a copy of AudioStatsParams
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$AudioStatsParamsCopyWith<_AudioStatsParams> get copyWith =>
      __$AudioStatsParamsCopyWithImpl<_AudioStatsParams>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _AudioStatsParams &&
            (identical(other.ownerId, ownerId) || other.ownerId == ownerId) &&
            (identical(other.callBack, callBack) ||
                other.callBack == callBack) &&
            (identical(other.pc, pc) || other.pc == pc) &&
            const DeepCollectionEquality()
                .equals(other._receivers, _receivers));
  }

  @override
  int get hashCode => Object.hash(runtimeType, ownerId, callBack, pc,
      const DeepCollectionEquality().hash(_receivers));

  @override
  String toString() {
    return 'AudioStatsParams(ownerId: $ownerId, callBack: $callBack, pc: $pc, receivers: $receivers)';
  }
}

/// @nodoc
abstract mixin class _$AudioStatsParamsCopyWith<$Res>
    implements $AudioStatsParamsCopyWith<$Res> {
  factory _$AudioStatsParamsCopyWith(
          _AudioStatsParams value, $Res Function(_AudioStatsParams) _then) =
      __$AudioStatsParamsCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String ownerId,
      Function(AudioLevel) callBack,
      RTCPeerConnection? pc,
      List<RTCRtpReceiver> receivers});
}

/// @nodoc
class __$AudioStatsParamsCopyWithImpl<$Res>
    implements _$AudioStatsParamsCopyWith<$Res> {
  __$AudioStatsParamsCopyWithImpl(this._self, this._then);

  final _AudioStatsParams _self;
  final $Res Function(_AudioStatsParams) _then;

  /// Create a copy of AudioStatsParams
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? ownerId = null,
    Object? callBack = null,
    Object? pc = freezed,
    Object? receivers = null,
  }) {
    return _then(_AudioStatsParams(
      ownerId: null == ownerId
          ? _self.ownerId
          : ownerId // ignore: cast_nullable_to_non_nullable
              as String,
      callBack: null == callBack
          ? _self.callBack
          : callBack // ignore: cast_nullable_to_non_nullable
              as Function(AudioLevel),
      pc: freezed == pc
          ? _self.pc
          : pc // ignore: cast_nullable_to_non_nullable
              as RTCPeerConnection?,
      receivers: null == receivers
          ? _self._receivers
          : receivers // ignore: cast_nullable_to_non_nullable
              as List<RTCRtpReceiver>,
    ));
  }
}

// dart format on
