library dio_flutter_transformer;

import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// FlutterTransformer optimized for performance.
/// JSON decoding/encoding will only be offloaded to a separate isolate
/// if the data is above a certain size threshold.
class FlutterTransformer extends SyncTransformer {
  static const int _computeThreshold = 200 * 1024; // 200 KB threshold

  FlutterTransformer()
      : super(
          jsonDecodeCallback: _parseJson,
          jsonEncodeCallback: _parseString,
        );
}

/// Determines if data should be processed in the main thread or offloaded.
bool _shouldUseCompute(String text) {
  return text.length > FlutterTransformer._computeThreshold;
}

/// Parses and decodes a JSON string. Offloads to a separate isolate if data is large.
Future<Map<String, dynamic>> _parseJson(String text) {
  if (_shouldUseCompute(text)) {
    return compute(_parseAndDecode, text);
  } else {
    return Future.value(_parseAndDecode(text));
  }
}

/// Encodes an object to a JSON string. Offloads to a separate isolate if data is large.
Future<String> _parseString(Object obj) {
  final String jsonString = _parseAndEncode(obj);
  if (jsonString.length > FlutterTransformer._computeThreshold) {
    return compute(_parseAndEncode, obj);
  } else {
    return Future.value(jsonString);
  }
}

/// Decodes a JSON string into a Map.
Map<String, dynamic> _parseAndDecode(String response) {
  return jsonDecode(response);
}

/// Encodes an object into a JSON string.
String _parseAndEncode(Object obj) {
  return jsonEncode(obj);
}
