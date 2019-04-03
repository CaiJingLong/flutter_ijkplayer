import 'package:flutter/material.dart';
import 'package:ijkplayer_example/page/asset_page.dart';
import 'package:ijkplayer_example/page/dialog_video_page.dart';
import 'package:ijkplayer_example/page/full_screen.dart';
import 'package:ijkplayer_example/page/gallery_page.dart';
import 'package:ijkplayer_example/page/network.dart';
import 'package:ijkplayer_example/page/video_list.dart';

class IndexPage extends StatefulWidget {
  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("首页"),
      ),
      body: ListView(
        children: <Widget>[
          buildButton("播放网络视频", NetworkPage()),
          buildButton("播放相册视频", PlayGalleryPage()),
          buildButton("播放应用asset", AssetPage()),
          buildButton("ListView中插入视频(未完成)", VideoList()),
          buildButton("全屏切换示例(自动)", FullScreen()),
          buildButton("全屏切换示例(手动)", FullScreen2()),
          buildButton("在dialog中播放显示视频", DialogVideoPage()),
        ],
      ),
    );
  }

  Widget buildButton(String text, Widget targetPage) {
    return FlatButton(
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => targetPage));
      },
      child: Text(text),
    );
  }
}
