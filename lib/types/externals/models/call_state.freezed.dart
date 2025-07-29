// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'call_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CallState implements DiagnosticableTreeMixin {
  ParticipantMediaState? get mParticipant;
  Map<String, ParticipantMediaState> get participants;

  /// Create a copy of CallState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CallStateCopyWith<CallState> get copyWith =>
      _$CallStateCopyWithImpl<CallState>(this as CallState, _$identity);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
      ..add(DiagnosticsProperty('type', 'CallState'))
      ..add(DiagnosticsProperty('mParticipant', mParticipant))
      ..add(DiagnosticsProperty('participants', participants));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CallState &&
            (identical(other.mParticipant, mParticipant) ||
                other.mParticipant == mParticipant) &&
            const DeepCollectionEquality()
                .equals(other.participants, participants));
  }

  @override
  int get hashCode => Object.hash(runtimeType, mParticipant,
      const DeepCollectionEquality().hash(participants));

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'CallState(mParticipant: $mParticipant, participants: $participants)';
  }
}

/// @nodoc
abstract mixin class $CallStateCopyWith<$Res> {
  factory $CallStateCopyWith(CallState value, $Res Function(CallState) _then) =
      _$CallStateCopyWithImpl;
  @useResult
  $Res call(
      {ParticipantMediaState? mParticipant,
      Map<String, ParticipantMediaState> participants});

  $ParticipantMediaStateCopyWith<$Res>? get mParticipant;
}

/// @nodoc
class _$CallStateCopyWithImpl<$Res> implements $CallStateCopyWith<$Res> {
  _$CallStateCopyWithImpl(this._self, this._then);

  final CallState _self;
  final $Res Function(CallState) _then;

  /// Create a copy of CallState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? mParticipant = freezed,
    Object? participants = null,
  }) {
    return _then(_self.copyWith(
      mParticipant: freezed == mParticipant
          ? _self.mParticipant
          : mParticipant // ignore: cast_nullable_to_non_nullable
              as ParticipantMediaState?,
      participants: null == participants
          ? _self.participants
          : participants // ignore: cast_nullable_to_non_nullable
              as Map<String, ParticipantMediaState>,
    ));
  }

  /// Create a copy of CallState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ParticipantMediaStateCopyWith<$Res>? get mParticipant {
    if (_self.mParticipant == null) {
      return null;
    }

    return $ParticipantMediaStateCopyWith<$Res>(_self.mParticipant!, (value) {
      return _then(_self.copyWith(mParticipant: value));
    });
  }
}

/// @nodoc

class _CallState with DiagnosticableTreeMixin implements CallState {
  const _CallState(
      {this.mParticipant,
      required final Map<String, ParticipantMediaState> participants})
      : _participants = participants;

  @override
  final ParticipantMediaState? mParticipant;
  final Map<String, ParticipantMediaState> _participants;
  @override
  Map<String, ParticipantMediaState> get participants {
    if (_participants is EqualUnmodifiableMapView) return _participants;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_participants);
  }

  /// Create a copy of CallState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$CallStateCopyWith<_CallState> get copyWith =>
      __$CallStateCopyWithImpl<_CallState>(this, _$identity);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
      ..add(DiagnosticsProperty('type', 'CallState'))
      ..add(DiagnosticsProperty('mParticipant', mParticipant))
      ..add(DiagnosticsProperty('participants', participants));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _CallState &&
            (identical(other.mParticipant, mParticipant) ||
                other.mParticipant == mParticipant) &&
            const DeepCollectionEquality()
                .equals(other._participants, _participants));
  }

  @override
  int get hashCode => Object.hash(runtimeType, mParticipant,
      const DeepCollectionEquality().hash(_participants));

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'CallState(mParticipant: $mParticipant, participants: $participants)';
  }
}

/// @nodoc
abstract mixin class _$CallStateCopyWith<$Res>
    implements $CallStateCopyWith<$Res> {
  factory _$CallStateCopyWith(
          _CallState value, $Res Function(_CallState) _then) =
      __$CallStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {ParticipantMediaState? mParticipant,
      Map<String, ParticipantMediaState> participants});

  @override
  $ParticipantMediaStateCopyWith<$Res>? get mParticipant;
}

/// @nodoc
class __$CallStateCopyWithImpl<$Res> implements _$CallStateCopyWith<$Res> {
  __$CallStateCopyWithImpl(this._self, this._then);

  final _CallState _self;
  final $Res Function(_CallState) _then;

  /// Create a copy of CallState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? mParticipant = freezed,
    Object? participants = null,
  }) {
    return _then(_CallState(
      mParticipant: freezed == mParticipant
          ? _self.mParticipant
          : mParticipant // ignore: cast_nullable_to_non_nullable
              as ParticipantMediaState?,
      participants: null == participants
          ? _self._participants
          : participants // ignore: cast_nullable_to_non_nullable
              as Map<String, ParticipantMediaState>,
    ));
  }

  /// Create a copy of CallState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ParticipantMediaStateCopyWith<$Res>? get mParticipant {
    if (_self.mParticipant == null) {
      return null;
    }

    return $ParticipantMediaStateCopyWith<$Res>(_self.mParticipant!, (value) {
      return _then(_self.copyWith(mParticipant: value));
    });
  }
}

// dart format on
