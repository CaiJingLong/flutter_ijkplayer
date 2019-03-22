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
    await todoOther(ijkMediaController, (ctl) {
      ctl.pause();
    });
  }

  Future<void> todoOther(
    IjkMediaController ijkMediaController,
    Future<void> todo(IjkMediaController ijkMediaController),
  ) async {
    for (var item in ijkPlayerList) {
      if (item != ijkMediaController) {
        await todo(item);
      }
    }
  }
}
