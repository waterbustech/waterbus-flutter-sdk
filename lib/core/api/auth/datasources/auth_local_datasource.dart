import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';

import 'package:waterbus_sdk/constants/storage_keys.dart';

abstract class AuthLocalDataSource {
  void saveTokens({
    required String? accessToken,
    required String? refreshToken,
  });
  void clearToken();
  String? get accessToken;
  String? get refreshToken;
}

@LazySingleton(as: AuthLocalDataSource)
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final Box _hiveBox = Hive.box(StorageKeys.boxAuth);

  @override
  void saveTokens({
    required String? accessToken,
    required String? refreshToken,
  }) {
    _hiveBox.put(StorageKeys.accessToken, accessToken);
    _hiveBox.put(StorageKeys.refreshToken, refreshToken);
  }

  @override
  void clearToken() {
    _hiveBox.delete(StorageKeys.accessToken);
    _hiveBox.delete(StorageKeys.refreshToken);
  }

  @override
  String get accessToken =>
      _hiveBox.get(StorageKeys.accessToken, defaultValue: null) ?? "";

  @override
  String get refreshToken =>
      _hiveBox.get(StorageKeys.refreshToken, defaultValue: null) ?? "";
}
