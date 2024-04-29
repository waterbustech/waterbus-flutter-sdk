import 'dart:typed_data';

import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';

Future<MediaStream?> startVirtualBackground({
  required Uint8List backgroundImage,
  String? textureId,
}) async {
  await Helper.enableVirtualBackground(
    backgroundImage: backgroundImage,
  );
  return null;
}

Future<void> stopVirtualBackground({bool reset = false}) async {
  await Helper.disableVirtualBackground();
}
