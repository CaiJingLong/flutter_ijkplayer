import 'package:flutter/material.dart';
import 'package:flutter_ijkplayer/flutter_ijkplayer.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  IjkMediaController controller = IjkMediaController();

  @override
  void initState() {
    super.initState();
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
        title: const Text('Plugin example app'),
      ),
      body: Container(
        // width: MediaQuery.of(context).size.width,
        // height: 400,
        child: Column(
          children: <Widget>[
            AspectRatio(
              aspectRatio: 1280 / 720,
              child: IjkPlayer(
                controller: controller,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.play_arrow),
        onPressed: () async {
          await controller.setDataSource(
            'https://www.sample-videos.com/video123/mp4/720/big_buck_bunny_720p_20mb.mp4',
            // 'https://www.sample-videos.com/video123/flv/720/big_buck_bunny_720p_10mb.flv',
            // 'http://184.72.239.149/vod/smil:BigBuckBunny.smil/playlist.m3u8',
            // "file:///sdcard/Download/Sample1.mp4",
          );
          print("set data source success");
          controller.play();
        },
      ),
    );
  }
}
