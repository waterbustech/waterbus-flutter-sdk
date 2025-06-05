import 'package:flutter/material.dart';

import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';

class WaterbusMediaView extends StatelessWidget {
  final MediaSource mediaSource;
  final RTCVideoViewObjectFit objectFit;
  final bool mirror;

  const WaterbusMediaView({
    super.key,
    required this.mediaSource,
    this.objectFit = RTCVideoViewObjectFit.RTCVideoViewObjectFitContain,
    this.mirror = false,
  });

  @override
  Widget build(BuildContext context) {
    if (WebRTC.platformIsIOS) {
      return RTCVideoPlatFormView(
        objectFit: objectFit,
        mirror: mirror,
        onViewReady: (controller) {
          mediaSource.renderer = controller;
          mediaSource.renderer?.srcObject = mediaSource.stream;
        },
      );
    }

    if (mediaSource.renderer == null ||
        (mediaSource.renderer is RTCVideoRenderer &&
            mediaSource.renderer!.textureId == null)) {
      return const SizedBox();
    }

    return RTCVideoView(
      mediaSource.renderer as RTCVideoRenderer,
      key: mediaSource.textureId == null
          ? null
          : Key(mediaSource.textureId!.toString()),
      objectFit: objectFit,
      mirror: mirror,
      // filterQuality: FilterQuality.none,
    );
  }
}
