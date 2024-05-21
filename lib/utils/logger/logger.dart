import 'package:flutter/foundation.dart';

import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

@injectable
class WaterbusLogger {
  final String tag = 'WaterbusLogger';
  final Logger logger = Logger(
    printer: PrettyPrinter(), // Use the PrettyPrinter to format and print log
  );

  void log(String msg) {
    if (kReleaseMode) return;

    logger.i('[$tag]: $msg');
  }

  void bug(String msg) {
    if (kReleaseMode) return;

    logger.e('[$tag]: $msg');
  }

  ///Singleton factory
  static final WaterbusLogger instance = WaterbusLogger._internal();

  factory WaterbusLogger() {
    return instance;
  }

  WaterbusLogger._internal();
}
