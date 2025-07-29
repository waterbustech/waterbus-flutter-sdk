// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'track_subscribed_message.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TrackSubscribedMessage {
  String get trackId;
  int get subscribedCount;
  TrackQuality get quality;
  int get timestamp;

  /// Create a copy of TrackSubscribedMessage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TrackSubscribedMessageCopyWith<TrackSubscribedMessage> get copyWith =>
      _$TrackSubscribedMessageCopyWithImpl<TrackSubscribedMessage>(
          this as TrackSubscribedMessage, _$identity);

  /// Serializes this TrackSubscribedMessage to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TrackSubscribedMessage &&
            (identical(other.trackId, trackId) || other.trackId == trackId) &&
            (identical(other.subscribedCount, subscribedCount) ||
                other.subscribedCount == subscribedCount) &&
            (identical(other.quality, quality) || other.quality == quality) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, trackId, subscribedCount, quality, timestamp);

  @override
  String toString() {
    return 'TrackSubscribedMessage(trackId: $trackId, subscribedCount: $subscribedCount, quality: $quality, timestamp: $timestamp)';
  }
}

/// @nodoc
abstract mixin class $TrackSubscribedMessageCopyWith<$Res> {
  factory $TrackSubscribedMessageCopyWith(TrackSubscribedMessage value,
          $Res Function(TrackSubscribedMessage) _then) =
      _$TrackSubscribedMessageCopyWithImpl;
  @useResult
  $Res call(
      {String trackId,
      int subscribedCount,
      TrackQuality quality,
      int timestamp});
}

/// @nodoc
class _$TrackSubscribedMessageCopyWithImpl<$Res>
    implements $TrackSubscribedMessageCopyWith<$Res> {
  _$TrackSubscribedMessageCopyWithImpl(this._self, this._then);

  final TrackSubscribedMessage _self;
  final $Res Function(TrackSubscribedMessage) _then;

  /// Create a copy of TrackSubscribedMessage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? trackId = null,
    Object? subscribedCount = null,
    Object? quality = null,
    Object? timestamp = null,
  }) {
    return _then(_self.copyWith(
      trackId: null == trackId
          ? _self.trackId
          : trackId // ignore: cast_nullable_to_non_nullable
              as String,
      subscribedCount: null == subscribedCount
          ? _self.subscribedCount
          : subscribedCount // ignore: cast_nullable_to_non_nullable
              as int,
      quality: null == quality
          ? _self.quality
          : quality // ignore: cast_nullable_to_non_nullable
              as TrackQuality,
      timestamp: null == timestamp
          ? _self.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// Adds pattern-matching-related methods to [TrackSubscribedMessage].
extension TrackSubscribedMessagePatterns on TrackSubscribedMessage {
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
    TResult Function(_TrackSubscribedMessage value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _TrackSubscribedMessage() when $default != null:
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
    TResult Function(_TrackSubscribedMessage value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TrackSubscribedMessage():
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
    TResult? Function(_TrackSubscribedMessage value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TrackSubscribedMessage() when $default != null:
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
    TResult Function(String trackId, int subscribedCount, TrackQuality quality,
            int timestamp)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _TrackSubscribedMessage() when $default != null:
        return $default(_that.trackId, _that.subscribedCount, _that.quality,
            _that.timestamp);
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
    TResult Function(String trackId, int subscribedCount, TrackQuality quality,
            int timestamp)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TrackSubscribedMessage():
        return $default(_that.trackId, _that.subscribedCount, _that.quality,
            _that.timestamp);
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
    TResult? Function(String trackId, int subscribedCount, TrackQuality quality,
            int timestamp)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TrackSubscribedMessage() when $default != null:
        return $default(_that.trackId, _that.subscribedCount, _that.quality,
            _that.timestamp);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _TrackSubscribedMessage implements TrackSubscribedMessage {
  const _TrackSubscribedMessage(
      {required this.trackId,
      required this.subscribedCount,
      required this.quality,
      required this.timestamp});
  factory _TrackSubscribedMessage.fromJson(Map<String, dynamic> json) =>
      _$TrackSubscribedMessageFromJson(json);

  @override
  final String trackId;
  @override
  final int subscribedCount;
  @override
  final TrackQuality quality;
  @override
  final int timestamp;

  /// Create a copy of TrackSubscribedMessage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$TrackSubscribedMessageCopyWith<_TrackSubscribedMessage> get copyWith =>
      __$TrackSubscribedMessageCopyWithImpl<_TrackSubscribedMessage>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$TrackSubscribedMessageToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _TrackSubscribedMessage &&
            (identical(other.trackId, trackId) || other.trackId == trackId) &&
            (identical(other.subscribedCount, subscribedCount) ||
                other.subscribedCount == subscribedCount) &&
            (identical(other.quality, quality) || other.quality == quality) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, trackId, subscribedCount, quality, timestamp);

  @override
  String toString() {
    return 'TrackSubscribedMessage(trackId: $trackId, subscribedCount: $subscribedCount, quality: $quality, timestamp: $timestamp)';
  }
}

/// @nodoc
abstract mixin class _$TrackSubscribedMessageCopyWith<$Res>
    implements $TrackSubscribedMessageCopyWith<$Res> {
  factory _$TrackSubscribedMessageCopyWith(_TrackSubscribedMessage value,
          $Res Function(_TrackSubscribedMessage) _then) =
      __$TrackSubscribedMessageCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String trackId,
      int subscribedCount,
      TrackQuality quality,
      int timestamp});
}

/// @nodoc
class __$TrackSubscribedMessageCopyWithImpl<$Res>
    implements _$TrackSubscribedMessageCopyWith<$Res> {
  __$TrackSubscribedMessageCopyWithImpl(this._self, this._then);

  final _TrackSubscribedMessage _self;
  final $Res Function(_TrackSubscribedMessage) _then;

  /// Create a copy of TrackSubscribedMessage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? trackId = null,
    Object? subscribedCount = null,
    Object? quality = null,
    Object? timestamp = null,
  }) {
    return _then(_TrackSubscribedMessage(
      trackId: null == trackId
          ? _self.trackId
          : trackId // ignore: cast_nullable_to_non_nullable
              as String,
      subscribedCount: null == subscribedCount
          ? _self.subscribedCount
          : subscribedCount // ignore: cast_nullable_to_non_nullable
              as int,
      quality: null == quality
          ? _self.quality
          : quality // ignore: cast_nullable_to_non_nullable
              as TrackQuality,
      timestamp: null == timestamp
          ? _self.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

// dart format on
