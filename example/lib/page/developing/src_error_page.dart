import 'package:flutter/material.dart';
import 'package:flutter_ijkplayer/flutter_ijkplayer.dart';

class VideoWidget extends StatefulWidget {
  final String url;
  VideoWidget(this.url);
  @override
  _VideoWidgetState createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget> with WidgetsBindingObserver {
  IjkMediaController controller;
  @override
  void initState() {
    super.initState();
    controller = IjkMediaController();
    controller.setNetworkDataSource(widget.url, autoPlay: true);
    Stream<IjkStatus> ijkStatusStream = controller.ijkStatusStream;
    ijkStatusStream.listen((status) {
      if (status == IjkStatus.complete) {
        controller?.play();
      }
    });
//    SystemChannels.lifecycle.setMessageHandler((msg) {});
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      controller?.play();
    } else if (state == AppLifecycleState.paused) {
      controller?.pause();
    }
  }

  @override
  void deactivate() {
    super.deactivate();
    controller?.pause();
  }

  @override
  void reassemble() {
    super.reassemble();
    controller?.play();
  }

  @override
  void dispose() {
    super.dispose();
    controller?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IjkPlayer(
      mediaController: controller,
      controllerWidgetBuilder: (mController) => new Container(),
    );
  }
}

class SreErrorPage extends StatefulWidget {
  @override
  _SreErrorPageState createState() => _SreErrorPageState();
}

class _SreErrorPageState extends State<SreErrorPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: PageView.builder(
          itemBuilder: (BuildContext context, int index) {
            // return VideoWidget("http://114.55.36.48/1204/27/index$index.m3u8");
            return VideoWidget(
                "http://itv.100.ahct.lv1.vcache.cn/100/ott_baseline_kalaok/hd/151/CP0541903573/playlist.m3u8");
          },
        ),
      ),
    );
  }
}
