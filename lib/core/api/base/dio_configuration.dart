import 'dart:async';

import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:injectable/injectable.dart';

import 'package:waterbus_sdk/constants/api_enpoints.dart';
import 'package:waterbus_sdk/constants/http_status_code.dart';
import 'package:waterbus_sdk/core/api/auth/datasources/auth_local_datasource.dart';
import 'package:waterbus_sdk/core/api/base/base_remote_data.dart';
import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';
import 'package:waterbus_sdk/utils/extensions/duration_extensions.dart';
import 'package:waterbus_sdk/utils/queues/completer_queue.dart';

@singleton
class DioConfiguration {
  final BaseRemoteData _remoteData;
  final AuthLocalDataSource _localDataSource;

  DioConfiguration(this._remoteData, this._localDataSource);

  bool _isRefreshing = false;
  final CompleterQueue<(String, String)> _refreshTokenCompleters =
      CompleterQueue<(String, String)>();

  // MARK: public methods
  Future<Dio> configuration(Dio dioClient) async {
    // Integration retry
    dioClient.interceptors.add(
      RetryInterceptor(
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
              response.requestOptions.path == ApiEndpoints.auth &&
                  response.requestOptions.method == 'GET';

          if (response.statusCode == StatusCode.unauthorized) {
            if (isRefreshingToken) {
              handler.next(response);
              _logOut();
            } else if (_localDataSource.refreshToken != null &&
                _localDataSource.accessToken != null) {
              try {
                final String oldAccessToken =
                    response.requestOptions.headers['Authorization'];

                final (String accessToken, String _) =
                    await onRefreshToken(oldAccessToken: oldAccessToken);

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
    Function(
      String accessToken,
      String refreshToken,
    )? callback,
  }) async {
    if (oldAccessToken != 'Bearer ${AuthLocalDataSourceImpl().accessToken}') {
      return (
        AuthLocalDataSourceImpl().accessToken,
        AuthLocalDataSourceImpl().refreshToken
      );
    }

    final completer = Completer<(String, String)>();
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
    Function(
      String accessToken,
      String refreshToken,
    )? callback,
  }) async {
    if (AuthLocalDataSourceImpl().refreshToken.isEmpty) {
      if (AuthLocalDataSourceImpl().accessToken.isNotEmpty) {
        _logOut();
      }
      return ("", "");
    }

    final Response response = await _remoteData.dio.get(
      ApiEndpoints.auth,
      options: _remoteData.getOptionsRefreshToken,
    );

    if (response.statusCode == StatusCode.ok) {
      final String accessToken = response.data['token'];
      final String refreshToken = response.data['refreshToken'];

      WaterbusSdk.overrideToken(accessToken, refreshToken);

      callback?.call(accessToken, refreshToken);

      return (accessToken, refreshToken);
    }

    return ("", "");
  }

  void _logOut() {
    AuthLocalDataSourceImpl().clearToken();
  }
}
