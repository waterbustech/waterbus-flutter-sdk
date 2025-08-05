// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'callback_payload.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CallbackPayload {
  CallbackEvents get event;
  RoomState get callState;
  String? get participantId;
  ParticipantInfo? get newParticipant;

  /// Create a copy of CallbackPayload
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CallbackPayloadCopyWith<CallbackPayload> get copyWith =>
      _$CallbackPayloadCopyWithImpl<CallbackPayload>(
          this as CallbackPayload, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CallbackPayload &&
            (identical(other.event, event) || other.event == event) &&
            (identical(other.callState, callState) ||
                other.callState == callState) &&
            (identical(other.participantId, participantId) ||
                other.participantId == participantId) &&
            (identical(other.newParticipant, newParticipant) ||
                other.newParticipant == newParticipant));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, event, callState, participantId, newParticipant);

  @override
  String toString() {
    return 'CallbackPayload(event: $event, callState: $callState, participantId: $participantId, newParticipant: $newParticipant)';
  }
}

/// @nodoc
abstract mixin class $CallbackPayloadCopyWith<$Res> {
  factory $CallbackPayloadCopyWith(
          CallbackPayload value, $Res Function(CallbackPayload) _then) =
      _$CallbackPayloadCopyWithImpl;
  @useResult
  $Res call(
      {CallbackEvents event,
      RoomState callState,
      String? participantId,
      ParticipantInfo? newParticipant});

  $RoomStateCopyWith<$Res> get callState;
  $ParticipantInfoCopyWith<$Res>? get newParticipant;
}

/// @nodoc
class _$CallbackPayloadCopyWithImpl<$Res>
    implements $CallbackPayloadCopyWith<$Res> {
  _$CallbackPayloadCopyWithImpl(this._self, this._then);

  final CallbackPayload _self;
  final $Res Function(CallbackPayload) _then;

  /// Create a copy of CallbackPayload
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? event = null,
    Object? callState = null,
    Object? participantId = freezed,
    Object? newParticipant = freezed,
  }) {
    return _then(_self.copyWith(
      event: null == event
          ? _self.event
          : event // ignore: cast_nullable_to_non_nullable
              as CallbackEvents,
      callState: null == callState
          ? _self.callState
          : callState // ignore: cast_nullable_to_non_nullable
              as RoomState,
      participantId: freezed == participantId
          ? _self.participantId
          : participantId // ignore: cast_nullable_to_non_nullable
              as String?,
      newParticipant: freezed == newParticipant
          ? _self.newParticipant
          : newParticipant // ignore: cast_nullable_to_non_nullable
              as ParticipantInfo?,
    ));
  }

  /// Create a copy of CallbackPayload
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $RoomStateCopyWith<$Res> get callState {
    return $RoomStateCopyWith<$Res>(_self.callState, (value) {
      return _then(_self.copyWith(callState: value));
    });
  }

  /// Create a copy of CallbackPayload
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ParticipantInfoCopyWith<$Res>? get newParticipant {
    if (_self.newParticipant == null) {
      return null;
    }

    return $ParticipantInfoCopyWith<$Res>(_self.newParticipant!, (value) {
      return _then(_self.copyWith(newParticipant: value));
    });
  }
}

/// @nodoc

class _CallbackPayload implements CallbackPayload {
  const _CallbackPayload(
      {required this.event,
      required this.callState,
      this.participantId,
      this.newParticipant});

  @override
  final CallbackEvents event;
  @override
  final RoomState callState;
  @override
  final String? participantId;
  @override
  final ParticipantInfo? newParticipant;

  /// Create a copy of CallbackPayload
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$CallbackPayloadCopyWith<_CallbackPayload> get copyWith =>
      __$CallbackPayloadCopyWithImpl<_CallbackPayload>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _CallbackPayload &&
            (identical(other.event, event) || other.event == event) &&
            (identical(other.callState, callState) ||
                other.callState == callState) &&
            (identical(other.participantId, participantId) ||
                other.participantId == participantId) &&
            (identical(other.newParticipant, newParticipant) ||
                other.newParticipant == newParticipant));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, event, callState, participantId, newParticipant);

  @override
  String toString() {
    return 'CallbackPayload(event: $event, callState: $callState, participantId: $participantId, newParticipant: $newParticipant)';
  }
}

/// @nodoc
abstract mixin class _$CallbackPayloadCopyWith<$Res>
    implements $CallbackPayloadCopyWith<$Res> {
  factory _$CallbackPayloadCopyWith(
          _CallbackPayload value, $Res Function(_CallbackPayload) _then) =
      __$CallbackPayloadCopyWithImpl;
  @override
  @useResult
  $Res call(
      {CallbackEvents event,
      RoomState callState,
      String? participantId,
      ParticipantInfo? newParticipant});

  @override
  $RoomStateCopyWith<$Res> get callState;
  @override
  $ParticipantInfoCopyWith<$Res>? get newParticipant;
}

/// @nodoc
class __$CallbackPayloadCopyWithImpl<$Res>
    implements _$CallbackPayloadCopyWith<$Res> {
  __$CallbackPayloadCopyWithImpl(this._self, this._then);

  final _CallbackPayload _self;
  final $Res Function(_CallbackPayload) _then;

  /// Create a copy of CallbackPayload
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? event = null,
    Object? callState = null,
    Object? participantId = freezed,
    Object? newParticipant = freezed,
  }) {
    return _then(_CallbackPayload(
      event: null == event
          ? _self.event
          : event // ignore: cast_nullable_to_non_nullable
              as CallbackEvents,
      callState: null == callState
          ? _self.callState
          : callState // ignore: cast_nullable_to_non_nullable
              as RoomState,
      participantId: freezed == participantId
          ? _self.participantId
          : participantId // ignore: cast_nullable_to_non_nullable
              as String?,
      newParticipant: freezed == newParticipant
          ? _self.newParticipant
          : newParticipant // ignore: cast_nullable_to_non_nullable
              as ParticipantInfo?,
    ));
  }

  /// Create a copy of CallbackPayload
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $RoomStateCopyWith<$Res> get callState {
    return $RoomStateCopyWith<$Res>(_self.callState, (value) {
      return _then(_self.copyWith(callState: value));
    });
  }

  /// Create a copy of CallbackPayload
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ParticipantInfoCopyWith<$Res>? get newParticipant {
    if (_self.newParticipant == null) {
      return null;
    }

    return $ParticipantInfoCopyWith<$Res>(_self.newParticipant!, (value) {
      return _then(_self.copyWith(newParticipant: value));
    });
  }
}

// dart format on
