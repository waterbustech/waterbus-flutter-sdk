import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';

import 'package:waterbus_sdk/constants/storage_keys.dart';
import 'package:waterbus_sdk/utils/path_helper.dart';

@Singleton()
class BaseLocalData {
  Future<void> initialize() async {
    await PathHelper.createDirWaterbus();
    final String? path = await PathHelper.localStoreDirWaterbus;
    Hive.init(path);

    await _openBoxApp();
  }

  Future<void> _openBoxApp() async {
    await Hive.openBox(StorageKeys.boxAuth);
  }
}
