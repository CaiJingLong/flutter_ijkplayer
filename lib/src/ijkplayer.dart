import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ijkplayer/src/ijk_event_channel.dart';
import 'package:flutter_ijkplayer/src/video_info.dart';
import './error.dart';

import './controller_builder.dart';

part './controller.dart';

typedef Widget ControllerWidgetBuilder(IjkMediaController controller);

class IjkPlayer extends StatefulWidget {
  final IjkMediaController mediaController;
  final ControllerWidgetBuilder controllerWidgetBuilder;

  const IjkPlayer({
    Key key,
    this.mediaController,
    this.controllerWidgetBuilder = defaultBuildIjkControllerWidget,
  }) : super(key: key);

  @override
  IjkPlayerState createState() => IjkPlayerState();
}

class IjkPlayerState extends State<IjkPlayer> {
  IjkMediaController controller;

  @override
  void initState() {
    super.initState();
    controller = widget.mediaController ?? IjkMediaController();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var video = StreamBuilder<int>(
      stream: controller.textureIdStream,
      initialData: controller.textureId,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }
        return _buildVideoContent(snapshot.data);
      },
    );
    var controllerWidget = widget.controllerWidgetBuilder?.call(controller);
    return Stack(
      children: <Widget>[
        video,
        controllerWidget,
      ],
    );
  }

  Widget _buildVideoContent(int id) {
    if (id == null) {
      return Container(
        color: Colors.black,
      );
    }

    return Container(
      color: Colors.black,
      child: Texture(
        textureId: id,
      ),
    );
  }
}
