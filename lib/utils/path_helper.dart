// ignore_for_file: depend_on_referenced_packages

import 'dart:io';

import 'package:flutter/foundation.dart';

import 'package:path_provider/path_provider.dart';

class PathHelper {
  static Future<void> createDirWaterbus() async {
    if (kIsWeb) return;

    final String? tempWaterbusDir = await tempDirWaterbus;
    final String? localStoreWaterbusDir = await localStoreDirWaterbus;
    if (tempWaterbusDir == null || localStoreWaterbusDir == null) return;

    final Directory myDir = Directory(tempWaterbusDir);
    final Directory localDir = Directory(localStoreWaterbusDir);
    final Directory? appDirectory = await appDir;

    if (!myDir.existsSync()) {
      await myDir.create();
    }

    if (!localDir.existsSync()) {
      await localDir.create();
    }

    if (appDirectory != null && !appDirectory.existsSync()) {
      await appDirectory.create();
    }
  }

  static Future<String?> get tempDirWaterbus async {
    if (kIsWeb) return null;

    return '${(await getTemporaryDirectory()).path}/Waterbus';
  }

  static Future<String?> get localStoreDirWaterbus async {
    if (kIsWeb) return null;

    return '${(await getTemporaryDirectory()).path}/hive';
  }

  static Future<Directory?> get appDir async {
    if (kIsWeb) return null;

    return await getApplicationDocumentsDirectory();
  }
}
