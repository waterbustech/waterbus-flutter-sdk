// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ice_server.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$IceServer {
  List<String> get urls;
  String? get username;
  String? get credential;

  /// Create a copy of IceServer
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $IceServerCopyWith<IceServer> get copyWith =>
      _$IceServerCopyWithImpl<IceServer>(this as IceServer, _$identity);

  /// Serializes this IceServer to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is IceServer &&
            const DeepCollectionEquality().equals(other.urls, urls) &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.credential, credential) ||
                other.credential == credential));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(urls), username, credential);

  @override
  String toString() {
    return 'IceServer(urls: $urls, username: $username, credential: $credential)';
  }
}

/// @nodoc
abstract mixin class $IceServerCopyWith<$Res> {
  factory $IceServerCopyWith(IceServer value, $Res Function(IceServer) _then) =
      _$IceServerCopyWithImpl;
  @useResult
  $Res call({List<String> urls, String? username, String? credential});
}

/// @nodoc
class _$IceServerCopyWithImpl<$Res> implements $IceServerCopyWith<$Res> {
  _$IceServerCopyWithImpl(this._self, this._then);

  final IceServer _self;
  final $Res Function(IceServer) _then;

  /// Create a copy of IceServer
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? urls = null,
    Object? username = freezed,
    Object? credential = freezed,
  }) {
    return _then(_self.copyWith(
      urls: null == urls
          ? _self.urls
          : urls // ignore: cast_nullable_to_non_nullable
              as List<String>,
      username: freezed == username
          ? _self.username
          : username // ignore: cast_nullable_to_non_nullable
              as String?,
      credential: freezed == credential
          ? _self.credential
          : credential // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [IceServer].
extension IceServerPatterns on IceServer {
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
    TResult Function(_IceServer value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _IceServer() when $default != null:
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
    TResult Function(_IceServer value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _IceServer():
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
    TResult? Function(_IceServer value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _IceServer() when $default != null:
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
    TResult Function(List<String> urls, String? username, String? credential)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _IceServer() when $default != null:
        return $default(_that.urls, _that.username, _that.credential);
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
    TResult Function(List<String> urls, String? username, String? credential)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _IceServer():
        return $default(_that.urls, _that.username, _that.credential);
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
    TResult? Function(List<String> urls, String? username, String? credential)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _IceServer() when $default != null:
        return $default(_that.urls, _that.username, _that.credential);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _IceServer implements IceServer {
  const _IceServer(
      {required final List<String> urls, this.username, this.credential})
      : _urls = urls;
  factory _IceServer.fromJson(Map<String, dynamic> json) =>
      _$IceServerFromJson(json);

  final List<String> _urls;
  @override
  List<String> get urls {
    if (_urls is EqualUnmodifiableListView) return _urls;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_urls);
  }

  @override
  final String? username;
  @override
  final String? credential;

  /// Create a copy of IceServer
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$IceServerCopyWith<_IceServer> get copyWith =>
      __$IceServerCopyWithImpl<_IceServer>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$IceServerToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _IceServer &&
            const DeepCollectionEquality().equals(other._urls, _urls) &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.credential, credential) ||
                other.credential == credential));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(_urls), username, credential);

  @override
  String toString() {
    return 'IceServer(urls: $urls, username: $username, credential: $credential)';
  }
}

/// @nodoc
abstract mixin class _$IceServerCopyWith<$Res>
    implements $IceServerCopyWith<$Res> {
  factory _$IceServerCopyWith(
          _IceServer value, $Res Function(_IceServer) _then) =
      __$IceServerCopyWithImpl;
  @override
  @useResult
  $Res call({List<String> urls, String? username, String? credential});
}

/// @nodoc
class __$IceServerCopyWithImpl<$Res> implements _$IceServerCopyWith<$Res> {
  __$IceServerCopyWithImpl(this._self, this._then);

  final _IceServer _self;
  final $Res Function(_IceServer) _then;

  /// Create a copy of IceServer
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? urls = null,
    Object? username = freezed,
    Object? credential = freezed,
  }) {
    return _then(_IceServer(
      urls: null == urls
          ? _self._urls
          : urls // ignore: cast_nullable_to_non_nullable
              as List<String>,
      username: freezed == username
          ? _self.username
          : username // ignore: cast_nullable_to_non_nullable
              as String?,
      credential: freezed == credential
          ? _self.credential
          : credential // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
