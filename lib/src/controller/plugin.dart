part of '../ijkplayer.dart';

/// about channel
MethodChannel _globalChannel = MethodChannel("top.kikt/ijkplayer");

Future<int> _createIjk({
  List<IjkOption> options,
}) async {
  List<Map<String, dynamic>> _optionList = [];

  for (var option in options) {
    _optionList.add(option.toMap());
  }

  int id = await _globalChannel.invokeMethod(
    "create",
    <String, dynamic>{
      "options": _optionList,
    },
  );
  return id;
}

class _IjkPlugin {
  MethodChannel get channel => MethodChannel("top.kikt/ijkplayer/$textureId");

  /// texture id
  int textureId;

  _IjkPlugin(this.textureId);

  Future<void> dispose() async {
    await _globalChannel.invokeMethod("dispose", {"id": textureId});
  }

  Future<void> play() async {
    await channel.invokeMethod("play");
  }

  Future<void> pause() async {
    await channel.invokeMethod("pause");
  }

  Future<void> stop() async {
    await channel.invokeMethod("stop");
  }

  Future<void> setNetworkDataSource(
      {String uri, Map<String, String> headers = const {}}) async {
    LogUtils.debug("id = $textureId net uri = $uri ,headers = $headers");
    await channel.invokeMethod("setNetworkDataSource", <String, dynamic>{
      "uri": uri,
      "headers": headers,
    });
  }

  Future<void> setAssetDataSource(String name, String package) async {
    LogUtils.debug("id = $textureId asset name = $name package = $package");
    var params = <String, dynamic>{
      "name": name,
    };
    if (package != null) {
      params["package"] = package;
    }
    await channel.invokeMethod("setAssetDataSource", params);
  }

  Future<void> setFileDataSource(String path) async {
    if (!File(path).existsSync()) {
      return Error.fileNotExists;
    }
    await channel.invokeMethod("setFileDataSource", <String, dynamic>{
      "path": path,
    });
    LogUtils.debug("id = $textureId file path = $path");
  }

  Future<Map<String, dynamic>> getInfo() async {
    try {
      var map = await channel.invokeMethod("getInfo");
      if (map == null) {
        return null;
      } else {
        return map.cast<String, dynamic>();
      }
    } on Exception {
      return null;
    }
  }

  Future<void> seekTo(double target) async {
    await channel.invokeMethod("seekTo", <String, dynamic>{
      "target": target,
    });
  }

  ///
  Future<void> setVolume(int volume) async {
    await channel.invokeMethod("setVolume", <String, dynamic>{
      "volume": volume,
    });
  }

  Future<Uint8List> screenShot() async {
    var result = await channel.invokeMethod("screenShot");
    if (result == null) {
      return null;
    }
    return result;
  }

  Future<void> setSpeed(double speed) async {
    await channel.invokeMethod("setSpeed", speed);
  }
}
