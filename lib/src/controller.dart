part of './ijkplayer.dart';

/// Media Controller
class IjkMediaController {
  /// MediaController
  IjkMediaController({
    this.autoRotate = true,
  });

  /// texture id from native
  int _textureId;

  /// It will automatically correct the direction of the video.
  bool autoRotate;

  /// texture id from native
  int get textureId => _textureId;

  /// set texture id, Normally the user does not call
  set textureId(int id) {
    _textureId = id;
    _textureIdController.add(id);
  }

  /// on texture id change
  StreamController<int> _textureIdController = StreamController.broadcast();

  /// on texture id change
  Stream<int> get textureIdStream => _textureIdController?.stream;

  /// Channel of flutter and native.
  _IjkPlugin _plugin;

  /// Whether texture id is null
  bool get isInit => textureId == null;

  /// channel of native to flutter
  _IJKEventChannel eventChannel;

  /// playing state
  bool _isPlaying = false;

  /// playing state
  bool get isPlaying => _isPlaying == true;

  /// playing state
  set isPlaying(bool value) {
    this._isPlaying = value;
    _playingController?.add(value);
  }

  /// playing state stream controller
  StreamController<bool> _playingController = StreamController.broadcast();

  /// playing state stream
  Stream<bool> get playingStream => _playingController?.stream;

  /// video info stream controller
  StreamController<VideoInfo> _videoInfoController =
      StreamController.broadcast();

  /// video info stream
  Stream<VideoInfo> get videoInfoStream => _videoInfoController?.stream;

  /// video volume stream controller
  StreamController<int> _volumeController = StreamController.broadcast();

  /// video volume stream
  Stream<int> get volumeStream => _volumeController?.stream;

  /// video volume, not system volume
  int _volume = 100;

  /// video volume, not system volume
  set volume(int value) {
    if (value > 100) {
      value = 100;
    } else if (value < 0) {
      value = 0;
    }
    this._volume = value;
    _volumeController?.add(value);
    _setVolume(value);
  }

  /// video volume, not system volume
  int get volume => _volume;

  /// create ijk texture id from native
  Future<void> _initIjk() async {
    try {
      var id = await _createIjk();
      this.textureId = id;
      _plugin = _IjkPlugin(id);
      eventChannel = _IJKEventChannel(this);
      await eventChannel.init();
      volume = 100;
    } catch (e) {
      LogUtils.log(e);
      LogUtils.log("初始化失败");
    }
  }

  /// [reset] and close all controller
  void dispose() async {
    await reset();
    _playingController?.close();
    _videoInfoController?.close();
    _textureIdController?.close();
    _volumeController?.close();

    _playingController = null;
    _videoInfoController = null;
    _textureIdController = null;
    _volumeController = null;
  }

  /// dispose all resource
  Future<void> reset() async {
    volume = 100;
    this.textureId = null;
    _plugin?.dispose();
    _plugin = null;
    eventChannel?.dispose();
    eventChannel = null;
  }

  /// set net DataSource
  Future<void> setNetworkDataSource(
    String url, {
    bool autoPlay = false,
  }) async {
    await _initDataSource(() async {
      await _plugin?.setNetworkDataSource(uri: url);
    }, autoPlay);
  }

  /// set asset DataSource
  Future<void> setAssetDataSource(
    String name, {
    String package,
    bool autoPlay = false,
  }) async {
    await _initDataSource(() async {
      await _plugin?.setAssetDataSource(name, package);
    }, autoPlay);
  }

  /// Set datasource with [DataSource]
  Future<void> setDataSource(
    DataSource source, {
    bool autoPlay = false,
  }) async {
    switch (source.type) {
      case DataSourceType.asset:
        await setAssetDataSource(
          source._assetName,
          package: source._assetPackage,
          autoPlay: autoPlay,
        );
        break;
      case DataSourceType.file:
        await setFileDataSource(source._file, autoPlay: autoPlay);
        break;
      case DataSourceType.network:
        await setNetworkDataSource(source._netWorkUrl);
        break;
      default:
    }
  }

  /// set file DataSource
  Future<void> setFileDataSource(
    File file, {
    bool autoPlay = false,
  }) async {
    await _initDataSource(() async {
      await _plugin?.setFileDataSource(file.absolute.path);
    }, autoPlay);
  }

  /// dispose last textureId resource
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

  /// Play or pause according to your current status
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

  /// play media
  Future<void> play() async {
    await _plugin?.play();
    refreshVideoInfo();
  }

  /// pause media
  Future<void> pause() async {
    await _plugin?.pause();
    refreshVideoInfo();
  }

  /// seek to second
  ///
  /// [target] unit is second
  Future<void> seekTo(double target) async {
    await _plugin?.seekTo(target);
    refreshVideoInfo();
  }

  Future<void> seekToProgress(double progress) async {
    var videoInfo = await getVideoInfo();
    var target = videoInfo.duration * progress;
    await this.seekTo(target);
    refreshVideoInfo();
  }

  /// get video info from native
  Future<VideoInfo> getVideoInfo() async {
    Map<String, dynamic> result = await _plugin?.getInfo();
    var info = VideoInfo.fromMap(result);
    return info;
  }

  /// request info and notify
  Future<void> refreshVideoInfo() async {
    var info = await getVideoInfo();
    isPlaying = info.isPlaying;
    if (info.hasData) _videoInfoController?.add(info);
    LogUtils.log("info = $info");
  }

  /// AutoPlay use
  void _autoPlay(bool autoPlay) {
    if (autoPlay) {
      eventChannel?.autoPlay(this);
    }
  }

  /// set video volume
  Future<void> _setVolume(int volume) async {
    await _plugin?.setVolume(volume);
  }

  /// [pause] and [seekTo] 0
  Future<void> stop() async {
//    await _plugin?.stop();
//    refreshVideoInfo();
    await _plugin?.pause();
    await _plugin?.seekTo(0);
    refreshVideoInfo();
  }

  /// get system volume
  Future<int> getSystemVolume() async {
    return IjkManager.getSystemVolume();
  }

  /// set system volume
  Future<void> setSystemVolume(int volume) async {
    await IjkManager.setSystemVolume(volume);
  }
}

/// about channel
MethodChannel _globalChannel = MethodChannel("top.kikt/ijkplayer");

Future<int> _createIjk() async {
  int id = await _globalChannel.invokeMethod("create");
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

  Future<void> setNetworkDataSource({String uri}) async {
    LogUtils.log("id = $textureId net uri = $uri");
    await channel.invokeMethod("setNetworkDataSource", {"uri": uri});
  }

  Future<void> setAssetDataSource(String name, String package) async {
    LogUtils.log("id = $textureId asset name = $name package = $package");
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
    LogUtils.log("id = $textureId file path = $path");
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

/// Entity classe for data sources.
class DataSource {
  /// See [DataSourceType]
  DataSourceType type;

  File _file;

  String _assetName;

  String _assetPackage;

  String _netWorkUrl;

  DataSource._();

  /// Create file datasource
  factory DataSource.file(File file) {
    var ds = DataSource._();
    ds._file = file;
    ds.type = DataSourceType.file;
    return ds;
  }

  /// Create network datasource
  factory DataSource.network(String url) {
    var ds = DataSource._();
    ds._netWorkUrl = url;
    ds.type = DataSourceType.file;
    return ds;
  }

  /// Create asset datasource
  factory DataSource.asset(String assetName, {String package}) {
    var ds = DataSource._();
    ds._assetName = assetName;
    ds._assetPackage = package;
    ds.type = DataSourceType.asset;
    return ds;
  }
}

enum DataSourceType {
  network,
  file,
  asset,
}
