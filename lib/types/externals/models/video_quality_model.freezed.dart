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

  /// Create a copy of VideoQualityModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $VideoQualityModelCopyWith<VideoQualityModel> get copyWith =>
      _$VideoQualityModelCopyWithImpl<VideoQualityModel>(
          this as VideoQualityModel, _$identity);

  /// Serializes this VideoQualityModel to a JSON map.
  Map<String, dynamic> toJson();

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
                other.minFrameRate == minFrameRate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, minHeight, minWidth, minFrameRate);

  @override
  String toString() {
    return 'VideoQualityModel(minHeight: $minHeight, minWidth: $minWidth, minFrameRate: $minFrameRate)';
  }
}

/// @nodoc
abstract mixin class $VideoQualityModelCopyWith<$Res> {
  factory $VideoQualityModelCopyWith(
          VideoQualityModel value, $Res Function(VideoQualityModel) _then) =
      _$VideoQualityModelCopyWithImpl;
  @useResult
  $Res call({int minHeight, int minWidth, int minFrameRate});
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
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _VideoQualityModel implements VideoQualityModel {
  const _VideoQualityModel(
      {required this.minHeight,
      required this.minWidth,
      required this.minFrameRate});
  factory _VideoQualityModel.fromJson(Map<String, dynamic> json) =>
      _$VideoQualityModelFromJson(json);

  @override
  final int minHeight;
  @override
  final int minWidth;
  @override
  final int minFrameRate;

  /// Create a copy of VideoQualityModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$VideoQualityModelCopyWith<_VideoQualityModel> get copyWith =>
      __$VideoQualityModelCopyWithImpl<_VideoQualityModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$VideoQualityModelToJson(
      this,
    );
  }

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
                other.minFrameRate == minFrameRate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, minHeight, minWidth, minFrameRate);

  @override
  String toString() {
    return 'VideoQualityModel(minHeight: $minHeight, minWidth: $minWidth, minFrameRate: $minFrameRate)';
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
  $Res call({int minHeight, int minWidth, int minFrameRate});
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
    ));
  }
}

// dart format on
