import 'package:flutter/material.dart';
import 'package:flutter_ijkplayer/flutter_ijkplayer.dart';
import 'package:flutter_ijkplayer/src/widget/controller_builder.dart';

/// Using mediaController to Construct a Controller UI
typedef Widget ControllerWidgetBuilder(IjkMediaController controller);

/// default create IJK Controller UI
Widget defaultBuildIjkControllerWidget(IjkMediaController controller) {
  return DefaultControllerWidget(controller: controller);
}
