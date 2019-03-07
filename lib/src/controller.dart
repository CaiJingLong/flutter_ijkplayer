part of './ijkplayer.dart';

class IjkController extends ChangeNotifier {
  int textureId;

  bool get isInit => textureId == null;

  Future initIjk() async {
    try {
      var id = await _IjkPlugin.createIjk();
      this.textureId = id;
    } catch (e) {
      print(e);
      print("初始化失败");
    }
  }

  void dispose() {
    super.dispose();
    var id = textureId;
    this.textureId = null;
    _IjkPlugin.dispose(id);
  }

  Future setData(String url) async {
    await _IjkPlugin.setData(id: this.textureId, uri: url);
  }

  Future setNetData(String uri) async {
    await _IjkPlugin.setNetData(id: this.textureId, uri: uri);
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

  static Future setData({int id, String uri}) async {
    print("id = $id , uri = $uri");
    channel.invokeMethod("setData", {"id": id, "uri": uri});
  }

  static Future setNetData({int id, String uri}) async {
    print("id = $id , uri = $uri");
    channel.invokeMethod("setNetData", {"id": id, "uri": uri});
  }
}
