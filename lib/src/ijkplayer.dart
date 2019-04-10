import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'controller/ijkplayer_controller_mixin.dart';
import 'entity/video_info.dart';
import 'engine/ijk_controller_manager.dart';
import 'error.dart';
import 'helper/logutil.dart';
import 'widget/controller_widget_builder.dart';
import 'widget/ijkplayer_builder.dart';
import 'widget/ijk_status_widget.dart';

part 'controller/controller.dart';
part 'controller/enums.dart';
part 'controller/ijk_event_channel.dart';
part 'engine/manager.dart';

typedef Widget IjkStateWidgetBuilder(IjkMediaController controller);

/// Main Classes of Library
class IjkPlayer extends StatefulWidget {
  final IjkMediaController mediaController;

  /// See [DefaultIJKControllerWidget]
  final IJKControllerWidgetBuilder controllerWidgetBuilder;

  /// See [buildDefaultIjkPlayer]
  final IJKTextureBuilder textureBuilder;

  final IjkStateWidgetBuilder stateWidgetBuilder;

  /// Main Classes of Library
  const IjkPlayer({
    Key key,
    @required this.mediaController,
    this.controllerWidgetBuilder = defaultBuildIjkControllerWidget,
    this.textureBuilder = buildDefaultIjkPlayer,
    this.stateWidgetBuilder = IjkStatusWidget.defaultBuildStateWidget,
  }) : super(key: key);

  @override
  IjkPlayerState createState() => IjkPlayerState();
}

/// State of [IjkPlayer]
class IjkPlayerState extends State<IjkPlayer> {
  /// see [IjkMediaController]
  IjkMediaController controller;
  GlobalKey _wrapperKey = GlobalKey();

  IjkStateWidgetBuilder get _ijkStateBuilder => widget.stateWidgetBuilder;

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
            initialData: controller.videoInfo,
            builder: (context, videoInfoSnapShot) {
              return _buildTexture(id, videoInfoSnapShot.data);
            });
      },
    );
    var controllerWidget = widget.controllerWidgetBuilder?.call(controller);
    var statusWidget = buildIjkStateWidget();
    Widget stack = Stack(
      children: <Widget>[
        IgnorePointer(child: video),
        controllerWidget,
        statusWidget,
      ],
    );
//    return stack;
    return Material(
      child: stack,
      color: Colors.black,
    );
  }

  Widget _buildTexture(int id, VideoInfo info) {
    if (widget?.textureBuilder != null) {
      var texture = widget.textureBuilder.call(context, controller, info);
      return _IjkPlayerWrapper(
        child: texture,
        globalKey: _wrapperKey,
        controller: controller,
      );
    }

    if (id == null) {
      return Container(
        color: Colors.black,
      );
    }

    return Container(
      color: Colors.black,
      child: _IjkPlayerWrapper(
        globalKey: _wrapperKey,
        controller: controller,
        child: Texture(
          textureId: id,
        ),
      ),
    );
  }

  Widget buildIjkStateWidget() {
    return _ijkStateBuilder?.call(controller) ?? Container();
  }
}

class _IjkPlayerWrapper extends StatefulWidget {
  final Widget child;
  final GlobalKey globalKey;
  final IjkMediaController controller;

  const _IjkPlayerWrapper({
    @required this.globalKey,
    @required this.child,
    Key key,
    @required this.controller,
  }) : super(key: key);

  @override
  __IjkPlayerWrapperState createState() => __IjkPlayerWrapperState();
}

class __IjkPlayerWrapperState extends State<_IjkPlayerWrapper> {
  @override
  void initState() {
    super.initState();
    widget.controller?.attach(widget.globalKey);
  }

  @override
  void dispose() {
    widget.controller?.detach(widget.globalKey);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: widget.child,
      key: widget.globalKey,
    );
  }
}
