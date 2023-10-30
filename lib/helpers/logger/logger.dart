// Package imports:
import 'package:logger/logger.dart';

class WaterbusLogger {
  final String tag = 'WaterbusLogger';
  final Logger logger = Logger(
    printer: PrettyPrinter(), // Use the PrettyPrinter to format and print log
  );

  void log(String msg) {
    logger.d('[$tag]: $msg');
  }

  ///Singleton factory
  static final WaterbusLogger instance = WaterbusLogger._internal();

  factory WaterbusLogger() {
    return instance;
  }

  WaterbusLogger._internal();
}
