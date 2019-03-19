import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_ijkplayer/flutter_ijkplayer.dart';
import 'package:flutter_ijkplayer/src/widget/progress_bar.dart';

class DefaultControllerWidget extends StatefulWidget {
  final IjkMediaController controller;
  final bool doubleTapPlay;

  const DefaultControllerWidget({
    this.controller,
    this.doubleTapPlay = false,
  });

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

  StreamSubscription controllerSubscription;

  @override
  void initState() {
    super.initState();
    startTimer();
    controllerSubscription = controller.textureIdStream.listen(_onTextIdChange);
  }

  void _onTextIdChange(int textId) {
    if (textId != null) {
      startTimer();
    } else {
      stopTimer();
    }
  }

  @override
  void deactivate() {
    super.deactivate();
    controllerSubscription.cancel();
    stopTimer();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void startTimer() {
    if (controller.textureId == null) {
      return;
    }

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
      onDoubleTap: widget.doubleTapPlay
          ? () {
              print("ondouble tap");
              controller.playOrPause();
            }
          : null,
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
        var info = snapshot.data;
        if (info == null || !info.hasData) {
          return Container();
        }
        return buildPortrait(info);
      },
    );
  }

  Widget buildPortrait(VideoInfo info) {
    return PortraitController(
      controller: controller,
      info: info,
    );
  }
}

String _getTimeText(double durationSecond) {
  var duration = Duration(milliseconds: ((durationSecond ?? 0) * 1000).toInt());
  var minute = (duration.inMinutes % 60).toString().padLeft(2, "0");
  var second = (duration.inSeconds % 60).toString().padLeft(2, "0");
  var text = "$minute:$second";
//  print("$durationSecond = $text");
  return text;
}

class PortraitController extends StatelessWidget {
  final IjkMediaController controller;
  final VideoInfo info;

  const PortraitController({
    Key key,
    this.controller,
    this.info,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!info.hasData) {
      return Container();
    }
    Widget bottomBar = buildBottomBar();
    return Column(
      children: <Widget>[
        Expanded(
          child: Container(),
        ),
        bottomBar,
      ],
    );
  }

  Widget buildBottomBar() {
    var currentTime = Text(
      _getTimeText(info.currentPosition),
    );
    var maxTime = Text(
      _getTimeText(info.duration),
    );
    var progress = buildProgress(info);
    Widget widget = Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: currentTime,
        ),
        Expanded(child: progress),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: maxTime,
        ),
      ],
    );
    widget = DefaultTextStyle(
      style: const TextStyle(
        color: Colors.white,
      ),
      child: widget,
    );
    widget = Container(
      color: Colors.black.withOpacity(0.12),
      child: widget,
    );
    return widget;
  }

  Widget buildProgress(VideoInfo info) {
    return Container(
      height: 5,
      child: ProgressBar(
        current: info.currentPosition,
        max: info.duration,
      ),
    );
  }
}
