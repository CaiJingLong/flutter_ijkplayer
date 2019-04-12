part of '../ijkplayer.dart';

/// Media Controller
class IjkMediaController
    with IjkMediaControllerMixin, IjkMediaControllerStreamMixin {
  /// It will automatically correct the direction of the video.
  bool autoRotate;

  int index;

  String get debugLabel => index.toString();

  Map<TargetPlatform, List<IjkOption>> _options = {};

  /// MediaController
  IjkMediaController({
    this.autoRotate = true,
  }) {
    index = IjkMediaPlayerManager().add(this);
  }

  /// create ijk texture id from native
  Future<void> _initIjk() async {
    try {
      List<IjkOption> options = [];
      if (Platform.isAndroid) {
        var opt = _options[TargetPlatform.android] ?? [];
        options.addAll(opt);
      } else {
        var opt = _options[TargetPlatform.iOS] ?? [];
        options.addAll(opt);
      }

      var id = await _createIjk(options: options);
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
    await _disposeStream();

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
    _ijkStatus = IjkStatus.noDatasource;
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
    _ijkStatus = IjkStatus.pause;
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

  void setIjkPlayerOptions(TargetPlatform platform, List<IjkOption> options) {
    _options[platform] = options;
  }
}
