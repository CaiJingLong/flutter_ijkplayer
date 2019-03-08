import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

part './controller.dart';

class IjkPlayer extends StatefulWidget {
  final IjkController controller;

  const IjkPlayer({Key key, this.controller}) : super(key: key);

  @override
  _IjkPlayerState createState() => _IjkPlayerState();
}

class _IjkPlayerState extends State<IjkPlayer> {
  IjkController get controller => widget.controller;

  StreamController<int> _streamController = StreamController.broadcast();

  Stream<int> get stream => _streamController.stream;

  @override
  void initState() {
    super.initState();
    controller?.addListener(updateTextureId);
  }

  void updateTextureId() {
    print("update id = ${controller.textureId}");
    _streamController.add(controller.textureId);
  }

  @override
  void dispose() {
    controller?.removeListener(updateTextureId);
    _streamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
        stream: stream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container();
          }
          return _buildContent(snapshot.data);
        });
  }

  Widget _buildContent(int id) {
    if (id == null) {
      return Container();
    }

    return Texture(
      textureId: id,
    );
  }
}
