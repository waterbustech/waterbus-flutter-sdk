import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:rhttp/rhttp.dart';
import 'package:waterbus_sdk/utils/extensions/duration_extensions.dart';

class RhttpAdapter implements HttpClientAdapter {
  late final RhttpClient _adapter;

  Future<void> init() async {
    _adapter = await RhttpClient.create(
      settings: ClientSettings(
        timeout: 10.seconds,
        connectTimeout: 10.seconds,
        tlsSettings: const TlsSettings(
          verifyCertificates: false,
        ),
      ),
    );
  }

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<List<int>>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    try {
      // Convert Dio's RequestOptions to Rhttp's request parameters
      final method = _getHttpMethod(options.method);
      final uri = options.uri;

      final headers = options.headers.map(
        (k, v) => MapEntry(k.toString(), v.toString()),
      );
      final body = options.data;
      HttpBody? httpBody;

      if (body != null) {
        httpBody = HttpBody.json(
          body is String
              ? jsonDecode(body)
              : (body as Map).map((k, v) => MapEntry(k.toString(), v)),
        );
      }

      // Use rhttp to send the request
      final response = await _adapter.requestBytes(
        method: method,
        url: uri.toString(),
        query: uri.queryParameters,
        headers: HttpHeaders.rawMap(headers),
        body: httpBody,
      );

      // Convert response headers to a Map<String, List<String>> format
      final responseHeaders = response.headers
          .groupListsBy((header) => header.$1)
          .map((key, value) => MapEntry(key, value.map((e) => e.$2).toList()));

      return ResponseBody.fromBytes(
        response.body,
        response.statusCode,
        headers: responseHeaders,
      );
    } catch (e) {
      throw DioException(
        requestOptions: options,
        error: e,
      );
    }
  }

  HttpMethod _getHttpMethod(String method) {
    switch (method.toUpperCase()) {
      case 'GET':
        return HttpMethod.get;
      case 'POST':
        return HttpMethod.post;
      case 'PUT':
        return HttpMethod.put;
      case 'DELETE':
        return HttpMethod.delete;
      case 'PATCH':
        return HttpMethod.patch;
      case 'HEAD':
        return HttpMethod.head;
      case 'OPTIONS':
        return HttpMethod.options;
      default:
        throw UnsupportedError('Unsupported HTTP method $method');
    }
  }

  @override
  void close({bool force = false}) {
    _adapter.dispose();
  }
}
