/// IJKPlayer Config
class IjkConfig {
  /// when [isLog] is true, will print log in console
  static bool isLog = false;

  static LogLevel level = LogLevel.debug;

  static String logTag = "Ijk";
}

enum LogLevel {
  verbose,
  debug,
  info,
  warning,
  error,
}
