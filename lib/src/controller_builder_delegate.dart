import 'package:flutter/widgets.dart';
import './ijkplayer.dart';

Widget defaultBuildIjkControllerWidget(IjkMediaController controller) {
  return DefaultControllerWidget(controller);
}

class DefaultControllerWidget extends StatefulWidget {
  final IjkMediaController controller;

  const DefaultControllerWidget(this.controller);

  @override
  _DefaultControllerWidgetState createState() =>
      _DefaultControllerWidgetState();
}

class _DefaultControllerWidgetState extends State<DefaultControllerWidget> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
