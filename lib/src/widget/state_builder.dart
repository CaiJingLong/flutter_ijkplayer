import 'package:flutter/material.dart';
import 'package:flutter_ijkplayer/flutter_ijkplayer.dart';

typedef Widget StatusWidgetBuilder(
  IjkMediaController controller,
  IjkStatus status,
);

class IjkStateWidget extends StatelessWidget {
  final IjkMediaController controller;
  final StatusWidgetBuilder statusWidgetBuilder;

  const IjkStateWidget({
    this.controller,
    this.statusWidgetBuilder = IjkStateWidget.buildStatusWidget,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<IjkStatus>(
      initialData: controller.ijkStatus,
      stream: controller.ijkStatusStream,
      builder: (BuildContext context, snapshot) {
        return buildStatusWidget(controller, snapshot.data);
      },
    );
  }

  static Widget defaultBuildStateWidget(IjkMediaController controller) {
    return IjkStateWidget(
      controller: controller,
    );
  }

  static Widget buildStatusWidget(
    IjkMediaController controller,
    IjkStatus status,
  ) {
    if (status == IjkStatus.pause) {
      return Center(
        child: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
          ),
          child: IconButton(
            iconSize: 30,
            color: Colors.black,
            icon: Icon(Icons.play_arrow),
            onPressed: () => controller.play(),
          ),
        ),
      );
    }
    if (status == IjkStatus.complete) {
      return Center(
        child: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
          ),
          child: IconButton(
            iconSize: 30,
            color: Colors.black,
            icon: Icon(Icons.replay),
            onPressed: () async {
              await controller?.seekTo(0);
              await controller?.play();
            },
          ),
        ),
      );
    }
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
