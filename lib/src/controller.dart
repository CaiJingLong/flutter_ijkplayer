part of './ijkplayer.dart';

/// Media Controller
class IjkMediaController {
  int _textureId;

  int get textureId => _textureId;

  set textureId(int id) {
    _textureId = id;
    _textureIdController.add(id);
  }

  StreamController<int> _textureIdController = StreamController.broadcast();

  Stream<int> get textureIdStream => _textureIdController.stream;

  _IjkPlugin _plugin;

  bool get isInit => textureId == null;

  IJKEventChannel eventChannel;

  bool _isPlaying = false;

  bool get isPlaying => _isPlaying == true;

  set isPlaying(bool value) {
    this._isPlaying = value;
    _playingController.add(value);
  }

  StreamController<bool> _playingController = StreamController.broadcast();

  Stream<bool> get playingStream => _playingController.stream;

  StreamController<VideoInfo> _videoInfoController =
      StreamController.broadcast();

  Stream<VideoInfo> get videoInfoStream => _videoInfoController.stream;

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

  void dispose() async {
    await reset();
    _playingController.close();
    _videoInfoController.close();
    _textureIdController.close();
  }

  Future<void> reset() async {
    this.textureId = null;
    _plugin?.dispose();
    _plugin = null;
    eventChannel?.dispose();
    eventChannel = null;
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
  }

  Future<void> playOrPause() async {
    var videoInfo = await getVideoInfo();
    var playing = videoInfo.isPlaying;
    if (playing) {
      await _plugin?.pause();
    } else {
      await _plugin?.play();
    }
    refreshVideoInfo();
  }

  Future<void> play() async {
    await _plugin?.play();
    refreshVideoInfo();
  }

  Future<void> pause() async {
    await _plugin?.pause();
    refreshVideoInfo();
  }

  Future<void> seekTo(double target) async {
    await _plugin?.seekTo(target);
    refreshVideoInfo();
  }

  Future<VideoInfo> getVideoInfo() async {
    Map<String, dynamic> result = await _plugin?.getInfo();
    var info = VideoInfo.fromMap(result);
    return info;
  }

  Future<void> refreshVideoInfo() async {
    var info = await getVideoInfo();
    isPlaying = info.isPlaying;
    if (info.hasData) _videoInfoController.add(info);
  }

  void _autoPlay(bool autoPlay) {
    if (autoPlay) {
      eventChannel.autoPlay(this);
    }
  }

  Future<void> setVolume(int volume) async {
    await _plugin.setVolume(volume);
  }

  Future<void> stop() async {
//    await _plugin?.stop();
//    refreshVideoInfo();
    await _plugin.pause();
    await _plugin.seekTo(0);
    refreshVideoInfo();
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

  Future<void> setVolume(int volume) async {
    await channel.invokeMethod("setVolume", <String, dynamic>{
      "volume": volume,
    });
  }
}
