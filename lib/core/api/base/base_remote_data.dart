import 'dart:async';
import 'dart:convert' as convert;
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import 'package:waterbus_sdk/constants/status_code.dart';
import 'package:waterbus_sdk/core/api/auth/datasources/auth_local_data_source.dart';
import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';
import 'package:waterbus_sdk/injection/injection_container.dart';
import 'package:waterbus_sdk/utils/dio/dio_configuration.dart';
import 'package:waterbus_sdk/utils/extensions/duration_extension.dart';

@Singleton()
class BaseRemoteData {
  final AuthLocalDataSource _authLocal;

  BaseRemoteData(this._authLocal);

  Dio dio = Dio(
    BaseOptions(
      baseUrl: WaterbusSdk.baseUrl.baseUrlApi,
      connectTimeout: 10.seconds,
      receiveTimeout: 10.seconds,
      sendTimeout: 10.seconds,
    ),
  );

  Future<Response<dynamic>> post(
    String gateway, {
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final Response response = await dio.post(
        gateway,
        data: body == null ? {} : convert.jsonEncode(body),
        options: getOptions(),
        queryParameters: queryParameters,
      );

      return response;
    } on DioException catch (exception) {
      return catchDioException(exception: exception, gateway: gateway);
    }
  }

  Future<Response<dynamic>> put(
    String gateway,
    Map<String, dynamic> body,
  ) async {
    try {
      final Response response = await dio.put(
        gateway,
        data: convert.jsonEncode(body),
        options: getOptions(),
      );

      return response;
    } on DioException catch (exception) {
      return catchDioException(exception: exception, gateway: gateway);
    }
  }

  Future<Response<dynamic>> get(
    String gateway, {
    String params = '',
    String? query,
  }) async {
    try {
      final Map<String, String> paramsObject = {};
      if (query != null) {
        query.split('&').forEach((element) {
          paramsObject[element.split('=')[0].toString()] =
              element.split('=')[1].toString();
        });
      }

      final Response response = await dio.get(
        gateway,
        options: getOptions(),
        queryParameters: query == null ? null : paramsObject,
      );

      return response;
    } on DioException catch (exception) {
      return catchDioException(exception: exception, gateway: gateway);
    }
  }

  Future<Response<dynamic>> delete(
    String gateway, {
    String? params,
    String? query,
    Map<String, dynamic>? body,
    FormData? formData,
  }) async {
    try {
      final Map<String, String> paramsObject = {};
      if (query != null) {
        query.split('&').forEach((element) {
          paramsObject[element.split('=')[0].toString()] =
              element.split('=')[1].toString();
        });
      }

      final Response response = await dio.delete(
        gateway,
        data: formData ?? (body == null ? null : convert.jsonEncode(body)),
        options: getOptions(),
        queryParameters: query == null ? null : paramsObject,
      );

      return response;
    } on DioException catch (exception) {
      return catchDioException(exception: exception, gateway: gateway);
    }
  }

  Response catchDioException({
    required DioException exception,
    required String gateway,
  }) {
    return Response(
      requestOptions: RequestOptions(path: gateway),
      statusCode: StatusCode.badGateway,
      statusMessage: "DIO_EXCEPTION",
    );
  }

  Options get getOptionsRefreshToken {
    return Options(
      validateStatus: (status) {
        if (status == StatusCode.notAcceptable &&
            _authLocal.accessToken.isNotEmpty) {
          _authLocal.deleteToken();
        }

        return true;
      },
      headers: {
        'Authorization': 'Bearer ${_authLocal.refreshToken}',
        'Content-Type': 'application/json; charset=UTF-8',
        'Connection': 'keep-alive',
        'Accept': '*/*',
        'Accept-Encoding': 'gzip, deflate, br',
        'X-API-Key': WaterbusSdk.baseUrl.apiKey,
      },
    );
  }

  Options getOptions() {
    return Options(
      validateStatus: (status) {
        return true;
      },
      headers: getHeaders(),
    );
  }

  getHeaders() {
    return {
      'Authorization': 'Bearer ${_authLocal.accessToken}',
      'Content-Type': 'application/json',
      'Connection': 'keep-alive',
      'Accept': '*/*',
      'Accept-Encoding': 'gzip, deflate, br',
      'X-API-Key': WaterbusSdk.baseUrl.apiKey,
    };
  }

  initialize() async {
    dio = Dio(
      BaseOptions(
        baseUrl: WaterbusSdk.baseUrl.baseUrlApi,
        connectTimeout: 10.seconds,
        receiveTimeout: 10.seconds,
        sendTimeout: 10.seconds,
        responseDecoder: _responseDecoder,
      ),
    );

    await Future.wait([
      getIt<DioConfiguration>()
          .configuration(dio)
          .then((client) => dio = client),
    ]);
  }

  FutureOr<String?> _responseDecoder(
    List<int> responseBytes,
    RequestOptions options,
    ResponseBody responseBody,
  ) {
    final encoding = (responseBody.headers["content-encoding"] ?? ['']).first;
    switch (encoding) {
      case "":
        return utf8.decode(responseBytes);
      case "gzip":
        return utf8.decode(gzip.decode(responseBytes));
      default:
        throw Exception(
          "unsupported encoding /$encoding/ used in response body",
        );
    }
  }
}
