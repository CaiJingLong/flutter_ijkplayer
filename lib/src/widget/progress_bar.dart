import 'package:flutter/material.dart';

class ProgressBar extends StatelessWidget {
  final double max;
  final double current;
  final double buffered;
  final Color backgroundColor;
  final Color bufferColor;
  final Color playedColor;

  const ProgressBar({
    Key key,
    @required this.max,
    @required this.current,
    this.buffered,
    this.backgroundColor = const Color(0xFF616161),
    this.bufferColor = Colors.grey,
    this.playedColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (max == null || current == null) return _buildEmpty();

    var left = current / max;
    var mid = (buffered ?? 0) / max - left;
    if (mid < 0) {
      mid = 0;
    }

    var right = 1 - left - mid;

    var progress = buildProgress(left, mid, right);
    return progress;
  }

  _buildEmpty() {
    return Container();
  }

  Widget buildProgress(double left, double mid, double right) {
    return Row(
      children: <Widget>[
        buildColorWidget(playedColor, left),
        buildColorWidget(bufferColor, mid),
        buildColorWidget(backgroundColor, right),
      ],
    );
  }

  Widget buildColorWidget(Color color, double flex) {
    if (flex == double.nan ||
        flex == double.infinity ||
        flex == double.negativeInfinity) {
      flex = 0;
    }
    return Expanded(
      flex: (flex * 1000).toInt(),
      child: Container(
        color: color,
      ),
    );
  }
}
