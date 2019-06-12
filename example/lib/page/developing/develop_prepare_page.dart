import 'package:flutter/material.dart';
import 'package:flutter_ijkplayer/flutter_ijkplayer.dart';

class ForPreparePage extends StatefulWidget {
  @override
  _ForPreparePageState createState() => _ForPreparePageState();
}

class _ForPreparePageState extends State<ForPreparePage> {
  IjkMediaController controller = IjkMediaController();

  @override
  void initState() {
    super.initState();
    initPlayer();
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
        title: Text("prepare属性"),
      ),
      body: Column(
        children: <Widget>[
          Container(
            child: IjkPlayer(mediaController: controller),
            height: 300,
          ),
        ],
      ),
    );
  }

  Future initPlayer() async {
    await controller.setDataSource(
      DataSource.asset("assets/sample1.mp4"),
      autoPlay: true,
    );
    controller.pause();
  }
}
