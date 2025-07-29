// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'beauty_filters.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BeautyFilters {
  double get smoothValue;
  double get whiteValue;
  double get thinFaceValue;
  double get bigEyeValue;
  double get lipstickValue;
  double get blusherValue;

  /// Create a copy of BeautyFilters
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $BeautyFiltersCopyWith<BeautyFilters> get copyWith =>
      _$BeautyFiltersCopyWithImpl<BeautyFilters>(
          this as BeautyFilters, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is BeautyFilters &&
            (identical(other.smoothValue, smoothValue) ||
                other.smoothValue == smoothValue) &&
            (identical(other.whiteValue, whiteValue) ||
                other.whiteValue == whiteValue) &&
            (identical(other.thinFaceValue, thinFaceValue) ||
                other.thinFaceValue == thinFaceValue) &&
            (identical(other.bigEyeValue, bigEyeValue) ||
                other.bigEyeValue == bigEyeValue) &&
            (identical(other.lipstickValue, lipstickValue) ||
                other.lipstickValue == lipstickValue) &&
            (identical(other.blusherValue, blusherValue) ||
                other.blusherValue == blusherValue));
  }

  @override
  int get hashCode => Object.hash(runtimeType, smoothValue, whiteValue,
      thinFaceValue, bigEyeValue, lipstickValue, blusherValue);

  @override
  String toString() {
    return 'BeautyFilters(smoothValue: $smoothValue, whiteValue: $whiteValue, thinFaceValue: $thinFaceValue, bigEyeValue: $bigEyeValue, lipstickValue: $lipstickValue, blusherValue: $blusherValue)';
  }
}

/// @nodoc
abstract mixin class $BeautyFiltersCopyWith<$Res> {
  factory $BeautyFiltersCopyWith(
          BeautyFilters value, $Res Function(BeautyFilters) _then) =
      _$BeautyFiltersCopyWithImpl;
  @useResult
  $Res call(
      {double smoothValue,
      double whiteValue,
      double thinFaceValue,
      double bigEyeValue,
      double lipstickValue,
      double blusherValue});
}

