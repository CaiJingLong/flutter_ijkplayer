part of '../ijkplayer.dart';

/// create 2019/3/18 by cai
///
class IjkManager {
  /// For the hot reload/ hot restart to release last texture resource. Release version does not have hot reload, so you can not call it.
  ///
  /// release版本可不调用, 主要是为了释放hot restart/hot reload的资源,因为原生资源不参与热重载
  ///
  ///
  /// If this method is not invoked in the debug version, the sound before the hot reload will continue to play.
  static Future<void> initIJKPlayer() async {
    await _globalChannel.invokeMethod("init");
  }

  /// set system volume
  static Future<void> setSystemVolume(int volume) async {
    await _globalChannel.invokeMethod("setSystemVolume", {
      "volume": volume,
    });
  }

  /// get system volume
  static Future<int> getSystemVolume() async {
    return _globalChannel.invokeMethod("getSystemVolume");
  }

  static Future<int> systemVolumeUp() async {
    return _globalChannel.invokeMethod("volumeUp");
  }

  static Future<int> systemVolumeDown() async {
    return _globalChannel.invokeMethod("volumeDown");
  }

  static Future<void> hideSystemVolumeBar() async {
    if (Platform.isIOS) {
      return _globalChannel.invokeMethod("hideSystemVolumeBar");
    }
  }

  static Future<void> setSystemBrightness(double brightness) async {
    await _globalChannel.invokeMethod("setSystemBrightness", <String, dynamic>{
      "brightness": brightness,
    });
  }

  static Future<double> getSystemBrightness() async {
    return _globalChannel.invokeMethod("getSystemBrightness");
  }

  static Future<void> resetBrightness() async {
    await _globalChannel.invokeMethod("resetBrightness");
  }

  static Future<void> _setOrientation(List<DeviceOrientation> list) async {
    if (Platform.isAndroid) {
      SystemChrome.setPreferredOrientations(list);
    } else if (Platform.isIOS) {
      var orientations = list.map((v) => v.index).toList();
      if (list.isEmpty) {
        _globalChannel.invokeMethod("unlockOrientation");
      } else {
        _globalChannel.invokeMethod(
          "setOrientation",
          {
            "orientation": orientations,
          },
        );
      }
    }
  }

  static setLandScapeLeft() {
    if (Platform.isAndroid) {
      SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft],
      );
    } else if (Platform.isIOS) {
      _setOrientation(
        [DeviceOrientation.landscapeLeft],
      );
    }
  }

  static portraitUp() async {
    if (Platform.isAndroid) {
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);
      await SystemChrome.restoreSystemUIOverlays();
    } else {
      _setOrientation(
        [DeviceOrientation.portraitUp],
      );
    }
  }

  static unlockOrientation() async {
    if (Platform.isAndroid) {
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
        DeviceOrientation.portraitUp,
      ]);
      await SystemChrome.restoreSystemUIOverlays();
    } else if (Platform.isIOS) {
      await _setOrientation([]);
      await SystemChrome.restoreSystemUIOverlays();
    }
  }
}
