import 'config.dart';

class LogUtils {
  LogUtils._();
  static void log(Object msg) {
    if (IjkConfig.isLog) print("ijkplayer: ${msg?.toString()}");
  }
}
