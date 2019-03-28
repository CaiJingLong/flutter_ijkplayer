import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

class FullScreen2 extends StatefulWidget {
  @override
  _FullScreen2State createState() => _FullScreen2State();
}

class _FullScreen2State extends State<FullScreen2> {
  var controller = IjkMediaController();

  Orientation get orientation => MediaQuery.of(context).orientation;
  DataSource source = DataSource.network(
    "https://www.sample-videos.com/video123/mp4/360/big_buck_bunny_360p_30mb.mp4",
  );

  @override
  void initState() {
    super.initState();
    portraitUp();
  }

  @override
  void dispose() {
    controller.dispose();
    unlockOrientation();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (orientation == Orientation.landscape) {
      return buildLandscape();
    }
    return buildNormal();
  }

  Widget buildLandscape() {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return WillPopScope(
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            IjkPlayer(
              mediaController: controller,
            ),
            Container(
              height: 44.0,
              width: 44.0,
              child: IconButton(
                icon: Icon(Icons.fullscreen_exit),
                onPressed: portraitUp,
              ),
            ),
          ],
        ),
      ),
      onWillPop: () async {
        if (orientation == Orientation.landscape) {
          portraitUp();
          return false;
        }
        return true;
      },
    );
  }

  Widget buildNormal() {
    SystemChrome.setEnabledSystemUIOverlays([
      SystemUiOverlay.top,
      SystemUiOverlay.bottom,
    ]);
    return Scaffold(
      appBar: AppBar(
        title: Text("手动切换全屏(强制)"),
      ),
      body: ListView(
        children: <Widget>[
          AspectRatio(
            aspectRatio: 1,
            child: IjkPlayer(
              mediaController: controller,
              controllerWidgetBuilder: (ctl) {
                return DefaultControllerWidget(
                  controller: ctl,
                  verticalGesture: false,
                );
              },
            ),
          ),
          RaisedButton(
            onPressed: () async {
              await controller.setDataSource(source);
              await controller.play();
            },
            child: Text("播放"),
          ),
          RaisedButton(
            onPressed: setLandScapeLeft,
            child: Text("全屏"),
          ),
        ],
      ),
    );
  }

  void setLandScapeLeft() async {
    await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.landscapeLeft],
    );
  }

  void portraitUp() async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    await SystemChrome.restoreSystemUIOverlays();
  }

  void unlockOrientation() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.portraitUp,
    ]);
  }
}
