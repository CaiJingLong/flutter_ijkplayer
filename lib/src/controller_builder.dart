import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_ijkplayer/flutter_ijkplayer.dart';

Widget defaultBuildIjkControllerWidget(IjkMediaController controller) {
  return DefaultControllerWidget(controller);
}

class DefaultControllerWidget extends StatefulWidget {
  final IjkMediaController controller;

  const DefaultControllerWidget(this.controller);

  @override
  _DefaultControllerWidgetState createState() =>
      _DefaultControllerWidgetState();
}

class _DefaultControllerWidgetState extends State<DefaultControllerWidget> {
  IjkMediaController get controller => widget.controller;

  bool _isShow = true;

  set isShow(bool value) {
    _isShow = value;
    print("call show");
    setState(() {});
    if (value == true) {
      controller.refreshVideoInfo();
    }
  }

  bool get isShow => _isShow;

  Timer progressTimer;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    stopTimer();
    super.dispose();
  }

  void startTimer() {
    progressTimer = Timer.periodic(Duration(milliseconds: 400), (timer) {
      controller.refreshVideoInfo();
    });
  }

  void stopTimer() {
    progressTimer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      child: buildContent(),
      onDoubleTap: () {
        print("ondouble tap");
        controller.playOrPause();
      },
      onTap: () => isShow = !isShow,
    );
  }

  Widget buildContent() {
    if (!isShow) {
      return Container();
    }
    return StreamBuilder<VideoInfo>(
      stream: controller.videoInfoStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }
        var info = snapshot.data;
        return Container();
      },
    );
  }
}