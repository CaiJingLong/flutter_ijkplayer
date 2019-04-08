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

  static setLandScape() async {
    if (Platform.isAndroid) {
      await SystemChrome.setEnabledSystemUIOverlays([]);
      await SystemChrome.setPreferredOrientations(
        [
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ],
      );
    } else if (Platform.isIOS) {
      await setSupportOrientation([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);

      setCurrentOrientation(DeviceOrientation.landscapeLeft);
    }
  }

  static setPortrait() async {
    if (Platform.isAndroid) {
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);
      SystemChrome.restoreSystemUIOverlays();
      showSystemOverlay();
    } else if (Platform.isIOS) {
      await unlockOrientation();
      setCurrentOrientation(DeviceOrientation.portraitUp);
    }
  }

  static showSystemOverlay() {
    SystemChrome.setEnabledSystemUIOverlays(const [
      SystemUiOverlay.top,
      SystemUiOverlay.bottom,
    ]);
  }

  static setSupportOrientation(List<DeviceOrientation> orientations) async {
    if (orientations.isEmpty) {
      return;
    }
    if (Platform.isAndroid) {
      await SystemChrome.setPreferredOrientations(orientations);
      SystemChrome.restoreSystemUIOverlays();
    } else if (Platform.isIOS) {
      var orientationIndexList = orientations.map((o) => o.index).toList();

      await _globalChannel.invokeMethod(
        "setSupportOrientation",
        <String, dynamic>{
          "supportOrientation": orientationIndexList,
        },
      );
    }
  }

  static setCurrentOrientation(DeviceOrientation orientation) async {
    if (orientation == null) {
      return;
    }
    if (Platform.isAndroid) {
    } else if (Platform.isIOS) {
      await _globalChannel.invokeMethod(
        "setCurrentOrientation",
        <String, dynamic>{
          "target": orientation.index,
        },
      );
    }
  }

  static unlockOrientation() async {
    if (Platform.isAndroid) {
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
      await SystemChrome.restoreSystemUIOverlays();
      showSystemOverlay();
    } else if (Platform.isIOS) {
      _globalChannel.invokeMethod("unlockOrientation");
    }
  }
}
