import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ijkplayer/src/ijk_event_channel.dart';
import 'package:flutter_ijkplayer/src/video_info.dart';
import 'package:flutter_ijkplayer/src/widget/ijkplayer_builder.dart';

import './controller_builder.dart';
import './error.dart';

part './controller.dart';

part './manager.dart';

typedef Widget ControllerWidgetBuilder(IjkMediaController controller);

class IjkPlayer extends StatefulWidget {
  final IjkMediaController mediaController;
  final ControllerWidgetBuilder controllerWidgetBuilder;
  final PlayerBuilder playerBuilder;

  const IjkPlayer({
    Key key,
    this.mediaController,
    this.controllerWidgetBuilder = defaultBuildIjkControllerWidget,
    this.playerBuilder = buildDefaultIjkPlayer,
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
  void didUpdateWidget(IjkPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
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
        var id = snapshot.data;
        return StreamBuilder<VideoInfo>(
            stream: controller.videoInfoStream,
            builder: (context, videoInfoSnapShot) {
              return _buildTexture(id, videoInfoSnapShot.data);
            });
      },
    );
    var controllerWidget = widget.controllerWidgetBuilder?.call(controller);
    return Stack(
      children: <Widget>[
        IgnorePointer(child: video),
        controllerWidget,
      ],
    );
  }

  Widget _buildTexture(int id, VideoInfo info) {
    if (widget?.playerBuilder != null) {
      return widget.playerBuilder.call(context, controller, info);
    }

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
