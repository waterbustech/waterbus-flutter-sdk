// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'video_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$VideoConfig {
  String? get deviceId;
  bool get isVideoMuted;
  RTCVideoCodec get preferedCodec;
  VideoQualityEnum get videoQuality;

  /// Create a copy of VideoConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $VideoConfigCopyWith<VideoConfig> get copyWith =>
      _$VideoConfigCopyWithImpl<VideoConfig>(this as VideoConfig, _$identity);

  /// Serializes this VideoConfig to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is VideoConfig &&
            (identical(other.deviceId, deviceId) ||
                other.deviceId == deviceId) &&
            (identical(other.isVideoMuted, isVideoMuted) ||
                other.isVideoMuted == isVideoMuted) &&
            (identical(other.preferedCodec, preferedCodec) ||
                other.preferedCodec == preferedCodec) &&
            (identical(other.videoQuality, videoQuality) ||
                other.videoQuality == videoQuality));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, deviceId, isVideoMuted, preferedCodec, videoQuality);

  @override
  String toString() {
    return 'VideoConfig(deviceId: $deviceId, isVideoMuted: $isVideoMuted, preferedCodec: $preferedCodec, videoQuality: $videoQuality)';
  }
}

/// @nodoc
abstract mixin class $VideoConfigCopyWith<$Res> {
  factory $VideoConfigCopyWith(
          VideoConfig value, $Res Function(VideoConfig) _then) =
      _$VideoConfigCopyWithImpl;
  @useResult
  $Res call(
      {String? deviceId,
      bool isVideoMuted,
      RTCVideoCodec preferedCodec,
      VideoQualityEnum videoQuality});
}

/// @nodoc
class _$VideoConfigCopyWithImpl<$Res> implements $VideoConfigCopyWith<$Res> {
  _$VideoConfigCopyWithImpl(this._self, this._then);

  final VideoConfig _self;
  final $Res Function(VideoConfig) _then;

  /// Create a copy of VideoConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? deviceId = freezed,
    Object? isVideoMuted = null,
    Object? preferedCodec = null,
    Object? videoQuality = null,
  }) {
    return _then(_self.copyWith(
      deviceId: freezed == deviceId
          ? _self.deviceId
          : deviceId // ignore: cast_nullable_to_non_nullable
              as String?,
      isVideoMuted: null == isVideoMuted
          ? _self.isVideoMuted
          : isVideoMuted // ignore: cast_nullable_to_non_nullable
              as bool,
      preferedCodec: null == preferedCodec
          ? _self.preferedCodec
          : preferedCodec // ignore: cast_nullable_to_non_nullable
              as RTCVideoCodec,
      videoQuality: null == videoQuality
          ? _self.videoQuality
          : videoQuality // ignore: cast_nullable_to_non_nullable
              as VideoQualityEnum,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _VideoConfig implements VideoConfig {
  const _VideoConfig(
      {this.deviceId,
      this.isVideoMuted = false,
      this.preferedCodec = RTCVideoCodec.h264,
      this.videoQuality = VideoQualityEnum.p1080});
  factory _VideoConfig.fromJson(Map<String, dynamic> json) =>
      _$VideoConfigFromJson(json);

  @override
  final String? deviceId;
  @override
  @JsonKey()
  final bool isVideoMuted;
  @override
  @JsonKey()
  final RTCVideoCodec preferedCodec;
  @override
  @JsonKey()
  final VideoQualityEnum videoQuality;

  /// Create a copy of VideoConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$VideoConfigCopyWith<_VideoConfig> get copyWith =>
      __$VideoConfigCopyWithImpl<_VideoConfig>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$VideoConfigToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _VideoConfig &&
            (identical(other.deviceId, deviceId) ||
                other.deviceId == deviceId) &&
            (identical(other.isVideoMuted, isVideoMuted) ||
                other.isVideoMuted == isVideoMuted) &&
            (identical(other.preferedCodec, preferedCodec) ||
                other.preferedCodec == preferedCodec) &&
            (identical(other.videoQuality, videoQuality) ||
                other.videoQuality == videoQuality));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, deviceId, isVideoMuted, preferedCodec, videoQuality);

  @override
  String toString() {
    return 'VideoConfig(deviceId: $deviceId, isVideoMuted: $isVideoMuted, preferedCodec: $preferedCodec, videoQuality: $videoQuality)';
  }
}

/// @nodoc
abstract mixin class _$VideoConfigCopyWith<$Res>
    implements $VideoConfigCopyWith<$Res> {
  factory _$VideoConfigCopyWith(
          _VideoConfig value, $Res Function(_VideoConfig) _then) =
      __$VideoConfigCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String? deviceId,
      bool isVideoMuted,
      RTCVideoCodec preferedCodec,
      VideoQualityEnum videoQuality});
}

/// @nodoc
class __$VideoConfigCopyWithImpl<$Res> implements _$VideoConfigCopyWith<$Res> {
  __$VideoConfigCopyWithImpl(this._self, this._then);

  final _VideoConfig _self;
  final $Res Function(_VideoConfig) _then;

  /// Create a copy of VideoConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? deviceId = freezed,
    Object? isVideoMuted = null,
    Object? preferedCodec = null,
    Object? videoQuality = null,
  }) {
    return _then(_VideoConfig(
      deviceId: freezed == deviceId
          ? _self.deviceId
          : deviceId // ignore: cast_nullable_to_non_nullable
              as String?,
      isVideoMuted: null == isVideoMuted
          ? _self.isVideoMuted
          : isVideoMuted // ignore: cast_nullable_to_non_nullable
              as bool,
      preferedCodec: null == preferedCodec
          ? _self.preferedCodec
          : preferedCodec // ignore: cast_nullable_to_non_nullable
              as RTCVideoCodec,
      videoQuality: null == videoQuality
          ? _self.videoQuality
          : videoQuality // ignore: cast_nullable_to_non_nullable
              as VideoQualityEnum,
    ));
  }
}

// dart format on
