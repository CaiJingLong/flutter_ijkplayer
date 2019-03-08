part of './ijkplayer.dart';

/// Media Controller
class IjkMediaController extends ChangeNotifier {
  /// textureId
  int textureId;

  bool get isInit => textureId == null;

  Future _initIjk() async {
    try {
      var id = await _IjkPlugin.createIjk();
      this.textureId = id;
    } catch (e) {
      print(e);
      print("初始化失败");
    }
  }

  void dispose() {
    var id = textureId;
    this.textureId = null;
    this.notifyListeners();
    super.dispose();
    _IjkPlugin.dispose(id);
  }

  Future setDataSource(String url) async {
    if (this.textureId != null) {
      await _IjkPlugin.dispose(this.textureId);
    }
    await _initIjk();
    await _IjkPlugin.setDataSource(id: this.textureId, uri: url);
    this.notifyListeners();
  }

  Future play() async {
    await _IjkPlugin.play(this.textureId);
    this.notifyListeners();
  }
}

class _IjkPlugin {
  static MethodChannel channel = MethodChannel("top.kikt/ijkplayer");

  static Future<int> createIjk() async {
    int id = await channel.invokeMethod("create");
    return id;
  }

  static Future dispose(int id) async {
    channel.invokeMethod("dispose", id);
  }

  static Future play(int id) async {
    await channel.invokeMethod("play", id);
  }

  static Future pause(int id) async {
    channel.invokeMethod("pause", id);
  }

  static Future stop(int id) async {
    channel.invokeMethod("stop", id);
  }

  static Future setDataSource({int id, String uri}) async {
    print("id = $id , uri = $uri");
    channel.invokeMethod("setDataSource", {"id": id, "uri": uri});
  }
}
