import 'package:flutter/material.dart';
import 'package:flutter_ijkplayer/flutter_ijkplayer.dart';

/// Player builder, Inheritance of this class allows you to implement your own player
typedef Widget IJKTextureBuilder(
  BuildContext context,
  IjkMediaController controller,
  VideoInfo info,
);

/// default IJKPlayer method
Widget buildDefaultIjkPlayer(
  BuildContext context,
  IjkMediaController controller,
  VideoInfo info,
) {
  return DefaultIJKPlayerWrapper(
    controller: controller,
    info: info,
  );
}

/// Default IJKPlayer Wrapper
///
/// This widget solves the aspect ratio problem in video direction.
class DefaultIJKPlayerWrapper extends StatelessWidget {
  final IjkMediaController controller;
  final VideoInfo info;

  const DefaultIJKPlayerWrapper({
    Key key,
    this.controller,
    this.info,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double ratio = info?.ratio ?? 1280 / 720;

    var id = controller.textureId;

    if (id == null) {
      return AspectRatio(
        aspectRatio: ratio,
        child: Container(
          color: Colors.black,
        ),
      );
    }

    Widget w = Container(
      color: Colors.black,
      child: Texture(
        textureId: id,
      ),
    );

    if (!controller.autoRotate) {
      return w;
    }

    int degree = info?.degree ?? 0;

    if (ratio == 0) {
      ratio = 1280 / 720;
    }

    w = AspectRatio(
      aspectRatio: ratio,
      child: w,
    );

    if (degree != 0) {
      w = RotatedBox(
        quarterTurns: degree ~/ 90,
        child: w,
      );
    }

    return Container(
      child: w,
      alignment: Alignment.center,
      color: Colors.black,
    );
  }
}
