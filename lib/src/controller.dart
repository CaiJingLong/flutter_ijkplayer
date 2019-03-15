part of './ijkplayer.dart';

/// Media Controller
class IjkMediaController extends ChangeNotifier {
  /// textureId
  int textureId;

  _IjkPlugin _plugin;

  bool get isInit => textureId == null;

  IJKEventChannel eventChannel;

  Future<void> _initIjk() async {
    try {
      var id = await createIjk();
      this.textureId = id;
      _plugin = _IjkPlugin(id);
      eventChannel = IJKEventChannel(this);
      await eventChannel.init();
    } catch (e) {
      print(e);
      print("初始化失败");
    }
  }

  void dispose() {
    this.textureId = null;
    this.notifyListeners();
    _plugin?.dispose();
    _plugin = null;
    eventChannel?.dispose();
    eventChannel = null;
    super.dispose();
  }

  Future<void> setNetworkDataSource(String url) async {
    if (this.textureId != null) {
      await _plugin?.dispose();
    }
    await _initIjk();
    await _plugin?.setNetworkDataSource(uri: url);
    this.notifyListeners();
  }

  Future<void> setAssetDataSource(String name, {String package}) async {
    if (this.textureId != null) {
      await _plugin?.dispose();
    }
    await _initIjk();
    await _plugin?.setAssetDataSource(name, package);
    this.notifyListeners();
  }

  Future<void> play() async {
    await _plugin?.play();
    this.notifyListeners();
  }

  Future<void> seekTo(double target) async {
    await _plugin?.seekTo(target);
  }

  Future<VideoInfo> getVideoInfo() async {
    Map<String, dynamic> result = await _plugin.getInfo();
    return VideoInfo.fromMap(result);
  }
}

const MethodChannel _globalChannel = MethodChannel("top.kikt/ijkplayer");

Future<int> createIjk() async {
  int id = await _globalChannel.invokeMethod("create");
  return id;
}

class _IjkPlugin {
  MethodChannel get channel => MethodChannel("top.kikt/ijkplayer/$textureId");

  int textureId;

  _IjkPlugin(this.textureId);

  Future<void> dispose() async {
    _globalChannel.invokeMethod("dispose", {"id": textureId});
  }

  Future<void> play() async {
    await channel.invokeMethod("play");
  }

  Future<void> pause() async {
    channel.invokeMethod("pause");
  }

  Future<void> stop() async {
    channel.invokeMethod("stop");
  }

  Future<void> setNetworkDataSource({String uri}) async {
    // todo
    print("id = $textureId net uri = $uri");
    channel.invokeMethod("setNetworkDataSource", {"uri": uri});
  }

  Future<void> setAssetDataSource(String name, String package) async {
    print("id = $textureId asset name = $name package = $package");
    var params = <String, dynamic>{
      "name": name,
    };
    if (package != null) {
      params["package"] = package;
    }
    channel.invokeMethod("setAssetDataSource", params);
  }

  Future<void> setFileDataSource(String path) async {
    if (!File(path).existsSync()) {
      return Error.fileNotExists;
    }
    channel.invokeMethod("setFileDataSource", <String, dynamic>{
      "path": path,
    });
    // todo
    print("id = $textureId file path = $path");
  }

  Future<Map<String, dynamic>> getInfo() async {
    var map = await channel.invokeMethod("getInfo");
    if (map == null) {
      return null;
    } else {
      return map.cast<String, dynamic>();
    }
  }

  Future<void> seekTo(double target) async {
    await channel.invokeMethod("seekTo", <String, dynamic>{
      "target": target,
    });
  }
}
