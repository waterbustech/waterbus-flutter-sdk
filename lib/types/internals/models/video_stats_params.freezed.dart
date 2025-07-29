// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'video_stats_params.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$VideoStatsParam {
  String get ownerId;
  Function(RtcParticipantStats) get callBack;
  List<RTCRtpSender> get senders;
  dynamic get receivers;

  /// Create a copy of VideoStatsParam
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $VideoStatsParamCopyWith<VideoStatsParam> get copyWith =>
      _$VideoStatsParamCopyWithImpl<VideoStatsParam>(
          this as VideoStatsParam, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is VideoStatsParam &&
            (identical(other.ownerId, ownerId) || other.ownerId == ownerId) &&
            (identical(other.callBack, callBack) ||
                other.callBack == callBack) &&
            const DeepCollectionEquality().equals(other.senders, senders) &&
            const DeepCollectionEquality().equals(other.receivers, receivers));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      ownerId,
      callBack,
      const DeepCollectionEquality().hash(senders),
      const DeepCollectionEquality().hash(receivers));

  @override
  String toString() {
    return 'VideoStatsParam(ownerId: $ownerId, callBack: $callBack, senders: $senders, receivers: $receivers)';
  }
}

/// @nodoc
abstract mixin class $VideoStatsParamCopyWith<$Res> {
  factory $VideoStatsParamCopyWith(
          VideoStatsParam value, $Res Function(VideoStatsParam) _then) =
      _$VideoStatsParamCopyWithImpl;
  @useResult
  $Res call(
      {String ownerId,
      Function(RtcParticipantStats) callBack,
      List<RTCRtpSender> senders,
      dynamic receivers});
}

/// @nodoc
class _$VideoStatsParamCopyWithImpl<$Res>
    implements $VideoStatsParamCopyWith<$Res> {
  _$VideoStatsParamCopyWithImpl(this._self, this._then);

  final VideoStatsParam _self;
  final $Res Function(VideoStatsParam) _then;

  /// Create a copy of VideoStatsParam
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? ownerId = null,
    Object? callBack = null,
    Object? senders = null,
    Object? receivers = freezed,
  }) {
    return _then(_self.copyWith(
      ownerId: null == ownerId
          ? _self.ownerId
          : ownerId // ignore: cast_nullable_to_non_nullable
              as String,
      callBack: null == callBack
          ? _self.callBack
          : callBack // ignore: cast_nullable_to_non_nullable
              as Function(RtcParticipantStats),
      senders: null == senders
          ? _self.senders
          : senders // ignore: cast_nullable_to_non_nullable
              as List<RTCRtpSender>,
      receivers: freezed == receivers
          ? _self.receivers
          : receivers // ignore: cast_nullable_to_non_nullable
              as dynamic,
    ));
  }
}

/// @nodoc

class _VideoStatsParam implements VideoStatsParam {
  const _VideoStatsParam(
      {required this.ownerId,
      required this.callBack,
      final List<RTCRtpSender> senders = const [],
      this.receivers = const []})
      : _senders = senders;

  @override
  final String ownerId;
  @override
  final Function(RtcParticipantStats) callBack;
  final List<RTCRtpSender> _senders;
  @override
  @JsonKey()
  List<RTCRtpSender> get senders {
    if (_senders is EqualUnmodifiableListView) return _senders;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_senders);
  }

  @override
  @JsonKey()
  final dynamic receivers;

  /// Create a copy of VideoStatsParam
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$VideoStatsParamCopyWith<_VideoStatsParam> get copyWith =>
      __$VideoStatsParamCopyWithImpl<_VideoStatsParam>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _VideoStatsParam &&
            (identical(other.ownerId, ownerId) || other.ownerId == ownerId) &&
            (identical(other.callBack, callBack) ||
                other.callBack == callBack) &&
            const DeepCollectionEquality().equals(other._senders, _senders) &&
            const DeepCollectionEquality().equals(other.receivers, receivers));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      ownerId,
      callBack,
      const DeepCollectionEquality().hash(_senders),
      const DeepCollectionEquality().hash(receivers));

  @override
  String toString() {
    return 'VideoStatsParam(ownerId: $ownerId, callBack: $callBack, senders: $senders, receivers: $receivers)';
  }
}

/// @nodoc
abstract mixin class _$VideoStatsParamCopyWith<$Res>
    implements $VideoStatsParamCopyWith<$Res> {
  factory _$VideoStatsParamCopyWith(
          _VideoStatsParam value, $Res Function(_VideoStatsParam) _then) =
      __$VideoStatsParamCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String ownerId,
      Function(RtcParticipantStats) callBack,
      List<RTCRtpSender> senders,
      dynamic receivers});
}

/// @nodoc
class __$VideoStatsParamCopyWithImpl<$Res>
    implements _$VideoStatsParamCopyWith<$Res> {
  __$VideoStatsParamCopyWithImpl(this._self, this._then);

  final _VideoStatsParam _self;
  final $Res Function(_VideoStatsParam) _then;

  /// Create a copy of VideoStatsParam
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? ownerId = null,
    Object? callBack = null,
    Object? senders = null,
    Object? receivers = freezed,
  }) {
    return _then(_VideoStatsParam(
      ownerId: null == ownerId
          ? _self.ownerId
          : ownerId // ignore: cast_nullable_to_non_nullable
              as String,
      callBack: null == callBack
          ? _self.callBack
          : callBack // ignore: cast_nullable_to_non_nullable
              as Function(RtcParticipantStats),
      senders: null == senders
          ? _self._senders
          : senders // ignore: cast_nullable_to_non_nullable
              as List<RTCRtpSender>,
      receivers: freezed == receivers
          ? _self.receivers
          : receivers // ignore: cast_nullable_to_non_nullable
              as dynamic,
    ));
  }
}

// dart format on
