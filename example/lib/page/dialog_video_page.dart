import 'package:flutter/material.dart';
import 'package:flutter_ijkplayer/flutter_ijkplayer.dart';

class DialogVideoPage extends StatefulWidget {
  @override
  _DialogVideoPageState createState() => _DialogVideoPageState();
}

class _DialogVideoPageState extends State<DialogVideoPage> {
  IjkMediaController controller = IjkMediaController();

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: <Widget>[
            AspectRatio(
              aspectRatio: 1,
              child: _buildIJKPlayer(),
            ),
            FlatButton(
              child: Text("显示dialog"),
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

    await Future.delayed(Duration(seconds: 2));

    showDialog(
      context: context,
      builder: (_) => IjkPlayer(
            mediaController: controller,
          ),
    );
  }

  _buildIJKPlayer() {
    return IjkPlayer(
      mediaController: controller,
    );
  }
}
