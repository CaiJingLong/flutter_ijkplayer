part of './ijkplayer.dart';

/// create 2019/3/18 by cai

class IjkManager {
  static Future<void> setSystemVolume(int volume) async {
    await _globalChannel.invokeMethod("setSystemVolume", {
      "volume": volume,
    });
  }
}
