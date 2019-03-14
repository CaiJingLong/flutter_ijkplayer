part of './ijkplayer.dart';

/// Media Controller
class IjkMediaController extends ChangeNotifier {
  /// textureId
  int textureId;

  _IjkPlugin _plugin;

  bool get isInit => textureId == null;

  Future<void> _initIjk() async {
    try {
      var id = await createIjk();
      this.textureId = id;
      _plugin = _IjkPlugin(id);
    } catch (e) {
      print(e);
      print("初始化失败");
    }
  }

  void dispose() {
    this.textureId = null;
    this.notifyListeners();
    _plugin?.dispose();
    super.dispose();
  }

  Future<void> setDataSource(String url) async {
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
    print("id = $textureId uri = $uri");
    channel.invokeMethod("setDataSource", {"uri": uri});
  }

  Future<void> setAssetDataSource(String name, String package) async {
    print("id = $textureId asset name = $name package = $package");
    channel.invokeMethod("setAssetDataSource", <String, dynamic>{
      "name": name,
      "package": package,
    });
  }

  Future<void> setFileDataSource(String path) async {
    // todo 
  }
}
