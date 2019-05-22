part of '../ijkplayer.dart';

mixin IjkMediaControllerMixin {
  List<GlobalKey> _keys = [];

  attach(GlobalKey key) {
    LogUtils.info("IjkMediaControllerMixin attach $key");
    _keys.add(key);
  }

  detach(GlobalKey key) {
    LogUtils.info("IjkMediaControllerMixin detach $key");
    _keys.remove(key);
  }
}

mixin IjkMediaControllerStreamMixin {
  var _isDispose = false;

  /// texture id from native
  int _textureId;

  /// texture id from native
  int get textureId => _textureId;

  /// set texture id, Normally the user does not call
  set textureId(int id) {
    if (_isDispose) return;
    _textureId = id;
    _textureIdController?.add(id);
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
    if (_isDispose) return;
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
    if (_isDispose) return;
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

  IjkStatus __ijkStatus = IjkStatus.noDatasource;

  IjkStatus get ijkStatus => __ijkStatus;

  set _ijkStatus(IjkStatus status) {
    if (status != __ijkStatus) {
      __ijkStatus = status;
      _ijkStatusController?.add(status);
    } else {
      __ijkStatus = status;
    }
  }

  /// playFinish
  StreamController<IjkStatus> _ijkStatusController =
      StreamController.broadcast();

  /// On play finish
  Stream<IjkStatus> get ijkStatusStream => _ijkStatusController.stream;

  /// errorStream
  StreamController<int> _ijkErrorController = StreamController.broadcast();

  /// # On Error stream
  ///
  /// In iOS, this value is zero for a lot of time.
  ///
  /// see [bilibili-doc](https://github.com/bilibili/ijkplayer/blob/cced91e3ae3730f5c63f3605b00d25eafcf5b97b/ios/IJKMediaPlayer/IJKMediaPlayer/IJKFFMoviePlayerController.m#L1025-L1041)
  ///
  /// ----
  ///
  /// In android, see next document.
  ///
  /// Code value see [bilibili-doc](https://github.com/bilibili/ijkplayer/blob/cced91e3ae3730f5c63f3605b00d25eafcf5b97b/ijkmedia/ijkplayer/android/ijkplayer_android_def.h#L48-L83)
  ///
  /// ## Next is the part code
  ///
  /// Generic error codes for the media player framework.  Errors are fatal, the
  /// playback must abort.
  ///
  /// Errors are communicated back to the client using the
  /// MediaPlayerListener::notify method defined below.
  ///
  /// ### In this situation, 'notify' is invoked with the following:
  ///
  ///  - 'msg' is set to MEDIA_ERROR.
  ///  - 'ext1' should be a value from the enum media_error_type.
  ///  - 'ext2' contains an implementation dependant error code to provide
  ///          more details. Should default to 0 when not used.
  ///
  /// ### The codes are distributed as follow:
  ///
  ///  - 0xx: Reserved
  ///  - 1xx: Android Player errors. Something went wrong inside the MediaPlayer.
  ///  - 2xx: Media errors (e.g Codec not supported). There is a problem with the
  ///        media itself.
  ///  - 3xx: Runtime errors. Some extraordinary condition arose making the playback
  ///        impossible.
  ///
  /// ```c
  ///
  /// enum media_error_type {
  ///    // 0xx
  ///    MEDIA_ERROR_UNKNOWN = 1,
  ///    // 1xx
  ///    MEDIA_ERROR_SERVER_DIED = 100,
  ///    // 2xx
  ///    MEDIA_ERROR_NOT_VALID_FOR_PROGRESSIVE_PLAYBACK = 200,
  ///    // 3xx
  ///
  ///
  ///    // -xx
  ///    MEDIA_ERROR_IO          = -1004,
  ///    MEDIA_ERROR_MALFORMED   = -1007,
  ///    MEDIA_ERROR_UNSUPPORTED = -1010,
  ///    MEDIA_ERROR_TIMED_OUT   = -110,
  ///
  ///
  ///    MEDIA_ERROR_IJK_PLAYER  = -10000,
  /// };
  ///
  /// ```
  Stream<int> get ijkErrorStream => _ijkErrorController.stream;

  void _setVolume(int value);

  Future<void> _disposeStream([changeStatus = true]) async {
    if (changeStatus) _ijkStatus = IjkStatus.disposed;
    _playingController?.close();
    _videoInfoController?.close();
    _textureIdController?.close();
    _volumeController?.close();
    _playFinishController?.close();
    _ijkStatusController?.close();
    _ijkErrorController?.close();

    _playingController = null;
    _videoInfoController = null;
    _textureIdController = null;
    _volumeController = null;
    _playFinishController = null;
    _ijkStatusController = null;
    _ijkErrorController = null;
  }
}
