import 'package:flutter_ijkplayer/src/ijkplayer.dart';

class IjkMediaPlayerManager {
  final ijkPlayerList = <IjkMediaController>[];

  static IjkMediaPlayerManager _instance;

  factory IjkMediaPlayerManager() {
    _instance ??= IjkMediaPlayerManager._();
    return _instance;
  }

  IjkMediaPlayerManager._();

  void add(IjkMediaController ijkMediaController) {
    ijkPlayerList.add(ijkMediaController);
  }

  void remove(IjkMediaController ijkMediaController) {
    ijkPlayerList.remove(ijkMediaController);
  }

  Future<void> pauseOther(IjkMediaController ijkMediaController) async {
    for (var ctl in this.ijkPlayerList) {
      if (ctl != ijkMediaController) {
        print("ctl ${ctl.textureId} will pause");
        ctl.pause();
      }
    }
  }
}
