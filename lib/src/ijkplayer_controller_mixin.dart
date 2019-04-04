import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

mixin IjkMediaControllerMixin {
  List<GlobalKey> _keys = [];

  attach(GlobalKey key) {
    print("IjkMediaControllerMixin attach $key");
    _keys.add(key);
  }

  detach(GlobalKey key) {
    print("IjkMediaControllerMixin detach $key");
    _keys.remove(key);
  }

  Future<Uint8List> screenShot() async {
    print("IjkMediaControllerMixin will screen shot");
    if (_keys.isEmpty) {
      print("IjkMediaControllerMixin screen shot key is empty = $_keys");
      return null;
    }
    var key = _keys[0];
    RenderRepaintBoundary boundary = key.currentContext.findRenderObject();
    var image = await boundary.toImage();
    print(
        "IjkMediaControllerMixin screen shot image width = ${image.width} , height = ${image.height}");
    var byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData.buffer.asUint8List();
  }
}
