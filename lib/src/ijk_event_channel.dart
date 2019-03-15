import 'package:flutter/services.dart';
import 'package:flutter_ijkplayer/src/video_info.dart';

import './ijkplayer.dart';

class IJKEventChannel {
  int get textureId => controller?.textureId;

  IjkMediaController controller;

  IJKEventChannel(this.controller);

  MethodChannel channel;

  String get channelName => "top.kikt/ijkplayer/event/$textureId";

  Future<void> init() async {
    channel = MethodChannel(channelName);
    channel.setMethodCallHandler(handler);
  }

  void dispose() {
    channel.setMethodCallHandler(null);
    controller = null;
  }

  Future<dynamic> handler(MethodCall call) async {
    switch (call.method) {
      case "finish": // 对应状态变化
        var index = call.arguments["type"];
        var type = FinishType.values[index];
        onPlayFinish(type);
        break;
      case "playStateChange":
        onPlayStateChange(getInfo(call));
        break;
      case "prepare":
        onPrepare(getInfo(call));
        break;
      default:
        return MissingPluginException(
          "$channelName ${call.method} not implement",
        );
    }
  }

  VideoInfo getInfo(MethodCall call) {
    var map = call.arguments.cast<String, dynamic>();
    return VideoInfo.fromMap(map);
  }

  void onPlayFinish(FinishType type) {
    print("onPlayFinish type = $type");
  }

  void onPlayStateChange(VideoInfo info) {
    print("onPlayStateChange $info");
    controller.isPlaying = info.isPlaying;
  }

  void onPrepare(VideoInfo info) {
    print("onPrepare $info");
  }
}

enum FinishType {
  playEnd,
  userExit,
  error,
}
