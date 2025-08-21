// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'room_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RoomState implements DiagnosticableTreeMixin {
  LocalParticipant? get localParticipant;
  Map<String, RemoteParticipant> get remoteParticipants;

  /// Create a copy of RoomState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $RoomStateCopyWith<RoomState> get copyWith =>
      _$RoomStateCopyWithImpl<RoomState>(this as RoomState, _$identity);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
      ..add(DiagnosticsProperty('type', 'RoomState'))
      ..add(DiagnosticsProperty('localParticipant', localParticipant))
      ..add(DiagnosticsProperty('remoteParticipants', remoteParticipants));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is RoomState &&
            (identical(other.localParticipant, localParticipant) ||
                other.localParticipant == localParticipant) &&
            const DeepCollectionEquality()
                .equals(other.remoteParticipants, remoteParticipants));
  }

  @override
  int get hashCode => Object.hash(runtimeType, localParticipant,
      const DeepCollectionEquality().hash(remoteParticipants));

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'RoomState(localParticipant: $localParticipant, remoteParticipants: $remoteParticipants)';
  }
}

/// @nodoc
abstract mixin class $RoomStateCopyWith<$Res> {
  factory $RoomStateCopyWith(RoomState value, $Res Function(RoomState) _then) =
      _$RoomStateCopyWithImpl;
  @useResult
  $Res call(
      {LocalParticipant? localParticipant,
      Map<String, RemoteParticipant> remoteParticipants});
}

/// @nodoc
class _$RoomStateCopyWithImpl<$Res> implements $RoomStateCopyWith<$Res> {
  _$RoomStateCopyWithImpl(this._self, this._then);

  final RoomState _self;
  final $Res Function(RoomState) _then;

  /// Create a copy of RoomState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? localParticipant = freezed,
    Object? remoteParticipants = null,
  }) {
    return _then(_self.copyWith(
      localParticipant: freezed == localParticipant
          ? _self.localParticipant
          : localParticipant // ignore: cast_nullable_to_non_nullable
              as LocalParticipant?,
      remoteParticipants: null == remoteParticipants
          ? _self.remoteParticipants
          : remoteParticipants // ignore: cast_nullable_to_non_nullable
              as Map<String, RemoteParticipant>,
    ));
  }
}

/// Adds pattern-matching-related methods to [RoomState].
extension RoomStatePatterns on RoomState {
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
    TResult Function(_RoomState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _RoomState() when $default != null:
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
    TResult Function(_RoomState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RoomState():
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
    TResult? Function(_RoomState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RoomState() when $default != null:
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
    TResult Function(LocalParticipant? localParticipant,
            Map<String, RemoteParticipant> remoteParticipants)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _RoomState() when $default != null:
        return $default(_that.localParticipant, _that.remoteParticipants);
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
    TResult Function(LocalParticipant? localParticipant,
            Map<String, RemoteParticipant> remoteParticipants)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RoomState():
        return $default(_that.localParticipant, _that.remoteParticipants);
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
    TResult? Function(LocalParticipant? localParticipant,
            Map<String, RemoteParticipant> remoteParticipants)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RoomState() when $default != null:
        return $default(_that.localParticipant, _that.remoteParticipants);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _RoomState extends RoomState with DiagnosticableTreeMixin {
  const _RoomState(
      {this.localParticipant,
      required final Map<String, RemoteParticipant> remoteParticipants})
      : _remoteParticipants = remoteParticipants,
        super._();

  @override
  final LocalParticipant? localParticipant;
  final Map<String, RemoteParticipant> _remoteParticipants;
  @override
  Map<String, RemoteParticipant> get remoteParticipants {
    if (_remoteParticipants is EqualUnmodifiableMapView)
      return _remoteParticipants;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_remoteParticipants);
  }

  /// Create a copy of RoomState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$RoomStateCopyWith<_RoomState> get copyWith =>
      __$RoomStateCopyWithImpl<_RoomState>(this, _$identity);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
      ..add(DiagnosticsProperty('type', 'RoomState'))
      ..add(DiagnosticsProperty('localParticipant', localParticipant))
      ..add(DiagnosticsProperty('remoteParticipants', remoteParticipants));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _RoomState &&
            (identical(other.localParticipant, localParticipant) ||
                other.localParticipant == localParticipant) &&
            const DeepCollectionEquality()
                .equals(other._remoteParticipants, _remoteParticipants));
  }

  @override
  int get hashCode => Object.hash(runtimeType, localParticipant,
      const DeepCollectionEquality().hash(_remoteParticipants));

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'RoomState(localParticipant: $localParticipant, remoteParticipants: $remoteParticipants)';
  }
}

/// @nodoc
abstract mixin class _$RoomStateCopyWith<$Res>
    implements $RoomStateCopyWith<$Res> {
  factory _$RoomStateCopyWith(
          _RoomState value, $Res Function(_RoomState) _then) =
      __$RoomStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {LocalParticipant? localParticipant,
      Map<String, RemoteParticipant> remoteParticipants});
}

/// @nodoc
class __$RoomStateCopyWithImpl<$Res> implements _$RoomStateCopyWith<$Res> {
  __$RoomStateCopyWithImpl(this._self, this._then);

  final _RoomState _self;
  final $Res Function(_RoomState) _then;

  /// Create a copy of RoomState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? localParticipant = freezed,
    Object? remoteParticipants = null,
  }) {
    return _then(_RoomState(
      localParticipant: freezed == localParticipant
          ? _self.localParticipant
          : localParticipant // ignore: cast_nullable_to_non_nullable
              as LocalParticipant?,
      remoteParticipants: null == remoteParticipants
          ? _self._remoteParticipants
          : remoteParticipants // ignore: cast_nullable_to_non_nullable
              as Map<String, RemoteParticipant>,
    ));
  }
}

// dart format on
