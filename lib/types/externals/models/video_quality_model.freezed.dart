// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'video_quality_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$VideoQualityModel {
  int get minHeight;
  int get minWidth;
  int get minFrameRate;
  int? get frameRate;
  int? get height;
  int? get width;

  /// Create a copy of VideoQualityModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $VideoQualityModelCopyWith<VideoQualityModel> get copyWith =>
      _$VideoQualityModelCopyWithImpl<VideoQualityModel>(
          this as VideoQualityModel, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is VideoQualityModel &&
            (identical(other.minHeight, minHeight) ||
                other.minHeight == minHeight) &&
            (identical(other.minWidth, minWidth) ||
                other.minWidth == minWidth) &&
            (identical(other.minFrameRate, minFrameRate) ||
                other.minFrameRate == minFrameRate) &&
            (identical(other.frameRate, frameRate) ||
                other.frameRate == frameRate) &&
            (identical(other.height, height) || other.height == height) &&
            (identical(other.width, width) || other.width == width));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, minHeight, minWidth, minFrameRate, frameRate, height, width);

  @override
  String toString() {
    return 'VideoQualityModel(minHeight: $minHeight, minWidth: $minWidth, minFrameRate: $minFrameRate, frameRate: $frameRate, height: $height, width: $width)';
  }
}

/// @nodoc
abstract mixin class $VideoQualityModelCopyWith<$Res> {
  factory $VideoQualityModelCopyWith(
          VideoQualityModel value, $Res Function(VideoQualityModel) _then) =
      _$VideoQualityModelCopyWithImpl;
  @useResult
  $Res call(
      {int minHeight,
      int minWidth,
      int minFrameRate,
      int? frameRate,
      int? height,
      int? width});
}

/// @nodoc
class _$VideoQualityModelCopyWithImpl<$Res>
    implements $VideoQualityModelCopyWith<$Res> {
  _$VideoQualityModelCopyWithImpl(this._self, this._then);

  final VideoQualityModel _self;
  final $Res Function(VideoQualityModel) _then;

  /// Create a copy of VideoQualityModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? minHeight = null,
    Object? minWidth = null,
    Object? minFrameRate = null,
    Object? frameRate = freezed,
    Object? height = freezed,
    Object? width = freezed,
  }) {
    return _then(_self.copyWith(
      minHeight: null == minHeight
          ? _self.minHeight
          : minHeight // ignore: cast_nullable_to_non_nullable
              as int,
      minWidth: null == minWidth
          ? _self.minWidth
          : minWidth // ignore: cast_nullable_to_non_nullable
              as int,
      minFrameRate: null == minFrameRate
          ? _self.minFrameRate
          : minFrameRate // ignore: cast_nullable_to_non_nullable
              as int,
      frameRate: freezed == frameRate
          ? _self.frameRate
          : frameRate // ignore: cast_nullable_to_non_nullable
              as int?,
      height: freezed == height
          ? _self.height
          : height // ignore: cast_nullable_to_non_nullable
              as int?,
      width: freezed == width
          ? _self.width
          : width // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc

class _VideoQualityModel implements VideoQualityModel {
  const _VideoQualityModel(
      {required this.minHeight,
      required this.minWidth,
      required this.minFrameRate,
      this.frameRate,
      this.height,
      this.width});

  @override
  final int minHeight;
  @override
  final int minWidth;
  @override
  final int minFrameRate;
  @override
  final int? frameRate;
  @override
  final int? height;
  @override
  final int? width;

  /// Create a copy of VideoQualityModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$VideoQualityModelCopyWith<_VideoQualityModel> get copyWith =>
      __$VideoQualityModelCopyWithImpl<_VideoQualityModel>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _VideoQualityModel &&
            (identical(other.minHeight, minHeight) ||
                other.minHeight == minHeight) &&
            (identical(other.minWidth, minWidth) ||
                other.minWidth == minWidth) &&
            (identical(other.minFrameRate, minFrameRate) ||
                other.minFrameRate == minFrameRate) &&
            (identical(other.frameRate, frameRate) ||
                other.frameRate == frameRate) &&
            (identical(other.height, height) || other.height == height) &&
            (identical(other.width, width) || other.width == width));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, minHeight, minWidth, minFrameRate, frameRate, height, width);

  @override
  String toString() {
    return 'VideoQualityModel(minHeight: $minHeight, minWidth: $minWidth, minFrameRate: $minFrameRate, frameRate: $frameRate, height: $height, width: $width)';
  }
}

/// @nodoc
abstract mixin class _$VideoQualityModelCopyWith<$Res>
    implements $VideoQualityModelCopyWith<$Res> {
  factory _$VideoQualityModelCopyWith(
          _VideoQualityModel value, $Res Function(_VideoQualityModel) _then) =
      __$VideoQualityModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int minHeight,
      int minWidth,
      int minFrameRate,
      int? frameRate,
      int? height,
      int? width});
}

/// @nodoc
class __$VideoQualityModelCopyWithImpl<$Res>
    implements _$VideoQualityModelCopyWith<$Res> {
  __$VideoQualityModelCopyWithImpl(this._self, this._then);

  final _VideoQualityModel _self;
  final $Res Function(_VideoQualityModel) _then;

  /// Create a copy of VideoQualityModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? minHeight = null,
    Object? minWidth = null,
    Object? minFrameRate = null,
    Object? frameRate = freezed,
    Object? height = freezed,
    Object? width = freezed,
  }) {
    return _then(_VideoQualityModel(
      minHeight: null == minHeight
          ? _self.minHeight
          : minHeight // ignore: cast_nullable_to_non_nullable
              as int,
      minWidth: null == minWidth
          ? _self.minWidth
          : minWidth // ignore: cast_nullable_to_non_nullable
              as int,
      minFrameRate: null == minFrameRate
          ? _self.minFrameRate
          : minFrameRate // ignore: cast_nullable_to_non_nullable
              as int,
      frameRate: freezed == frameRate
          ? _self.frameRate
          : frameRate // ignore: cast_nullable_to_non_nullable
              as int?,
      height: freezed == height
          ? _self.height
          : height // ignore: cast_nullable_to_non_nullable
              as int?,
      width: freezed == width
          ? _self.width
          : width // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

// dart format on
