import 'package:flutter/material.dart';
import 'package:flutter_ijkplayer/flutter_ijkplayer.dart';
import 'package:ijkplayer_example/const/resource.dart';
import 'package:ijkplayer_example/i18n/i18n.dart';
import 'package:ijkplayer_example/utils/options_utils.dart';

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
    OptionUtils.addDefaultOptions(controller);
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
        title: Text(currentI18n.autoFullScreenTitle),
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
    // SystemChrome.setEnabledSystemUIOverlays([]);
    // OrientationPlugin.setEnabledSystemUIOverlays([]);
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
                icon: Icon(
                  Icons.fullscreen_exit,
                  color: Colors.white,
                ),
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
    return Scaffold(
      appBar: AppBar(
        title: Text(currentI18n.changeFullScreenWithButton),
      ),
      body: ListView(
        children: <Widget>[
          AspectRatio(
            aspectRatio: 1,
            child: IjkPlayer(
              mediaController: controller,
              controllerWidgetBuilder: (ctl) {
                return DefaultIJKControllerWidget(
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
            child: Text(currentI18n.play),
          ),
          RaisedButton(
            onPressed: setLandScapeLeft,
            child: Text(currentI18n.fullScreen),
          ),
        ],
      ),
    );
  }

  setLandScapeLeft() async {
    await IjkManager.setLandScape();
  }

  portraitUp() async {
    await IjkManager.setPortrait();
  }

  unlockOrientation() async {
    await IjkManager.unlockOrientation();
  }
}

class CustomFullControllerPage extends StatefulWidget {
  @override
  _CustomFullControllerPageState createState() =>
      _CustomFullControllerPageState();
}

class _CustomFullControllerPageState extends State<CustomFullControllerPage> {
  IjkMediaController controller;

  @override
  void initState() {
    super.initState();
    controller = IjkMediaController();
    controller.setDataSource(
      DataSource.asset(R.ASSETS_SAMPLE1_MP4),
      autoPlay: true,
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        height: 500,
        child: IjkPlayer(
          mediaController: controller,
          controllerWidgetBuilder: (ctl) {
            return DefaultIJKControllerWidget(
              controller: ctl,
              fullscreenControllerWidgetBuilder: _buildFullScrrenCtl,
            );
          },
        ),
      ),
    );
  }

  Widget _buildFullScrrenCtl(IjkMediaController controller) {
    return DefaultIJKControllerWidget(
      controller: controller,
      doubleTapPlay: true,
      currentFullScreenState: true,
    );
  }
}
