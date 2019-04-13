part of '../ijkplayer.dart';

mixin IjkMediaControllerMixin {
  List<GlobalKey> _keys = [];

  attach(GlobalKey key) {
    print("IjkMediaControllerMixin attach $key");
    _keys.add(key);
  }

  detach(GlobalKey key) {
    print("IjkMediaControllerMixin detach $key");
    _keys.remove(key);
  }
}

mixin IjkMediaControllerStreamMixin {
  /// texture id from native
  int _textureId;

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

  void _setVolume(int value);

  Future<void> _disposeStream() async {
    _ijkStatus = IjkStatus.disposed;
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
  }
}
