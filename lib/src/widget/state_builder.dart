import 'package:flutter/material.dart';
import 'package:flutter_ijkplayer/flutter_ijkplayer.dart';

Widget defaultBuildStateWidget(IjkMediaController controller) {
  return IjkStateWidget(controller);
}

class IjkStateWidget extends StatelessWidget {
  final IjkMediaController controller;

  const IjkStateWidget(this.controller);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

enum IjkStatus {
  noDataSource,
  preparing,
  prepared,
  pause,
  playing,
  complete,
}
