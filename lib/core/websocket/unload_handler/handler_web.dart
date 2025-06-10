import 'dart:js_interop';

import 'package:web/web.dart' as web;

void unloadHandler(Function callback) {
  web.window.onbeforeunload = (web.BeforeUnloadEvent event) {
    callback();
  }.toJS;
}
