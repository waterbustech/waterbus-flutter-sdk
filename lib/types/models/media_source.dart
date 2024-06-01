import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';

class MediaSource {
  MediaStream? stream;
  RTCVideoRenderer? renderer;
  RTCVideoPlatformViewController? viewController;
  bool hasFirstFrameRendered;
  final Function()? onFirstFrameRendered;
  MediaSource({
    this.stream,
    this.renderer,
    this.viewController,
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
      return RTCVideoPlatFormView(
        objectFit: objectFit,
        mirror: mirror,
        onViewReady: (controller) {
          viewController = controller;
          viewController?.srcObject = stream;
        },
      );
    }

    if (renderer == null) {
      return const SizedBox();
    }

    return RTCVideoView(
      renderer!,
      key: textureId == null ? null : Key(textureId!.toString()),
      objectFit: objectFit,
      mirror: mirror,
      filterQuality: FilterQuality.none,
    );
  }

  void setPlatformView(RTCVideoPlatformViewController controller) {
    viewController = controller;
    viewController?.srcObject = stream;
  }

  Future<void> dispose() async {
    await renderer?.dispose();
    await viewController?.dispose();
    renderer = null;
    viewController = null;
  }

  int? get textureId => renderer?.textureId;

  String? get streamId => stream?.id;

  void setSrcObject(MediaStream? stream) {
    if (stream == null) return;

    this.stream = stream;

    if (WebRTC.platformIsIOS) {
      viewController?.srcObject = stream;
    } else {
      renderer?.srcObject = stream;
    }
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
    RTCVideoRenderer? renderer,
    RTCVideoPlatformViewController? viewController,
    bool? hasFirstFrameRendered,
    Function()? onFirstFrameRendered,
  }) {
    return MediaSource(
      stream: stream ?? this.stream,
      renderer: renderer ?? this.renderer,
      viewController: viewController ?? this.viewController,
      hasFirstFrameRendered:
          hasFirstFrameRendered ?? this.hasFirstFrameRendered,
      onFirstFrameRendered: onFirstFrameRendered ?? this.onFirstFrameRendered,
    );
  }

  @override
  String toString() {
    return 'MediaSource(stream: $stream, renderer: $renderer, viewController: $viewController, hasFirstFrameRendered: $hasFirstFrameRendered, onFirstFrameRendered: $onFirstFrameRendered)';
  }

  @override
  bool operator ==(covariant MediaSource other) {
    if (identical(this, other)) return true;

    return other.stream == stream &&
        other.renderer == renderer &&
        other.viewController == viewController &&
        other.hasFirstFrameRendered == hasFirstFrameRendered &&
        other.onFirstFrameRendered == onFirstFrameRendered;
  }

  @override
  int get hashCode {
    return stream.hashCode ^
        renderer.hashCode ^
        viewController.hashCode ^
        hasFirstFrameRendered.hashCode ^
        onFirstFrameRendered.hashCode;
  }
}
