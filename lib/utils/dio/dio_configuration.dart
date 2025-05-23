import 'dart:async';

import 'package:flutter/foundation.dart';

import 'package:dio/dio.dart';
import 'package:dio_compatibility_layer/dio_compatibility_layer.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart' as rt;
import 'package:injectable/injectable.dart';

import 'package:waterbus_sdk/constants/endpoints.dart';
import 'package:waterbus_sdk/constants/status_code.dart';
import 'package:waterbus_sdk/core/api/auth/datasources/auth_local_data_source.dart';
import 'package:waterbus_sdk/core/api/base/base_remote_data.dart';
import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';
import 'package:waterbus_sdk/utils/extensions/duration_extension.dart';
import 'package:waterbus_sdk/utils/queues/completer_queue.dart';

typedef TokensCallback = Function(
  String accessToken,
  String refreshToken,
);

@singleton
class DioConfiguration {
  final BaseRemoteData _remoteData;
  final AuthLocalDataSource _authLocal;

  DioConfiguration(this._remoteData, this._authLocal);

  bool _isRefreshing = false;
  final CompleterQueue<(String, String)> _refreshTokenCompleters =
      CompleterQueue<(String, String)>();

  // MARK: public methods
  Future<Dio> configuration(Dio dioClient) async {
    if (!kIsWeb) {
      await Rhttp.init();
      final rhttpAdapter = await RhttpCompatibleClient.create(
        settings: ClientSettings(
          httpVersionPref: WaterbusSdk.httpVersionPref,
          timeoutSettings: TimeoutSettings(
            timeout: 10.seconds,
            connectTimeout: 10.seconds,
          ),
          throwOnStatusCode: false,
          tlsSettings: TlsSettings(
            verifyCertificates: false,
            trustRootCertificates: false,
          ),
        ),
      );

      dioClient.httpClientAdapter = ConversionLayerAdapter(rhttpAdapter);
    }

    // Integration retry
    dioClient.interceptors.add(
      rt.RetryInterceptor(
        dio: dioClient,
        // logPrint: print, // specify log function (optional)
        retryDelays: [
          // set delays between retries (optional)
          1.seconds, // wait 1 sec before first retry
          2.seconds, // wait 2 sec before second retry
          // Duration(seconds: 3), // wait 3 sec before third retry
        ],
      ),
    );

    // Add interceptor for prevent response when system is maintaining...
    dioClient.interceptors.add(
      InterceptorsWrapper(
        onResponse: (response, handler) async {
          final bool isRefreshingToken =
              response.requestOptions.path == Endpoints.auth &&
                  response.requestOptions.method == 'GET';

          if (response.statusCode == StatusCode.unauthorized) {
            if (isRefreshingToken) {
              handler.next(response);
              _logOut();
            } else if (_authLocal.refreshToken.isNotEmpty &&
                _authLocal.accessToken.isNotEmpty) {
              try {
                final String oldAccessToken =
                    response.requestOptions.headers['Authorization'];

                final (String accessToken, String _) = await onRefreshToken(
                  oldAccessToken: oldAccessToken.split(' ').last,
                );

                response.requestOptions.headers['Authorization'] =
                    'Bearer $accessToken';

                final Response cloneReq = await dioClient.fetch(
                  response.requestOptions,
                );

                handler.resolve(cloneReq);
                // ignore: empty_catches
              } catch (_) {
                handler.next(response);
                _logOut();
              }
            } else {
              handler.next(response);
            }
          } else {
            handler.next(response);
          }
        },
        onError: (error, handler) async {},
      ),
    );

    return dioClient;
  }

  Future<(String, String)> onRefreshToken({
    String oldAccessToken = '',
    TokensCallback? callback,
  }) async {
    if (oldAccessToken != _authLocal.accessToken) {
      return (_authLocal.accessToken, _authLocal.refreshToken);
    }

    final Completer<(String, String)> completer = Completer<(String, String)>();
    _refreshTokenCompleters.add(completer);

    if (!_isRefreshing) {
      _isRefreshing = true;

      final (String, String) result = await _performRefreshToken(
        callback: callback,
      );

      _isRefreshing = false;
      _refreshTokenCompleters.completeAllQueue(result);
    }

    return completer.future;
  }

  // MARK: Private methods
  Future<(String, String)> _performRefreshToken({
    TokensCallback? callback,
  }) async {
    if (_authLocal.refreshToken.isEmpty) {
      if (_authLocal.accessToken.isNotEmpty) {
        _logOut();
      }
      return ("", "");
    }

    final Response response = await _remoteData.dio.get(
      Endpoints.auth,
      options: _remoteData.getOptionsRefreshToken,
    );

    if (response.statusCode == StatusCode.ok) {
      final String accessToken = response.data['token'];
      final String refreshToken = response.data['refreshToken'];

      _authLocal.saveTokens(
        accessToken: accessToken,
        refreshToken: refreshToken,
      );

      callback?.call(accessToken, refreshToken);

      return (accessToken, refreshToken);
    }

    return ("", "");
  }

  void _logOut() {
    _authLocal.deleteToken();
  }
}
