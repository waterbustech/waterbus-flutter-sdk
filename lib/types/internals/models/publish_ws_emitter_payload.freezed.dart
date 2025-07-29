// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'publish_ws_emitter_payload.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PublishWsEmitterPayLoad {
  String get sdp;
  String get roomId;
  String get participantId;
  bool get isVideoEnabled;
  bool get isAudioEnabled;
  bool get isE2eeEnabled;
  int get totalTracks;
  ConnectionType get connectionType;
  StreamingProtocol get streamingProtocol;
  bool get isIpv6Supported;

  /// Create a copy of PublishWsEmitterPayLoad
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PublishWsEmitterPayLoadCopyWith<PublishWsEmitterPayLoad> get copyWith =>
      _$PublishWsEmitterPayLoadCopyWithImpl<PublishWsEmitterPayLoad>(
          this as PublishWsEmitterPayLoad, _$identity);

  /// Serializes this PublishWsEmitterPayLoad to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PublishWsEmitterPayLoad &&
            (identical(other.sdp, sdp) || other.sdp == sdp) &&
            (identical(other.roomId, roomId) || other.roomId == roomId) &&
            (identical(other.participantId, participantId) ||
                other.participantId == participantId) &&
            (identical(other.isVideoEnabled, isVideoEnabled) ||
                other.isVideoEnabled == isVideoEnabled) &&
            (identical(other.isAudioEnabled, isAudioEnabled) ||
                other.isAudioEnabled == isAudioEnabled) &&
            (identical(other.isE2eeEnabled, isE2eeEnabled) ||
                other.isE2eeEnabled == isE2eeEnabled) &&
            (identical(other.totalTracks, totalTracks) ||
                other.totalTracks == totalTracks) &&
            (identical(other.connectionType, connectionType) ||
                other.connectionType == connectionType) &&
            (identical(other.streamingProtocol, streamingProtocol) ||
                other.streamingProtocol == streamingProtocol) &&
            (identical(other.isIpv6Supported, isIpv6Supported) ||
                other.isIpv6Supported == isIpv6Supported));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      sdp,
      roomId,
      participantId,
      isVideoEnabled,
      isAudioEnabled,
      isE2eeEnabled,
      totalTracks,
      connectionType,
      streamingProtocol,
      isIpv6Supported);

  @override
  String toString() {
    return 'PublishWsEmitterPayLoad(sdp: $sdp, roomId: $roomId, participantId: $participantId, isVideoEnabled: $isVideoEnabled, isAudioEnabled: $isAudioEnabled, isE2eeEnabled: $isE2eeEnabled, totalTracks: $totalTracks, connectionType: $connectionType, streamingProtocol: $streamingProtocol, isIpv6Supported: $isIpv6Supported)';
  }
}

/// @nodoc
abstract mixin class $PublishWsEmitterPayLoadCopyWith<$Res> {
  factory $PublishWsEmitterPayLoadCopyWith(PublishWsEmitterPayLoad value,
          $Res Function(PublishWsEmitterPayLoad) _then) =
      _$PublishWsEmitterPayLoadCopyWithImpl;
  @useResult
  $Res call(
      {String sdp,
      String roomId,
      String participantId,
      bool isVideoEnabled,
      bool isAudioEnabled,
      bool isE2eeEnabled,
      int totalTracks,
      ConnectionType connectionType,
      StreamingProtocol streamingProtocol,
      bool isIpv6Supported});
}

