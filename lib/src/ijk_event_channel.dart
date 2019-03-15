import 'package:flutter/services.dart';

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
      case "stateChange": // 对应状态变化
        break;
      default:
        return MissingPluginException(
          "$channelName ${call.method} not implement",
        );
    }
  }
}
