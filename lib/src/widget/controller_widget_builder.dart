import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ijkplayer/flutter_ijkplayer.dart';
import 'package:flutter_ijkplayer/src/helper/time_helper.dart';
import 'package:flutter_ijkplayer/src/helper/logutil.dart';
import 'package:flutter_ijkplayer/src/widget/progress_bar.dart';

/// Using mediaController to Construct a Controller UI
typedef Widget ControllerWidgetBuilder(IjkMediaController controller);

/// default create IJK Controller UI
Widget defaultBuildIjkControllerWidget(IjkMediaController controller) {
  return DefaultControllerWidget(
    controller: controller,
//    verticalGesture: false,
//    horizontalGesture: false,
  );
}

/// Default Controller Widget
///
/// see [IjkPlayer] and [ControllerWidgetBuilder]
class DefaultControllerWidget extends StatefulWidget {
  final IjkMediaController controller;

  /// If [doubleTapPlay] is true, can double tap to play or pause media.
  final bool doubleTapPlay;

  /// If [verticalGesture] is false, vertical gesture will be ignored.
  final bool verticalGesture;

  /// If [horizontalGesture] is false, horizontal gesture will be ignored.
  final bool horizontalGesture;

  /// Controlling [verticalGesture] is controlling system volume or media volume.
  final VolumeType volumeType;

  final bool playWillPauseOther;

  /// The UI of the controller.
  const DefaultControllerWidget({
    @required this.controller,
    this.doubleTapPlay = false,
    this.verticalGesture = true,
    this.horizontalGesture = true,
    this.volumeType = VolumeType.system,
    this.playWillPauseOther = true,
  });

  @override
  _DefaultControllerWidgetState createState() =>
      _DefaultControllerWidgetState();
}

class _DefaultControllerWidgetState extends State<DefaultControllerWidget>
    implements TooltipDelegate {
  IjkMediaController get controller => widget.controller;

  bool _isShow = true;

  set isShow(bool value) {
    _isShow = value;
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
    controllerSubscription =
        controller.textureIdStream.listen(_onTextureIdChange);
  }

  void _onTextureIdChange(int textureId) {
    LogUtils.debug("onTextureChange $textureId");
    if (textureId != null) {
      startTimer();
    } else {
      stopTimer();
    }
  }

  @override
  void deactivate() {
    super.deactivate();
  }

  @override
  void dispose() {
    controllerSubscription.cancel();
    stopTimer();
    super.dispose();
  }

  void startTimer() {
    if (controller.textureId == null) {
      return;
    }

    progressTimer?.cancel();
    progressTimer = Timer.periodic(Duration(milliseconds: 400), (timer) {
      LogUtils.verbose("timer will call refresh info");
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
      onDoubleTap: onDoubleTap(),
      onHorizontalDragStart: wrapHorizontalGesture(_onHorizontalDragStart),
      onHorizontalDragUpdate: wrapHorizontalGesture(_onHorizontalDragUpdate),
      onHorizontalDragEnd: wrapHorizontalGesture(_onHorizontalDragEnd),
      onVerticalDragStart: wrapVerticalGesture(_onVerticalDragStart),
      onVerticalDragUpdate: wrapVerticalGesture(_onVerticalDragUpdate),
      onVerticalDragEnd: wrapVerticalGesture(_onVerticalDragEnd),
      onTap: onTap,
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
      tooltipDelegate: this,
      playWillPauseOther: widget.playWillPauseOther,
    );
  }

  OverlayEntry _tipOverlay;

  Widget createTooltipWidgetWrapper(Widget widget) {
    var typography = Typography(platform: TargetPlatform.android);
    var theme = typography.white;
    const style = const TextStyle(
      fontSize: 15.0,
      color: Colors.white,
      fontWeight: FontWeight.normal,
    );
    var mergedTextStyle = theme.body2.merge(style);
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5),
        borderRadius: BorderRadius.circular(20.0),
      ),
      height: 100.0,
      width: 100.0,
      child: DefaultTextStyle(
        child: widget,
        style: mergedTextStyle,
      ),
    );
  }

  void showTooltip(Widget widget) {
    hideTooltip();
    _tipOverlay = OverlayEntry(
      builder: (BuildContext context) {
        return IgnorePointer(
          child: Center(
            child: widget,
          ),
        );
      },
    );
    Overlay.of(context).insert(_tipOverlay);
  }

  void hideTooltip() {
    _tipOverlay?.remove();
    _tipOverlay = null;
  }

  _ProgressCalculator _calculator;

  onTap() => isShow = !isShow;

  Function onDoubleTap() {
    return widget.doubleTapPlay
        ? () {
            LogUtils.debug("ondouble tap");
            controller.playOrPause();
          }
        : null;
  }

  Function wrapHorizontalGesture(Function function) =>
      widget.horizontalGesture == true ? function : null;

  Function wrapVerticalGesture(Function function) =>
      widget.verticalGesture == true ? function : null;

  void _onHorizontalDragStart(DragStartDetails details) async {
    var videoInfo = await controller.getVideoInfo();
    _calculator = _ProgressCalculator(details, videoInfo);
  }

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    if (_calculator == null || details == null) {
      return;
    }
    var updateText = _calculator.calcUpdate(details);

    var offsetPosition = _calculator.getOffsetPosition();

    IconData iconData =
        offsetPosition > 0 ? Icons.fast_forward : Icons.fast_rewind;
    var w = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(
          iconData,
          color: Colors.white,
          size: 40.0,
        ),
        Text(
          updateText,
          textAlign: TextAlign.center,
        ),
      ],
    );

    showTooltip(createTooltipWidgetWrapper(w));
  }

  void _onHorizontalDragEnd(DragEndDetails details) async {
    hideTooltip();
    var targetSeek = _calculator.getTargetSeek(details);
    _calculator = null;
    await controller.seekTo(targetSeek);
    var videoInfo = await controller.getVideoInfo();
    if (targetSeek < videoInfo.duration) await controller.play();
  }

  void _onVerticalDragStart(DragStartDetails details) {}

  void _onVerticalDragUpdate(DragUpdateDetails details) async {
    if (details.delta.dy > 0) {
      volumeDown();
    } else if (details.delta.dy < 0) {
      volumeUp();
    }

    if (widget.volumeType == VolumeType.system && !Platform.isAndroid) {
      return;
    }

    var currentVolume = await getVolume();

    var column = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(
          Icons.volume_up,
          color: Colors.white,
          size: 25.0,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Text(currentVolume.toString()),
        ),
      ],
    );

    showTooltip(createTooltipWidgetWrapper(column));
  }

  void _onVerticalDragEnd(DragEndDetails details) {
    hideTooltip();

    Future.delayed(Duration(seconds: 2), () {
      hideTooltip();
    });
  }

  Future<int> getVolume() async {
    switch (widget.volumeType) {
      case VolumeType.media:
        return controller.volume;
      case VolumeType.system:
        return controller.getSystemVolume();
    }
    return 0;
  }

  Future<void> volumeUp() async {
    var volume = await getVolume();
    volume++;
    switch (widget.volumeType) {
      case VolumeType.media:
        controller.volume = volume;
        break;
      case VolumeType.system:
        await IjkManager.systemVolumeUp();
        break;
    }
  }

  Future<void> volumeDown() async {
    var volume = await getVolume();
    volume--;
    switch (widget.volumeType) {
      case VolumeType.media:
        controller.volume = volume;
        break;
      case VolumeType.system:
        await IjkManager.systemVolumeDown();
        break;
    }
  }
}

