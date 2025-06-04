import 'package:hive_ce/hive.dart';

import 'package:waterbus_sdk/constants/storage_keys.dart';
import 'package:waterbus_sdk/utils/path_helper.dart';

class BaseLocalData {
  static Future<void> initialize() async {
    await PathHelper.createDirWaterbus();
    final String? path = await PathHelper.localStoreDirWaterbus;
    Hive.init(path);

    await _openBoxApp();
  }

  static Future<void> _openBoxApp() async {
    await Hive.openBox(StorageKeys.boxAuth);
  }
}
