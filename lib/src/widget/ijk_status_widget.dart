import 'package:flutter/cupertino.dart';
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
    var statusBuilder =
        this.statusWidgetBuilder ?? IjkStatusWidget.buildStatusWidget;
    return StreamBuilder<IjkStatus>(
      initialData: controller.ijkStatus,
      stream: controller.ijkStatusStream,
      builder: (BuildContext context, snapshot) {
        return statusBuilder.call(context, controller, snapshot.data);
      },
    );
  }

  static Widget buildStatusWidget(
    BuildContext context,
    IjkMediaController controller,
    IjkStatus status,
  ) {
    if (status == IjkStatus.noDatasource) {
      return _buildNothing(context);
    }

    if (status == IjkStatus.preparing) {
      return _buildProgressWidget(context);
    }
    if (status == IjkStatus.prepared) {
      return _buildPreparedWidget(context, controller);
    }
    if (status == IjkStatus.error) {
      return _buildFailWidget(context);
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

  static Widget _buildPreparedWidget(
    BuildContext context,
    IjkMediaController controller,
  ) {
    return _buildCenterIconButton(Icons.play_arrow, controller.play);
  }
}

Widget _buildNothing(BuildContext context) {
  return Center(
    child: Text(
      "",
      style: TextStyle(color: Colors.white),
    ),
  );
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

Widget _buildFailWidget(BuildContext context) {
  return Center(
    child: Icon(
      Icons.error,
      color: Colors.white,
      size: 44,
    ),
  );
}
