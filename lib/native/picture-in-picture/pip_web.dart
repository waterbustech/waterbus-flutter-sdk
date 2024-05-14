@JS()
library t;

// Dart imports:
import 'dart:js_interop';

@JS()
external void startPictureInPicture(String textureId, bool enabled);

Future<void> setPictureInPictureEnabled({
  required String textureId,
  bool enabled = true,
}) async {
  startPictureInPicture(textureId, enabled);
}
