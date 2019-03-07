import 'package:flutter/material.dart';
import 'package:flutter_ijkplayer/flutter_ijkplayer.dart';
import 'package:permission/permission.dart';

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
  IjkController controller = IjkController();

  @override
  void initState() {
    super.initState();
    controller.initIjk();
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
              aspectRatio: 1,
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
          await Permission.requestPermissions([PermissionName.Storage]);
          await controller.initIjk();
          await controller.setNetData(
              // 'http://www.sample-videos.com/video123/mp4/720/big_buck_bunny_720p_20mb.mp4',
              "file:///sdcard/Download/Sample1.mp4");
          controller.play();
        },
      ),
    );
  }
}