/// @nodoc
class _$PublishWsEmitterPayLoadCopyWithImpl<$Res>
    implements $PublishWsEmitterPayLoadCopyWith<$Res> {
  _$PublishWsEmitterPayLoadCopyWithImpl(this._self, this._then);

  final PublishWsEmitterPayLoad _self;
  final $Res Function(PublishWsEmitterPayLoad) _then;

  /// Create a copy of PublishWsEmitterPayLoad
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sdp = null,
    Object? roomId = null,
    Object? participantId = null,
    Object? isVideoEnabled = null,
    Object? isAudioEnabled = null,
    Object? isE2eeEnabled = null,
    Object? totalTracks = null,
    Object? connectionType = null,
    Object? streamingProtocol = null,
    Object? isIpv6Supported = null,
  }) {
    return _then(_self.copyWith(
      sdp: null == sdp
          ? _self.sdp
          : sdp // ignore: cast_nullable_to_non_nullable
              as String,
      roomId: null == roomId
          ? _self.roomId
          : roomId // ignore: cast_nullable_to_non_nullable
              as String,
      participantId: null == participantId
          ? _self.participantId
          : participantId // ignore: cast_nullable_to_non_nullable
              as String,
      isVideoEnabled: null == isVideoEnabled
          ? _self.isVideoEnabled
          : isVideoEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      isAudioEnabled: null == isAudioEnabled
          ? _self.isAudioEnabled
          : isAudioEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      isE2eeEnabled: null == isE2eeEnabled
          ? _self.isE2eeEnabled
          : isE2eeEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      totalTracks: null == totalTracks
          ? _self.totalTracks
          : totalTracks // ignore: cast_nullable_to_non_nullable
              as int,
      connectionType: null == connectionType
          ? _self.connectionType
          : connectionType // ignore: cast_nullable_to_non_nullable
              as ConnectionType,
      streamingProtocol: null == streamingProtocol
          ? _self.streamingProtocol
          : streamingProtocol // ignore: cast_nullable_to_non_nullable
              as StreamingProtocol,
      isIpv6Supported: null == isIpv6Supported
          ? _self.isIpv6Supported
          : isIpv6Supported // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _PublishWsEmitterPayLoad implements PublishWsEmitterPayLoad {
  const _PublishWsEmitterPayLoad(
      {required this.sdp,
      required this.roomId,
      required this.participantId,
      required this.isVideoEnabled,
      required this.isAudioEnabled,
      required this.isE2eeEnabled,
      required this.totalTracks,
      required this.connectionType,
      required this.streamingProtocol,
      this.isIpv6Supported = false});
  factory _PublishWsEmitterPayLoad.fromJson(Map<String, dynamic> json) =>
      _$PublishWsEmitterPayLoadFromJson(json);

  @override
  final String sdp;
  @override
  final String roomId;
  @override
  final String participantId;
  @override
  final bool isVideoEnabled;
  @override
  final bool isAudioEnabled;
  @override
  final bool isE2eeEnabled;
  @override
  final int totalTracks;
  @override
  final ConnectionType connectionType;
  @override
  final StreamingProtocol streamingProtocol;
  @override
  @JsonKey()
  final bool isIpv6Supported;

  /// Create a copy of PublishWsEmitterPayLoad
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$PublishWsEmitterPayLoadCopyWith<_PublishWsEmitterPayLoad> get copyWith =>
      __$PublishWsEmitterPayLoadCopyWithImpl<_PublishWsEmitterPayLoad>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$PublishWsEmitterPayLoadToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _PublishWsEmitterPayLoad &&
            (identical(other.sdp, sdp) || other.sdp == sdp) &&
            (identical(other.roomId, roomId) || other.roomId == roomId) &&
            (identical(other.participantId, participantId) ||
                other.participantId == participantId) &&
            (identical(other.isVideoEnabled, isVideoEnabled) ||
                other.isVideoEnabled == isVideoEnabled) &&
            (identical(other.isAudioEnabled, isAudioEnabled) ||
                other.isAudioEnabled == isAudioEnabled) &&
            (identical(other.isE2eeEnabled, isE2eeEnabled) ||
                other.isE2eeEnabled == isE2eeEnabled) &&
            (identical(other.totalTracks, totalTracks) ||
                other.totalTracks == totalTracks) &&
            (identical(other.connectionType, connectionType) ||
                other.connectionType == connectionType) &&
            (identical(other.streamingProtocol, streamingProtocol) ||
                other.streamingProtocol == streamingProtocol) &&
            (identical(other.isIpv6Supported, isIpv6Supported) ||
                other.isIpv6Supported == isIpv6Supported));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      sdp,
      roomId,
      participantId,
      isVideoEnabled,
      isAudioEnabled,
      isE2eeEnabled,
      totalTracks,
      connectionType,
      streamingProtocol,
      isIpv6Supported);

  @override
  String toString() {
    return 'PublishWsEmitterPayLoad(sdp: $sdp, roomId: $roomId, participantId: $participantId, isVideoEnabled: $isVideoEnabled, isAudioEnabled: $isAudioEnabled, isE2eeEnabled: $isE2eeEnabled, totalTracks: $totalTracks, connectionType: $connectionType, streamingProtocol: $streamingProtocol, isIpv6Supported: $isIpv6Supported)';
  }
}

