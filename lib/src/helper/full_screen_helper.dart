import 'package:flutter/material.dart';
import 'package:flutter_ijkplayer/flutter_ijkplayer.dart';

class FullScreenHelper {
  static int getQuarterTurns(VideoInfo info, BuildContext context) {
    Axis axis;

    if (info.width == 0 || info.height == 0) {
      axis = Axis.horizontal;
    } else if (info.width > info.height) {
      if (info.degree == 90 || info.degree == 270) {
        axis = Axis.vertical;
      } else {
        axis = Axis.horizontal;
      }
    } else {
      if (info.degree == 90 || info.degree == 270) {
        axis = Axis.horizontal;
      } else {
        axis = Axis.vertical;
      }
    }

    var mediaQueryData = MediaQuery.of(context);

    int quarterTurns;

    if (axis == Axis.horizontal) {
      if (mediaQueryData.orientation == Orientation.landscape) {
        quarterTurns = 0;
      } else {
        quarterTurns = 1;
      }
    } else {
      quarterTurns = 0;
    }

    return quarterTurns;
  }
}
