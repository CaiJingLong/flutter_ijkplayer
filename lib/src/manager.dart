part of './ijkplayer.dart';

/// create 2019/3/18 by cai

class IjkManager {
  /// For the hot reload/ hot restart to release last texture resource. Release version does not have hot reload, so you can not call it.
  ///
  /// release版本可不调用, 主要是为了释放hot restart/hot reload的资源,因为原生资源不参与热重载
  ///
  ///
  /// If this method is not invoked in the debug version, the sound before the hot reload will continue to play.
  static Future<void> initIJKPlayer() async {
    _globalChannel.invokeMethod("init");
  }

  static Future<void> setSystemVolume(int volume) async {
    await _globalChannel.invokeMethod("setSystemVolume", {
      "volume": volume,
    });
  }

  static Future<int> getSystemVolume() async {
    return _globalChannel.invokeMethod("getSystemVolume");
  }
}
