// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
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

/// Adds pattern-matching-related methods to [ParticipantE2eeConfig].
extension ParticipantE2eeConfigPatterns on ParticipantE2eeConfig {
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
    TResult Function(_ParticipantE2eeConfig value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ParticipantE2eeConfig() when $default != null:
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
    TResult Function(_ParticipantE2eeConfig value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ParticipantE2eeConfig():
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
    TResult? Function(_ParticipantE2eeConfig value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ParticipantE2eeConfig() when $default != null:
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
    TResult Function(RTCRtpReceiver receiver, String targetId, bool isEnabled)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ParticipantE2eeConfig() when $default != null:
        return $default(_that.receiver, _that.targetId, _that.isEnabled);
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
    TResult Function(RTCRtpReceiver receiver, String targetId, bool isEnabled)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ParticipantE2eeConfig():
        return $default(_that.receiver, _that.targetId, _that.isEnabled);
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
    TResult? Function(RTCRtpReceiver receiver, String targetId, bool isEnabled)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ParticipantE2eeConfig() when $default != null:
        return $default(_that.receiver, _that.targetId, _that.isEnabled);
      case _:
        return null;
    }
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
