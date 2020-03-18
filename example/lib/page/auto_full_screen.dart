import 'package:flutter/material.dart';
import 'package:flutter_ijkplayer/flutter_ijkplayer.dart';
import 'package:ijkplayer_example/const/video_datasource.dart';
import 'package:ijkplayer_example/i18n/i18n.dart';
import 'package:ijkplayer_example/utils/options_utils.dart';

class AutoFullScreenPage extends StatefulWidget {
  @override
  _AutoFullScreenPageState createState() => _AutoFullScreenPageState();
}

class _AutoFullScreenPageState extends State<AutoFullScreenPage> {
  IjkMediaController controller = IjkMediaController();
  final key = GlobalKey<DefaultIJKControllerWidgetState>();

  @override
  void initState() {
    super.initState();
    OptionUtils.addDefaultOptions(controller);
    setDataSource();
  }

  void setDataSource() async {
    await controller.setDataSource(
      VideoDataSource.springBootMenuM3u8,
      autoPlay: true,
    );
    key.currentState.fullScreen();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(currentI18n.autoFullScreenOnPlay),
      ),
      body: Container(
        child: AspectRatio(
          aspectRatio: 1280 / 720,
          child: IjkPlayer(
            mediaController: controller,
            controllerWidgetBuilder: (ctl) => DefaultIJKControllerWidget(
                  controller: ctl,
                  key: key,
                ),
          ),
        ),
      ),
    );
  }
}