/// @nodoc
class _$BeautyFiltersCopyWithImpl<$Res>
    implements $BeautyFiltersCopyWith<$Res> {
  _$BeautyFiltersCopyWithImpl(this._self, this._then);

  final BeautyFilters _self;
  final $Res Function(BeautyFilters) _then;

  /// Create a copy of BeautyFilters
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? smoothValue = null,
    Object? whiteValue = null,
    Object? thinFaceValue = null,
    Object? bigEyeValue = null,
    Object? lipstickValue = null,
    Object? blusherValue = null,
  }) {
    return _then(_self.copyWith(
      smoothValue: null == smoothValue
          ? _self.smoothValue
          : smoothValue // ignore: cast_nullable_to_non_nullable
              as double,
      whiteValue: null == whiteValue
          ? _self.whiteValue
          : whiteValue // ignore: cast_nullable_to_non_nullable
              as double,
      thinFaceValue: null == thinFaceValue
          ? _self.thinFaceValue
          : thinFaceValue // ignore: cast_nullable_to_non_nullable
              as double,
      bigEyeValue: null == bigEyeValue
          ? _self.bigEyeValue
          : bigEyeValue // ignore: cast_nullable_to_non_nullable
              as double,
      lipstickValue: null == lipstickValue
          ? _self.lipstickValue
          : lipstickValue // ignore: cast_nullable_to_non_nullable
              as double,
      blusherValue: null == blusherValue
          ? _self.blusherValue
          : blusherValue // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// Adds pattern-matching-related methods to [BeautyFilters].
extension BeautyFiltersPatterns on BeautyFilters {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_BeautyFilters value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _BeautyFilters() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_BeautyFilters value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BeautyFilters():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_BeautyFilters value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BeautyFilters() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            double smoothValue,
            double whiteValue,
            double thinFaceValue,
            double bigEyeValue,
            double lipstickValue,
            double blusherValue)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _BeautyFilters() when $default != null:
        return $default(
            _that.smoothValue,
            _that.whiteValue,
            _that.thinFaceValue,
            _that.bigEyeValue,
            _that.lipstickValue,
            _that.blusherValue);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            double smoothValue,
            double whiteValue,
            double thinFaceValue,
            double bigEyeValue,
            double lipstickValue,
            double blusherValue)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BeautyFilters():
        return $default(
            _that.smoothValue,
            _that.whiteValue,
            _that.thinFaceValue,
            _that.bigEyeValue,
            _that.lipstickValue,
            _that.blusherValue);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            double smoothValue,
            double whiteValue,
            double thinFaceValue,
            double bigEyeValue,
            double lipstickValue,
            double blusherValue)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BeautyFilters() when $default != null:
        return $default(
            _that.smoothValue,
            _that.whiteValue,
            _that.thinFaceValue,
            _that.bigEyeValue,
            _that.lipstickValue,
            _that.blusherValue);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _BeautyFilters implements BeautyFilters {
  const _BeautyFilters(
      {this.smoothValue = 0,
      this.whiteValue = 0,
      this.thinFaceValue = 0,
      this.bigEyeValue = 0,
      this.lipstickValue = 0,
      this.blusherValue = 0});

  @override
  @JsonKey()
  final double smoothValue;
  @override
  @JsonKey()
  final double whiteValue;
  @override
  @JsonKey()
  final double thinFaceValue;
  @override
  @JsonKey()
  final double bigEyeValue;
  @override
  @JsonKey()
  final double lipstickValue;
  @override
  @JsonKey()
  final double blusherValue;

  /// Create a copy of BeautyFilters
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$BeautyFiltersCopyWith<_BeautyFilters> get copyWith =>
      __$BeautyFiltersCopyWithImpl<_BeautyFilters>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _BeautyFilters &&
            (identical(other.smoothValue, smoothValue) ||
                other.smoothValue == smoothValue) &&
            (identical(other.whiteValue, whiteValue) ||
                other.whiteValue == whiteValue) &&
            (identical(other.thinFaceValue, thinFaceValue) ||
                other.thinFaceValue == thinFaceValue) &&
            (identical(other.bigEyeValue, bigEyeValue) ||
                other.bigEyeValue == bigEyeValue) &&
            (identical(other.lipstickValue, lipstickValue) ||
                other.lipstickValue == lipstickValue) &&
            (identical(other.blusherValue, blusherValue) ||
                other.blusherValue == blusherValue));
  }

  @override
  int get hashCode => Object.hash(runtimeType, smoothValue, whiteValue,
      thinFaceValue, bigEyeValue, lipstickValue, blusherValue);

  @override
  String toString() {
    return 'BeautyFilters(smoothValue: $smoothValue, whiteValue: $whiteValue, thinFaceValue: $thinFaceValue, bigEyeValue: $bigEyeValue, lipstickValue: $lipstickValue, blusherValue: $blusherValue)';
  }
}

/// @nodoc
abstract mixin class _$BeautyFiltersCopyWith<$Res>
    implements $BeautyFiltersCopyWith<$Res> {
  factory _$BeautyFiltersCopyWith(
          _BeautyFilters value, $Res Function(_BeautyFilters) _then) =
      __$BeautyFiltersCopyWithImpl;
  @override
  @useResult
  $Res call(
      {double smoothValue,
      double whiteValue,
      double thinFaceValue,
      double bigEyeValue,
      double lipstickValue,
      double blusherValue});
}

/// @nodoc
class __$BeautyFiltersCopyWithImpl<$Res>
    implements _$BeautyFiltersCopyWith<$Res> {
  __$BeautyFiltersCopyWithImpl(this._self, this._then);

  final _BeautyFilters _self;
  final $Res Function(_BeautyFilters) _then;

  /// Create a copy of BeautyFilters
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? smoothValue = null,
    Object? whiteValue = null,
    Object? thinFaceValue = null,
    Object? bigEyeValue = null,
    Object? lipstickValue = null,
    Object? blusherValue = null,
  }) {
    return _then(_BeautyFilters(
      smoothValue: null == smoothValue
          ? _self.smoothValue
          : smoothValue // ignore: cast_nullable_to_non_nullable
              as double,
      whiteValue: null == whiteValue
          ? _self.whiteValue
          : whiteValue // ignore: cast_nullable_to_non_nullable
              as double,
      thinFaceValue: null == thinFaceValue
          ? _self.thinFaceValue
          : thinFaceValue // ignore: cast_nullable_to_non_nullable
              as double,
      bigEyeValue: null == bigEyeValue
          ? _self.bigEyeValue
          : bigEyeValue // ignore: cast_nullable_to_non_nullable
              as double,
      lipstickValue: null == lipstickValue
          ? _self.lipstickValue
          : lipstickValue // ignore: cast_nullable_to_non_nullable
              as double,
      blusherValue: null == blusherValue
          ? _self.blusherValue
          : blusherValue // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

// dart format on
