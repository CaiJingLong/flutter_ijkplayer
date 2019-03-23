import 'package:flutter_ijkplayer/src/ijkplayer.dart';
import 'package:flutter_ijkplayer/src/helper/logutil.dart';

class IjkMediaPlayerManager {
  var _currentIndex = 1;
  final ijkPlayerList = <IjkMediaController>[];
  final ijkPlayerMap = <int, IjkMediaController>{};

  static IjkMediaPlayerManager _instance;

  factory IjkMediaPlayerManager() {
    _instance ??= IjkMediaPlayerManager._();
    return _instance;
  }

  IjkMediaPlayerManager._();

  int add(IjkMediaController ijkMediaController) {
    ijkPlayerList.add(ijkMediaController);
    var result = _currentIndex;
    _currentIndex++;
    ijkPlayerMap[result] = ijkMediaController;
    return result;
  }

  void remove(IjkMediaController ijkMediaController) {
    ijkPlayerList.remove(ijkMediaController);
    ijkPlayerMap.remove(ijkMediaController.index);
  }

  IjkMediaController findControllerWithIndex(int ijkPlayerIndex) {
    return ijkPlayerMap[ijkPlayerIndex];
  }

  Future<void> pauseOther(IjkMediaController ijkMediaController) async {
    for (var ctl in this.ijkPlayerList) {
      if (ctl.index != ijkMediaController.index) {
        LogUtils.verbose("${ctl.textureId} controller will pause");
        ctl.pause();
      }
    }
  }
}
