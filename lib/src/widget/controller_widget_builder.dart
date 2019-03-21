import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_ijkplayer/flutter_ijkplayer.dart';
import 'package:flutter_ijkplayer/src/logutil.dart';
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

  /// The UI of the controller.
  const DefaultControllerWidget({
    @required this.controller,
    this.doubleTapPlay = false,
    this.verticalGesture = true,
    this.horizontalGesture = true,
    this.volumeType = VolumeType.system,
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
    LogUtils.log("onTextChange");
    if (textId != null) {
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
      LogUtils.log("will refresh info");
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
    );
  }

  OverlayEntry _tipOverlay;

  Widget createTipWidgetWrapper(Widget widget) {
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

  void showTipWidget(Widget widget) {
    hideTipWidget();
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

  void hideTipWidget() {
    _tipOverlay?.remove();
    _tipOverlay = null;
  }

  _ProgressCalculator _calculator;

  onTap() => isShow = !isShow;

  Function onDoubleTap() {
    return widget.doubleTapPlay
        ? () {
            LogUtils.log("ondouble tap");
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

    showTipWidget(createTipWidgetWrapper(w));
  }

  void _onHorizontalDragEnd(DragEndDetails details) async {
    hideTipWidget();
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

    showTipWidget(createTipWidgetWrapper(column));
  }

  void _onVerticalDragEnd(DragEndDetails details) {
    hideTipWidget();
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

String _getTimeText(double durationSecond) {
  var duration = Duration(milliseconds: ((durationSecond ?? 0) * 1000).toInt());
  var minute = (duration.inMinutes % 60).toString().padLeft(2, "0");
  var second = (duration.inSeconds % 60).toString().padLeft(2, "0");
  var text = "$minute:$second";
//  LogUtils.log("$durationSecond = $text");
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

    var playButton = buildPlayButton();

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
    return Container(
      height: 5,
      child: ProgressBar(
        current: info.currentPosition,
        max: info.duration,
      ),
    );
  }

  buildPlayButton() {
    return IconButton(
      onPressed: () {
        controller.playOrPause();
      },
      color: Colors.white,
      icon: Icon(info.isPlaying ? Icons.pause : Icons.play_arrow),
      iconSize: 25.0,
    );
  }
}

enum VolumeType {
  system,
  media,
}
