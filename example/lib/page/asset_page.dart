import 'package:flutter/material.dart';
import 'package:flutter_ijkplayer/flutter_ijkplayer.dart';

class AssetPage extends StatefulWidget {
  @override
  _AssetPageState createState() => _AssetPageState();
}

class _AssetPageState extends State<AssetPage> {
  IjkMediaController controller = IjkMediaController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("播放资产"),
      ),
      body: ListView(
        children: <Widget>[
          AspectRatio(
            aspectRatio: 1,
            child: IjkPlayer(
              mediaController: controller,
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.play_arrow),
        onPressed: () async {
          await controller.setAssetDataSource(
            "assets/sample1.mp4",
            autoPlay: true,
          );
          await controller.pause();
        },
      ),
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