class _ProgressCalculator {
  DragStartDetails startDetails;
  VideoInfo info;

  double dx;

  _ProgressCalculator(this.startDetails, this.info);

  String calcUpdate(DragUpdateDetails details) {
    dx = details.globalPosition.dx - startDetails.globalPosition.dx;
    var f = dx > 0 ? "+" : "-";
    var offset = getOffsetPosition().round().abs();
    return "$f${offset}s";
  }

  double getTargetSeek(DragEndDetails details) {
    var target = info.currentPosition + getOffsetPosition();
    if (target < 0) {
      target = 0;
    } else if (target > info.duration) {
      target = info.duration;
    }
    return target;
  }

  double getOffsetPosition() {
    return dx / 10;
  }
}

class PortraitController extends StatelessWidget {
  final IjkMediaController controller;
  final VideoInfo info;
  final TooltipDelegate tooltipDelegate;
  final bool playWillPauseOther;

  const PortraitController({
    Key key,
    this.controller,
    this.info,
    this.tooltipDelegate,
    this.playWillPauseOther = true,
  }) : super(key: key);

  bool get haveTime {
    return info.hasData && info.duration > 0;
  }

  @override
  Widget build(BuildContext context) {
    if (!info.hasData) {
      return Container();
    }
    Widget bottomBar = buildBottomBar(context);
    return Column(
      children: <Widget>[
        Expanded(
          child: Container(),
        ),
        bottomBar,
      ],
    );
  }

  Widget buildBottomBar(BuildContext context) {
    var currentTime = buildCurrentText();
    var maxTime = buildMaxTimeText();
    var progress = buildProgress(info);

    var playButton = buildPlayButton(context);

    Widget widget = Row(
      children: <Widget>[
        playButton,
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
    if (!info.hasData || info.duration == 0) {
      return Container();
    }
    return Container(
      height: 22,
      child: ProgressBar(
        current: info.currentPosition,
        max: info.duration,
        changeProgressHandler: (progress) async {
          await controller.seekToProgress(progress);
          tooltipDelegate?.hideTooltip();
        },
        tapProgressHandler: (progress) {
          showProgressTooltip(info, progress);
        },
      ),
    );
  }

  buildCurrentText() {
    return haveTime
        ? Text(
            TimeHelper.getTimeText(info.currentPosition),
          )
        : Container();
  }

  buildMaxTimeText() {
    return haveTime
        ? Text(
            TimeHelper.getTimeText(info.duration),
          )
        : Container();
  }

  buildPlayButton(BuildContext context) {
    return IconButton(
      onPressed: () {
        controller.playOrPause(pauseOther: playWillPauseOther);
      },
      color: Colors.white,
      icon: Icon(info.isPlaying ? Icons.pause : Icons.play_arrow),
      iconSize: 25.0,
    );
  }

  void showProgressTooltip(VideoInfo info, double progress) {
    var target = info.duration * progress;

    var diff = info.currentPosition - target;

    String diffString;
    if (diff < 1 && diff > -1) {
      diffString = "0s";
    } else if (diff < 0) {
      diffString = "+${TimeHelper.getTimeText(diff.abs())}";
    } else if (diff > 0) {
      diffString = "-${TimeHelper.getTimeText(diff.abs())}";
    } else {
      diffString = "0s";
    }

    Widget text = Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            TimeHelper.getTimeText(target),
            style: TextStyle(fontSize: 20),
          ),
          Container(
            height: 10,
          ),
          Text(diffString),
        ],
      ),
    );

    var tooltip = tooltipDelegate?.createTooltipWidgetWrapper(text);
    tooltipDelegate?.showTooltip(tooltip);
  }
}

abstract class TooltipDelegate {
  void showTooltip(Widget widget);

  Widget createTooltipWidgetWrapper(Widget widget);

  void hideTooltip();
}

enum VolumeType {
  system,
  media,
}
