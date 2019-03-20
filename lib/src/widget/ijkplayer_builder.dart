import 'package:flutter/material.dart';
import 'package:flutter_ijkplayer/flutter_ijkplayer.dart';

typedef Widget PlayerBuilder(
  BuildContext context,
  IjkMediaController controller,
  VideoInfo info,
);

Widget buildDefaultIjkPlayer(
  BuildContext context,
  IjkMediaController controller,
  VideoInfo info,
) {
  int degree = info?.degree ?? 0;
  double ratio = info?.ratio ?? 1280 / 720;

  if (ratio == 0) {
    ratio = 1280 / 720;
  }

  var id = controller.textureId;

  if (id == null) {
    return Container(
      color: Colors.black,
    );
  }

  Widget w = Container(
    child: Texture(
      textureId: id,
    ),
  );

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
