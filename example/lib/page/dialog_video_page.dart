import 'package:flutter/material.dart';
import 'package:flutter_ijkplayer/flutter_ijkplayer.dart';
import 'package:ijkplayer_example/i18n/i18n.dart';
import 'package:ijkplayer_example/utils/options_utils.dart';

class DialogVideoPage extends StatefulWidget {
  @override
  _DialogVideoPageState createState() => _DialogVideoPageState();
}

class _DialogVideoPageState extends State<DialogVideoPage> {
  IjkMediaController controller = IjkMediaController();

  @override
  void initState() {
    super.initState();
    OptionUtils.addDefaultOptions(controller);
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(currentI18n.withDialogButton),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            FlatButton(
              child: Text(currentI18n.showDialog),
              onPressed: showIJKDialog,
            ),
          ],
        ),
      ),
    );
  }

  void showIJKDialog() async {
    await controller.setDataSource(
      DataSource.network(
          "http://img.ksbbs.com/asset/Mon_1703/05cacb4e02f9d9e.mp4"),
    );
    await controller.play();

    await showDialog(
      context: context,
      builder: (_) => _buildIJKPlayer(),
    );

    controller.pause();
  }

  _buildIJKPlayer() {
    return IjkPlayer(
      mediaController: controller,
    );
  }
}
