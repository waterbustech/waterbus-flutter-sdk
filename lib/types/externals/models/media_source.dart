import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';

class MediaSource {
  MediaStream? stream;
  VideoRenderer? renderer;
  RTCRtpSender? sender;
  bool hasFirstFrameRendered;
  final Function()? onFirstFrameRendered;
  MediaSource({
    this.stream,
    this.renderer,
    this.hasFirstFrameRendered = false,
    this.onFirstFrameRendered,
  }) {
    _initRendererIfNeeded();
  }

  Widget mediaView({
    RTCVideoViewObjectFit objectFit =
        RTCVideoViewObjectFit.RTCVideoViewObjectFitContain,
    bool mirror = false,
  }) {
    if (WebRTC.platformIsIOS) {
      return LayoutBuilder(
        builder: (context, constraints) {
          return RTCVideoPlatFormView(
            objectFit: objectFit,
            mirror: mirror,
            onViewReady: (controller) {
              renderer = controller;
              renderer?.srcObject = stream;
            },
          );
        },
      );
    }

    if (renderer == null) {
      return const SizedBox();
    }

    return RTCVideoView(
      renderer as RTCVideoRenderer,
      key: textureId == null ? null : Key(textureId!.toString()),
      objectFit: objectFit,
      mirror: mirror,
      filterQuality: FilterQuality.none,
    );
  }

  Future<void> dispose() async {
    renderer?.srcObject = null;
    await renderer?.dispose();
    await stream?.dispose();
    renderer = null;
    stream = null;
  }

  int? get textureId => renderer?.textureId;

  String? get streamId => stream?.id;

  void setSender(RTCRtpSender sender) {
    this.sender ??= sender;
  }

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

  void setSrcObject(MediaStream? stream) {
    if (stream == null) return;

    this.stream = stream;

    renderer?.srcObject = stream;
  }

  Future<void> _initRendererIfNeeded() async {
    if (WebRTC.platformIsIOS || renderer != null) {
      hasFirstFrameRendered = true;
      onFirstFrameRendered?.call();
      return;
    }

    renderer = RTCVideoRenderer();
    await renderer?.initialize();

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
