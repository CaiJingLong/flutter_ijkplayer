import 'package:flutter/material.dart';
import 'package:flutter_ijkplayer/flutter_ijkplayer.dart';
import 'package:ijkplayer_example/const/video_datasource.dart';

class NewFullScreenPage extends StatefulWidget {
  @override
  _NewFullScreenPageState createState() => _NewFullScreenPageState();
}

class _NewFullScreenPageState extends State<NewFullScreenPage> {
  IjkMediaController controller;

  @override
  void initState() {
    super.initState();
    controller = IjkMediaController();
    controller.setDataSource(VideoDataSource.springBootMenuM3u8);
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
        title: Text("New full screen"),
      ),
      body: Column(
        children: <Widget>[
          AspectRatio(
            aspectRatio: 1920 / 1080,
            child: IjkPlayer(
              mediaController: controller,
            ),
          ),
        ],
      ),
    );
  }
}
