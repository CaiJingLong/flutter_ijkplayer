part of './ijkplayer.dart';

/// Media Controller
class IjkMediaController with IjkMediaControllerMixin {
  /// MediaController
  IjkMediaController({
    this.autoRotate = true,
  }) {
    index = IjkMediaPlayerManager().add(this);
  }

  int index;

  String get debugLabel => index.toString();

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
    if (value == true) {
      _ijkStatus = IjkStatus.playing;
    }
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

  VideoInfo _videoInfo = VideoInfo.fromMap(null);

  /// last update video info.
  VideoInfo get videoInfo => _videoInfo;

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

  /// playFinish
  StreamController<IjkMediaController> _playFinishController =
      StreamController.broadcast();

  /// On play finish
  Stream<IjkMediaController> get playFinishStream =>
      _playFinishController.stream;

  IjkStatus __ijkStatus = IjkStatus.noDataSource;

  IjkStatus get ijkStatus => __ijkStatus;

  set _ijkStatus(IjkStatus status) {
    __ijkStatus = status;
    _ijkStatusController?.add(status);
  }

  /// playFinish
  StreamController<IjkStatus> _ijkStatusController =
      StreamController.broadcast();

  /// On play finish
  Stream<IjkStatus> get ijkStatusStream => _ijkStatusController.stream;

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
      LogUtils.warning(e);
      LogUtils.warning("初始化失败");
    }
  }

  /// [reset] and close all controller
  void dispose() async {
    await reset();
    _playingController?.close();
    _videoInfoController?.close();
    _textureIdController?.close();
    _volumeController?.close();
    _playFinishController?.close();
    _ijkStatusController?.close();

    _playingController = null;
    _videoInfoController = null;
    _textureIdController = null;
    _volumeController = null;
    _playFinishController = null;
    _ijkStatusController = null;

    IjkMediaPlayerManager().remove(this);
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
    Map<String, String> headers = const {},
    bool autoPlay = false,
  }) async {
    _ijkStatus = IjkStatus.preparing;
    await _initDataSource(() async {
      await _plugin?.setNetworkDataSource(
        uri: url,
        headers: headers,
      );
      _ijkStatus = IjkStatus.prepared;
    }, autoPlay);
  }

  /// set asset DataSource
  Future<void> setAssetDataSource(
    String name, {
    String package,
    bool autoPlay = false,
  }) async {
    _ijkStatus = IjkStatus.preparing;
    await _initDataSource(() async {
      await _plugin?.setAssetDataSource(name, package);
      _ijkStatus = IjkStatus.prepared;
    }, autoPlay);
  }

  /// Set datasource with [DataSource]
  Future<void> setDataSource(
    DataSource source, {
    bool autoPlay = false,
  }) async {
    switch (source._type) {
      case DataSourceType.asset:
        await setAssetDataSource(
          source._assetName,
          package: source._assetPackage,
          autoPlay: autoPlay,
        );
        break;
      case DataSourceType.file:
        await setFileDataSource(
          source._file,
          autoPlay: autoPlay,
        );
        break;
      case DataSourceType.network:
        await setNetworkDataSource(
          source._netWorkUrl,
          headers: source._headers,
          autoPlay: autoPlay,
        );
        break;
      default:
    }
  }

  /// set file DataSource
  Future<void> setFileDataSource(
    File file, {
    bool autoPlay = false,
  }) async {
    _ijkStatus = IjkStatus.preparing;
    await _initDataSource(() async {
      await _plugin?.setFileDataSource(file.absolute.path);
      _ijkStatus = IjkStatus.prepared;
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
    Future playFuture = _autoPlay(autoPlay);
    await setDataSource();
    return playFuture;
  }

  /// Play or pause according to your current status
  Future<void> playOrPause({
    pauseOther = false,
  }) async {
    var videoInfo = await getVideoInfo();
    var playing = videoInfo.isPlaying;
    if (playing) {
      await pause();
    } else {
      await play(pauseOther: pauseOther);
    }
  }

  /// play media
  Future<void> play({
    pauseOther = false,
  }) async {
    if (pauseOther) {
      await pauseOtherController();
    }
    LogUtils.info("$this play");
    await _plugin?.play();
    refreshVideoInfo();
    _ijkStatus = IjkStatus.playing;
  }

  /// pause media
  Future<void> pause() async {
    LogUtils.info("$this pause");
    await _plugin?.pause();
    refreshVideoInfo();
    _ijkStatus = IjkStatus.pause;
  }

  /// seek to second
  ///
  /// [target] unit is second
  Future<void> seekTo(double target) async {
    await _plugin?.seekTo(target);
    refreshVideoInfo();
  }

  /// seek to progress
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
    _videoInfo = info;
    isPlaying = info.isPlaying;
    if (info.hasData) {
      _videoInfoController?.add(info);
      LogUtils.verbose("onrefreshInfo = $info");
    }
  }

  /// AutoPlay use
  Future<void> _autoPlay(bool autoPlay) async {
    if (autoPlay) {
      await eventChannel?.autoPlay(this);
    } else {
      await eventChannel?.disableAutoPlay(this);
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

  /// Pause all other players.
  Future<void> pauseOtherController() async {
    await IjkMediaPlayerManager().pauseOther(this);
  }

  @override
  String toString() {
    return "IJKController[$index]";
  }

  Future<void> hideSystemVolumeBar() async {
    await IjkManager.hideSystemVolumeBar();
  }

  void _onPlayFinish() {
    isPlaying = videoInfo.isPlaying;
    refreshVideoInfo();
    _playFinishController?.add(this);
    _ijkStatus = IjkStatus.complete;
  }

  /// Intercept the video frame image and get the `Uint8List` format.
  ///
  /// Player UI is not included. If you need the effect of the player, use the screenshot of the system.
  Future<Uint8List> screenShot() {
    return _plugin.screenShot();
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
}

/// Entity classe for data sources.
class DataSource {
  /// See [DataSourceType]
  DataSourceType _type;

  File _file;

  String _assetName;

  String _assetPackage;

  String _netWorkUrl;

  Map<String, String> _headers;

  DataSource._();

  /// Create file data source
  factory DataSource.file(File file) {
    var ds = DataSource._();
    ds._file = file;
    ds._type = DataSourceType.file;
    return ds;
  }

  /// Create network data source
  factory DataSource.network(String url,
      {Map<String, String> headers = const {}}) {
    var ds = DataSource._();
    ds._netWorkUrl = url;
    ds._headers = headers;
    ds._type = DataSourceType.network;
    return ds;
  }

  /// Create asset data source
  factory DataSource.asset(String assetName, {String package}) {
    var ds = DataSource._();
    ds._assetName = assetName;
    ds._assetPackage = package;
    ds._type = DataSourceType.asset;
    return ds;
  }
}

enum DataSourceType {
  network,
  file,
  asset,
}
