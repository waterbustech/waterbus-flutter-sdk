import 'dart:async';

import 'package:flutter/foundation.dart';

import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';
import 'package:waterbus_sdk/types/externals/rtc/channel_event.dart';
import 'package:waterbus_sdk/utils/logger/logger.dart';

class MediaSource {
  MediaStream? stream;
  VideoRenderer? renderer;
  RTCRtpSender? sender;
  String? mid;
  bool hasFirstFrameRendered;
  final Function()? onFirstFrameRendered;
  RTCDataChannel? dataChannel;

  MediaSource({
    this.stream,
    this.renderer,
    this.mid,
    this.hasFirstFrameRendered = false,
    this.onFirstFrameRendered,
    this.dataChannel,
  }) {
    _initRendererIfNeeded();
  }

  Future<void> dispose() async {
    await stream?.dispose();
    renderer = null;
    stream = null;
  }

  int? get textureId => renderer?.textureId;

  String? get streamId => stream?.id;

  void setSender(RTCRtpSender sender) {
    this.sender ??= sender;
  }

  void setSrcObject(MediaStream stream) {
    this.stream = stream;

    renderer?.initialize().then((_) {
      renderer?.srcObject = stream;
    });
  }

  void setRenderer(RTCVideoPlatformViewController controller) {
    renderer = controller;
    renderer?.srcObject = stream;
  }

  Future<void> _initRendererIfNeeded() async {
    if (WebRTC.platformIsIOS || renderer != null) {
      hasFirstFrameRendered = true;
      onFirstFrameRendered?.call();
      return;
    }

    renderer = RTCVideoRenderer();
    // await renderer?.initialize();

    if (kIsWeb) {
      hasFirstFrameRendered = true;
      onFirstFrameRendered?.call();
    }

    renderer?.onFirstFrameRendered = () {
      hasFirstFrameRendered = true;
      onFirstFrameRendered?.call();
    };
  }

  MediaSource copyWith({
    MediaStream? stream,
    VideoRenderer? renderer,
    bool? hasFirstFrameRendered,
    Function()? onFirstFrameRendered,
  }) {
    return MediaSource(
      stream: stream ?? this.stream,
      renderer: renderer ?? this.renderer,
      hasFirstFrameRendered:
          hasFirstFrameRendered ?? this.hasFirstFrameRendered,
      onFirstFrameRendered: onFirstFrameRendered ?? this.onFirstFrameRendered,
    );
  }

  @override
  String toString() {
    return 'MediaSource(stream: $stream, renderer: $renderer, hasFirstFrameRendered: $hasFirstFrameRendered, onFirstFrameRendered: $onFirstFrameRendered)';
  }

  @override
  bool operator ==(covariant MediaSource other) {
    if (identical(this, other)) return true;

    return other.stream == stream &&
        other.renderer == renderer &&
        other.hasFirstFrameRendered == hasFirstFrameRendered &&
        other.onFirstFrameRendered == onFirstFrameRendered;
  }

  @override
  int get hashCode {
    return stream.hashCode ^
        renderer.hashCode ^
        hasFirstFrameRendered.hashCode ^
        onFirstFrameRendered.hashCode;
  }
}

extension MediaSourceQuality on MediaSource {
  /// For Publisher
  Future<void> setRidActive(String rid, bool active) async {
    if (sender == null) return;

    final parameters = sender!.parameters;

    for (final RTCRtpEncoding encoding in parameters.encodings ?? []) {
      if (encoding.rid == rid) {
        encoding.active = active;
      }
    }

    await sender?.setParameters(parameters);
  }

  /// For Subscriber
  Future<void> setPreferredQuality(TrackQuality quality) async {
    if (mid == null) return;

    final channel = dataChannel;

    if (channel == null ||
        channel.state != RTCDataChannelState.RTCDataChannelOpen) {
      return;
    }

    try {
      final event = SubscriberTrackQuality(
        mid: mid!,
        quality: quality,
      );

      await channel.send(RTCDataChannelMessage.fromBinary(event.toBinary()));
    } catch (e, st) {
      WaterbusLogger.instance.bug('Failed to send preferred quality: $e\n$st');
    }
  }
}
