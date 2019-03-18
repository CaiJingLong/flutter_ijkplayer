import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_ijkplayer/flutter_ijkplayer.dart';
import 'package:flutter_ijkplayer/src/widget/progress_bar.dart';

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
    progressTimer?.cancel();
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
      behavior: HitTestBehavior.opaque,
      child: buildContent(),
      onDoubleTap: () {
        print("ondouble tap");
        controller.playOrPause();
      },
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
        return Column(
          children: <Widget>[
            Expanded(
              child: Container(),
            ),
            buildProgress(info),
          ],
        );
      },
    );
  }

  Container buildProgress(VideoInfo info) {
    return Container(
      height: 5,
      child: ProgressBar(
        current: info.currentPosition,
        max: info.duration,
      ),
    );
  }
}
