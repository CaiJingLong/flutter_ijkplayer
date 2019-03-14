part of './ijkplayer.dart';

/// Media Controller
class IjkMediaController extends ChangeNotifier {
  /// textureId
  int textureId;

  _IjkPlugin _plugin;

  bool get isInit => textureId == null;

  Future _initIjk() async {
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

  Future setDataSource(String url) async {
    if (this.textureId != null) {
      await _plugin?.dispose();
    }
    await _initIjk();
    await _plugin?.setDataSource(uri: url);
    this.notifyListeners();
  }

  Future play() async {
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

  Future dispose() async {
    channel.invokeMethod("dispose");
  }

  Future play() async {
    await channel.invokeMethod("play");
  }

  Future pause() async {
    channel.invokeMethod("pause");
  }

  Future stop() async {
    channel.invokeMethod("stop");
  }

  Future setDataSource({String uri}) async {
    print("id = $textureId uri = $uri");
    channel.invokeMethod("setDataSource", {"uri": uri});
  }
}
