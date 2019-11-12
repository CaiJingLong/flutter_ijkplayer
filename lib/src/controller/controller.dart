part of '../ijkplayer.dart';

/// Media Controller
class IjkMediaController
    with IjkMediaControllerMixin, IjkMediaControllerStreamMixin {
  /// It will automatically correct the direction of the video.
  bool autoRotate;

  int index;

  String get debugLabel => index.toString();

  Map<TargetPlatform, Set<IjkOption>> _options = {};

  bool needChangeSpeed;

  /// MediaController
  IjkMediaController({
    this.autoRotate = true,
    this.needChangeSpeed = true,
  }) {
    index = IjkMediaPlayerManager().add(this);
    if (needChangeSpeed) {
      setIjkPlayerOptions(
          [
            TargetPlatform.iOS,
            TargetPlatform.android,
          ],
          <IjkOption>[
            IjkOption(IjkOptionCategory.player, "soundtouch", 1),
          ].toSet());
    }
  }

  @override
  set _ijkStatus(IjkStatus status) {
    if (__ijkStatus == IjkStatus.disposed) {
      dispose(false);
      return;
    }
    super._ijkStatus = status;
  }

  /// create ijk texture id from native
  Future<void> _initIjk() async {
    try {
      List<IjkOption> options = [];
      if (Platform.isAndroid) {
        var opt = _options[TargetPlatform.android] ?? Set();
        options.addAll(opt);
      } else {
        var opt = _options[TargetPlatform.iOS] ?? Set();
        options.addAll(opt);
      }

      print("options = $options");

      var id = await _createIjk(options: options);
      this.textureId = id;
      _plugin = _IjkPlugin(id);
      eventChannel = _IJKEventChannel(this);
      await eventChannel.init();
      volume = 100;
    } catch (e) {
      await reset();
      LogUtils.warning(e);
      LogUtils.warning("初始化失败");
    }
  }

  /// [reset] and close all controller
  void dispose([changeStatus = true]) async {
    _isDispose = true;
    await reset(changeStatus);
    await _disposeStream(changeStatus);

    IjkMediaPlayerManager().remove(this);
  }

  /// dispose all resource
  Future<void> reset([changeStatus = true]) async {
    volume = 100;
    this.textureId = null;
    _plugin?.dispose();
    _plugin = null;
    eventChannel?.dispose();
    eventChannel = null;
    if (changeStatus) _ijkStatus = IjkStatus.noDatasource;
  }

  /// set net DataSource
  ///
  /// see [setDataSource]
  Future<void> setNetworkDataSource(
    String url, {
    Map<String, String> headers = const {},
    bool autoPlay = false,
  }) async {
    _ijkStatus = IjkStatus.preparing;
    await _initDataSource(autoPlay);
    await _plugin?.setNetworkDataSource(
      uri: url,
      headers: headers,
    );
    _ijkStatus = IjkStatus.prepared;
  }

  /// set asset DataSource
  ///
  /// see [setDataSource]
  Future<void> setAssetDataSource(
    String name, {
    String package,
    bool autoPlay = false,
  }) async {
    _ijkStatus = IjkStatus.preparing;
    await _initDataSource(autoPlay);
    await _plugin?.setAssetDataSource(name, package);
    _ijkStatus = IjkStatus.prepared;
  }

  /// set file DataSource
  ///
  /// see [setDataSource]
  Future<void> setFileDataSource(
    File file, {
    bool autoPlay = false,
  }) async {
    _ijkStatus = IjkStatus.preparing;
    await _initDataSource(autoPlay);
    await _plugin?.setFileDataSource(file.absolute.path);
    _ijkStatus = IjkStatus.prepared;
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

  void setAutoPlay() {
    this.addIjkPlayerOptions([
      TargetPlatform.android,
      TargetPlatform.iOS,
    ], [
      IjkOption(IjkOptionCategory.player, "start-on-prepared", 0),
    ]);
  }

  /// dispose last textureId resource
  Future<void> _initDataSource(bool autoPlay) async {
    autoPlay ??= false;

    var autoPlayValue = autoPlay ? 1 : 0;
    addIjkPlayerOptions([
      TargetPlatform.android,
      TargetPlatform.iOS,
    ], [
      IjkOption(IjkOptionCategory.player, "start-on-prepared", autoPlayValue),
    ]);

    if (this.textureId != null) {
      await _plugin?.dispose();
    }
    await _initIjk();
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

  void _onError(int errorValueInt) async {
    _playFinishController?.add(this);
    _ijkStatus = IjkStatus.error;
    _ijkErrorController?.add(errorValueInt);
  }

  /// Intercept the video frame image and get the `Uint8List` format.
  ///
  /// Player UI is not included. If you need the effect of the player, use the screenshot of the system.
  Future<Uint8List> screenShot() {
    return _plugin.screenShot();
  }

  /// Set [IjkOption] with IJKPlayer.
  ///
  /// It will only take effect if you call [setDataSource] again.
  void setIjkPlayerOptions(
    List<TargetPlatform> platforms,
    Iterable<IjkOption> options,
  ) {
    for (var platform in platforms) {
      _options[platform] = options.toSet();
    }
  }

  /// Add [IjkOption] with IJKPlayer in native
  ///
  /// see [setIjkPlayerOptions]
  void addIjkPlayerOptions(
    List<TargetPlatform> platforms,
    Iterable<IjkOption> options,
  ) {
    for (var platform in platforms) {
      var opts = _options[platform];
      if (opts == null) {
        opts = Set();
        _options[platform] = opts;
      }
      opts.addAll(options);
    }
  }

  Future<void> setSpeed(double speed) async {
    await _plugin.setSpeed(speed);
  }
}
