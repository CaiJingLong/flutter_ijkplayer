import 'package:flutter/widgets.dart';

class UIHelper {
  static Rect findGlobalRect(GlobalKey key) {
    RenderBox renderObject = key.currentContext?.findRenderObject();
    if (renderObject == null) {
      return null;
    }

    var globalOffset = renderObject?.localToGlobal(Offset.zero);

    if (globalOffset == null) {
      return null;
    }

    var bounds = renderObject.paintBounds;
    bounds = bounds.translate(globalOffset.dx, globalOffset.dy);
    return bounds;
  }

  static Offset globalOffsetToLocal(GlobalKey key, Offset offsetGlobal) {
    RenderBox renderObject = key.currentContext?.findRenderObject();
    if (renderObject == null) {
      return null;
    }
    return renderObject.globalToLocal(offsetGlobal);
  }

}
