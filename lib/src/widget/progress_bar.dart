import 'package:flutter/material.dart';
import 'package:flutter_ijkplayer/src/helper/ui_helper.dart';

typedef ChangeProgressHandler(double progress);

typedef TapProgressHandler(double progress);

class ProgressBar extends StatefulWidget {
  final double max;
  final double current;
  final double buffered;
  final Color backgroundColor;
  final Color bufferColor;
  final Color playedColor;
  final ChangeProgressHandler changeProgressHandler;
  final TapProgressHandler tapProgressHandler;
  final double progressFlex;

  const ProgressBar({
    Key key,
    @required this.max,
    @required this.current,
    this.buffered,
    this.backgroundColor = const Color(0xFF616161),
    this.bufferColor = Colors.grey,
    this.playedColor = Colors.white,
    this.changeProgressHandler,
    this.tapProgressHandler,
    this.progressFlex = 0.6,
  }) : super(key: key);

  @override
  _ProgressBarState createState() => _ProgressBarState();
}

class _ProgressBarState extends State<ProgressBar> {
  GlobalKey _progressKey = GlobalKey();

  double tempLeft;

  double get left {
    var l = widget.current / widget.max;
    if (tempLeft != null) {
      return tempLeft;
    }
    return l;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.max == null || widget.current == null || widget.max == 0)
      return _buildEmpty();

    var mid = (widget.buffered ?? 0) / widget.max - left;
    if (mid < 0) {
      mid = 0;
    }

    var right = 1 - left - mid;

    Widget progress = buildProgress(left, mid, right);

    if (widget.changeProgressHandler != null &&
        widget.tapProgressHandler != null) {
      progress = GestureDetector(
        child: progress,
        behavior: HitTestBehavior.translucent,
        onPanUpdate: _onPanUpdate,
        onHorizontalDragUpdate: _onHorizontalDragUpdate,
        onHorizontalDragEnd: _onHorizontalDragEnd,
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
      );
    }

    return progress;
  }

  _buildEmpty() {
    return Container();
  }

  int get flex => (widget.progressFlex * 100).toInt();

  Widget buildProgress(double left, double mid, double right) {
    return Column(
      children: <Widget>[
        Flexible(child: Container(), flex: 100 - flex ~/ 2),
        Flexible(
          flex: flex,
          child: Row(
            key: _progressKey,
            children: <Widget>[
              buildColorWidget(widget.playedColor, left),
              buildColorWidget(widget.bufferColor, mid),
              buildColorWidget(widget.backgroundColor, right),
            ],
          ),
        ),
        Flexible(child: Container(), flex: 100 - flex ~/ 2),
      ],
    );
  }

  Widget buildColorWidget(Color color, double flex) {
    if (flex == double.nan ||
        flex == double.infinity ||
        flex == double.negativeInfinity) {
      flex = 0;
    }
    if (flex == 0) {
      return Container();
    }
    return Expanded(
      flex: (flex * 1000).toInt(),
      child: Container(
        color: color,
      ),
    );
  }

  void _onTapDown(TapDownDetails details) {
    var progress = getProgress(details.globalPosition);
    widget.tapProgressHandler(progress);
  }

  void _onPanUpdate(DragUpdateDetails details) {
    var progress = getProgress(details.globalPosition);
    widget.tapProgressHandler(progress);
  }

  void _onTapUp(TapUpDetails details) {
    var progress = getProgress(details.globalPosition);
    widget.changeProgressHandler(progress);
  }

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    var progress = getProgress(details.globalPosition);
    setState(() {
      tempLeft = progress;
    });
    widget.tapProgressHandler(progress);
  }

  double getProgress(Offset globalPosition) {
    var offset = _getLocalOffset(globalPosition);
    var globalRect = UIHelper.findGlobalRect(_progressKey);
    var progress = offset.dx / globalRect.width;
    if (progress > 1) {
      progress = 1;
    } else if (progress < 0) {
      progress = 0;
    }
    return progress;
  }

  Offset _getLocalOffset(Offset globalPosition) {
    return UIHelper.globalOffsetToLocal(
      _progressKey,
      globalPosition,
    );
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    if (tempLeft != null) {
      widget.changeProgressHandler(tempLeft);
      tempLeft = null;
    }
  }
}