/// @nodoc
abstract mixin class _$PublishWsEmitterPayLoadCopyWith<$Res>
    implements $PublishWsEmitterPayLoadCopyWith<$Res> {
  factory _$PublishWsEmitterPayLoadCopyWith(_PublishWsEmitterPayLoad value,
          $Res Function(_PublishWsEmitterPayLoad) _then) =
      __$PublishWsEmitterPayLoadCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String sdp,
      String roomId,
      String participantId,
      bool isVideoEnabled,
      bool isAudioEnabled,
      bool isE2eeEnabled,
      int totalTracks,
      ConnectionType connectionType,
      StreamingProtocol streamingProtocol,
      bool isIpv6Supported});
}

/// @nodoc
class __$PublishWsEmitterPayLoadCopyWithImpl<$Res>
    implements _$PublishWsEmitterPayLoadCopyWith<$Res> {
  __$PublishWsEmitterPayLoadCopyWithImpl(this._self, this._then);

  final _PublishWsEmitterPayLoad _self;
  final $Res Function(_PublishWsEmitterPayLoad) _then;

  /// Create a copy of PublishWsEmitterPayLoad
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? sdp = null,
    Object? roomId = null,
    Object? participantId = null,
    Object? isVideoEnabled = null,
    Object? isAudioEnabled = null,
    Object? isE2eeEnabled = null,
    Object? totalTracks = null,
    Object? connectionType = null,
    Object? streamingProtocol = null,
    Object? isIpv6Supported = null,
  }) {
    return _then(_PublishWsEmitterPayLoad(
      sdp: null == sdp
          ? _self.sdp
          : sdp // ignore: cast_nullable_to_non_nullable
              as String,
      roomId: null == roomId
          ? _self.roomId
          : roomId // ignore: cast_nullable_to_non_nullable
              as String,
      participantId: null == participantId
          ? _self.participantId
          : participantId // ignore: cast_nullable_to_non_nullable
              as String,
      isVideoEnabled: null == isVideoEnabled
          ? _self.isVideoEnabled
          : isVideoEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      isAudioEnabled: null == isAudioEnabled
          ? _self.isAudioEnabled
          : isAudioEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      isE2eeEnabled: null == isE2eeEnabled
          ? _self.isE2eeEnabled
          : isE2eeEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      totalTracks: null == totalTracks
          ? _self.totalTracks
          : totalTracks // ignore: cast_nullable_to_non_nullable
              as int,
      connectionType: null == connectionType
          ? _self.connectionType
          : connectionType // ignore: cast_nullable_to_non_nullable
              as ConnectionType,
      streamingProtocol: null == streamingProtocol
          ? _self.streamingProtocol
          : streamingProtocol // ignore: cast_nullable_to_non_nullable
              as StreamingProtocol,
      isIpv6Supported: null == isIpv6Supported
          ? _self.isIpv6Supported
          : isIpv6Supported // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

// dart format on
