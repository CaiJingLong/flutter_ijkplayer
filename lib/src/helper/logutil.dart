import 'package:flutter_ijkplayer/src/helper/config.dart';

/// IJKPlayer Log Util
class LogUtils {
  LogUtils._();

  static void verbose(Object msg) {
    log("${msg?.toString()}", LogLevel.verbose);
  }

  static void debug(Object msg) {
    log("${msg?.toString()}", LogLevel.debug);
  }

  static void info(Object msg) {
    log("${msg?.toString()}", LogLevel.info);
  }

  static void warning(Object msg) {
    log("${msg?.toString()}", LogLevel.warning);
  }

  static void error(Object msg) {
    log("${msg?.toString()}", LogLevel.error);
  }

  static void log(Object msg, LogLevel level) {
    if (level == null) {
      return;
    }
    if (!IjkConfig.isLog) {
      return;
    }

    if (level.index < IjkConfig.level.index) {
      return;
    }

    String levelString = level.toString().split(".")[1][0];

    print("($levelString)${IjkConfig.logTag}:${msg.toString()}");
  }
}
