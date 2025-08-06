// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
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
