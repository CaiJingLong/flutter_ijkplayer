import 'package:flutter/material.dart';
import 'package:flutter_ijkplayer/flutter_ijkplayer.dart';

class FullScreen extends StatefulWidget {
  @override
  _FullScreenState createState() => _FullScreenState();
}

class _FullScreenState extends State<FullScreen> {
  var controller = IjkMediaController();

  Orientation get orientation => MediaQuery.of(context).orientation;
  DataSource source = DataSource.network(
    "https://www.sample-videos.com/video123/mp4/360/big_buck_bunny_360p_30mb.mp4",
  );

  @override
  void initState() {
    super.initState();
    controller.setDataSource(source, autoPlay: true);
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (orientation == Orientation.landscape) {
      return _buildFullScreenPlayer();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("切换横竖屏可以看到界面变化"),
      ),
      body: ListView(
        children: <Widget>[
          _buildPlayerItem(),
        ],
      ),
    );
  }

  _buildPlayerItem() {
    return Container(
      height: 200,
      child: IjkPlayer(
        mediaController: controller,
      ),
    );
  }

  _buildFullScreenPlayer() {
    var data = MediaQuery.of(context);
    return Material(
      child: Container(
        width: data.size.width,
        height: data.size.height,
        child: IjkPlayer(
          mediaController: controller,
        ),
      ),
    );
  }
}
