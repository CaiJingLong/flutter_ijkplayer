import 'package:flutter/material.dart';
import 'package:flutter_ijkplayer/flutter_ijkplayer.dart';

class CrashOnSetSrcPage extends StatefulWidget {
  @override
  _CrashOnSetSrcPageState createState() => _CrashOnSetSrcPageState();
}

class _CrashOnSetSrcPageState extends State<CrashOnSetSrcPage> {
  IjkMediaController controller;

  List<String> networkList = [
    "http://playertest.longtailvideo.com/adaptive/bipbop/gear4/prog_index.m3u8",
    "http://img.ksbbs.com/asset/Mon_1703/05cacb4e02f9d9e.mp4",
    "https://media001.geekbang.org/f433fd1ce5e84d27b1101f0dad72a126/de563bb4aba94b5f95f448b33be4dd9f-9aede6861be944d696fe365f3a33b7b4-sd.m3u8",
  ];

  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    controller = IjkMediaController();
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
        title: Text("切换数据崩溃"),
      ),
      body: ListView(
        children: <Widget>[
          AspectRatio(
            aspectRatio: 1,
            child: IjkPlayer(
              mediaController: controller,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final url = networkList[currentIndex];
          controller.setDataSource(DataSource.network(url), autoPlay: true);
          currentIndex++;
          currentIndex %= networkList.length;
        },
      ),
    );
  }
}
