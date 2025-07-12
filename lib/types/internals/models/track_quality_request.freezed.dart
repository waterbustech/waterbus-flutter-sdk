// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'track_quality_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TrackQualityRequest {
  String get trackId;
  TrackQuality get quality;

  /// Create a copy of TrackQualityRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TrackQualityRequestCopyWith<TrackQualityRequest> get copyWith =>
      _$TrackQualityRequestCopyWithImpl<TrackQualityRequest>(
          this as TrackQualityRequest, _$identity);

  /// Serializes this TrackQualityRequest to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TrackQualityRequest &&
            (identical(other.trackId, trackId) || other.trackId == trackId) &&
            (identical(other.quality, quality) || other.quality == quality));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, trackId, quality);

  @override
  String toString() {
    return 'TrackQualityRequest(trackId: $trackId, quality: $quality)';
  }
}

/// @nodoc
abstract mixin class $TrackQualityRequestCopyWith<$Res> {
  factory $TrackQualityRequestCopyWith(
          TrackQualityRequest value, $Res Function(TrackQualityRequest) _then) =
      _$TrackQualityRequestCopyWithImpl;
  @useResult
  $Res call({String trackId, TrackQuality quality});
}

/// @nodoc
class _$TrackQualityRequestCopyWithImpl<$Res>
    implements $TrackQualityRequestCopyWith<$Res> {
  _$TrackQualityRequestCopyWithImpl(this._self, this._then);

  final TrackQualityRequest _self;
  final $Res Function(TrackQualityRequest) _then;

  /// Create a copy of TrackQualityRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? trackId = null,
    Object? quality = null,
  }) {
    return _then(_self.copyWith(
      trackId: null == trackId
          ? _self.trackId
          : trackId // ignore: cast_nullable_to_non_nullable
              as String,
      quality: null == quality
          ? _self.quality
          : quality // ignore: cast_nullable_to_non_nullable
              as TrackQuality,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _TrackQualityRequest implements TrackQualityRequest {
  const _TrackQualityRequest({required this.trackId, required this.quality});
  factory _TrackQualityRequest.fromJson(Map<String, dynamic> json) =>
      _$TrackQualityRequestFromJson(json);

  @override
  final String trackId;
  @override
  final TrackQuality quality;

  /// Create a copy of TrackQualityRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$TrackQualityRequestCopyWith<_TrackQualityRequest> get copyWith =>
      __$TrackQualityRequestCopyWithImpl<_TrackQualityRequest>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$TrackQualityRequestToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _TrackQualityRequest &&
            (identical(other.trackId, trackId) || other.trackId == trackId) &&
            (identical(other.quality, quality) || other.quality == quality));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, trackId, quality);

  @override
  String toString() {
    return 'TrackQualityRequest(trackId: $trackId, quality: $quality)';
  }
}

/// @nodoc
abstract mixin class _$TrackQualityRequestCopyWith<$Res>
    implements $TrackQualityRequestCopyWith<$Res> {
  factory _$TrackQualityRequestCopyWith(_TrackQualityRequest value,
          $Res Function(_TrackQualityRequest) _then) =
      __$TrackQualityRequestCopyWithImpl;
  @override
  @useResult
  $Res call({String trackId, TrackQuality quality});
}

/// @nodoc
class __$TrackQualityRequestCopyWithImpl<$Res>
    implements _$TrackQualityRequestCopyWith<$Res> {
  __$TrackQualityRequestCopyWithImpl(this._self, this._then);

  final _TrackQualityRequest _self;
  final $Res Function(_TrackQualityRequest) _then;

  /// Create a copy of TrackQualityRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? trackId = null,
    Object? quality = null,
  }) {
    return _then(_TrackQualityRequest(
      trackId: null == trackId
          ? _self.trackId
          : trackId // ignore: cast_nullable_to_non_nullable
              as String,
      quality: null == quality
          ? _self.quality
          : quality // ignore: cast_nullable_to_non_nullable
              as TrackQuality,
    ));
  }
}

// dart format on
