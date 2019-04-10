import 'package:flutter/material.dart';
import 'package:flutter_ijkplayer/flutter_ijkplayer.dart';

/// Construct a Widget based on the current status.
typedef Widget StatusWidgetBuilder(
  BuildContext context,
  IjkMediaController controller,
  IjkStatus status,
);

/// Default IjkStatusWidget
class IjkStatusWidget extends StatelessWidget {
  final IjkMediaController controller;
  final StatusWidgetBuilder statusWidgetBuilder;

  const IjkStatusWidget({
    this.controller,
    this.statusWidgetBuilder = IjkStatusWidget.buildStatusWidget,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<IjkStatus>(
      initialData: controller.ijkStatus,
      stream: controller.ijkStatusStream,
      builder: (BuildContext context, snapshot) {
        return buildStatusWidget(context, controller, snapshot.data);
      },
    );
  }

  static Widget defaultBuildStateWidget(IjkMediaController controller) {
    return IjkStatusWidget(
      controller: controller,
    );
  }

  static Widget buildStatusWidget(
    BuildContext context,
    IjkMediaController controller,
    IjkStatus status,
  ) {
    if (status == IjkStatus.preparing || status == IjkStatus.noDataSource) {
      return _buildProgressWidget(context);
    }
    if (status == IjkStatus.pause) {
      return _buildCenterIconButton(Icons.play_arrow, controller.play);
    }
    if (status == IjkStatus.complete) {
      return _buildCenterIconButton(Icons.replay, () async {
        await controller?.seekTo(0);
        await controller?.play();
      });
    }
    return Container();
  }
}

Widget _buildCenterIconButton(IconData iconData, Function onTap) {
  return Center(
    child: Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.75),
        borderRadius: BorderRadius.circular(30),
      ),
      child: IconButton(
        iconSize: 30,
        color: Colors.black,
        icon: Icon(iconData),
        onPressed: onTap,
      ),
    ),
  );
}

Widget _buildProgressWidget(BuildContext context) {
  return Center(
    child: Container(
      width: 60,
      height: 60,
      child: RefreshProgressIndicator(
        backgroundColor: Colors.transparent,
        valueColor: AlwaysStoppedAnimation(Colors.white),
      ),
    ),
  );
}
