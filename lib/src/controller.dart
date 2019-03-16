part of './ijkplayer.dart';

/// Media Controller
class IjkMediaController extends ChangeNotifier {
  /// textureId
  int textureId;

  _IjkPlugin _plugin;

  bool get isInit => textureId == null;

  IJKEventChannel eventChannel;

  bool _isPlaying = false;

  bool get isPlaying => _isPlaying;

  set isPlaying(bool value) {
    this._isPlaying = value;
  }

  Future<void> _initIjk() async {
    try {
      var id = await _createIjk();
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

  Future<void> setNetworkDataSource(
    String url, {
    bool autoPlay = false,
  }) async {
    await _initDataSource(() async {
      await _plugin?.setNetworkDataSource(uri: url);
    }, autoPlay);
  }

  Future<void> setAssetDataSource(
    String name, {
    String package,
    bool autoPlay = false,
  }) async {
    await _initDataSource(() async {
      await _plugin?.setAssetDataSource(name, package);
    }, autoPlay);
  }

  Future<void> setFileDataSource(
    File file, {
    bool autoPlay = false,
  }) async {
    await _initDataSource(() async {
      await _plugin?.setFileDataSource(file.absolute.path);
    }, autoPlay);
  }

  Future<void> _initDataSource(
    Future setDataSource(),
    bool autoPlay,
  ) async {
    autoPlay ??= false;

    if (this.textureId != null) {
      await _plugin?.dispose();
    }
    await _initIjk();
    _autoPlay(autoPlay);
    await setDataSource();
    this.notifyListeners();
  }

  Future<void> playOrPause() async {
    var playing = isPlaying == true;
    if (playing) {
      await _plugin?.pause();
      playing = false;
    } else {
      await _plugin?.play();
      playing = true;
    }
    this.notifyListeners();
  }

  Future<void> play() async {
    await _plugin?.play();
    this.notifyListeners();
  }

  Future<void> pause() async {
    await _plugin?.pause();
    this.notifyListeners();
  }

  Future<void> seekTo(double target) async {
    await _plugin?.seekTo(target);
  }

  Future<VideoInfo> getVideoInfo() async {
    Map<String, dynamic> result = await _plugin?.getInfo();
    var info = VideoInfo.fromMap(result);
    isPlaying = info.isPlaying;
    return info;
  }

  void _autoPlay(bool autoPlay) {
    if (autoPlay) {
      eventChannel.autoPlay(this);
    }
  }

  Future<void> stop() async {
    await _plugin?.stop();
    isPlaying = false;
    this.notifyListeners();
  }
}

/// about channel

const MethodChannel _globalChannel = MethodChannel("top.kikt/ijkplayer");

Future<int> _createIjk() async {
  int id = await _globalChannel.invokeMethod("create");
  return id;
}

class _IjkPlugin {
  MethodChannel get channel => MethodChannel("top.kikt/ijkplayer/$textureId");

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

  Future<void> setNetworkDataSource({String uri}) async {
    print("id = $textureId net uri = $uri");
    await channel.invokeMethod("setNetworkDataSource", {"uri": uri});
  }

  Future<void> setAssetDataSource(String name, String package) async {
    print("id = $textureId asset name = $name package = $package");
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
