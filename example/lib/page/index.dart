import 'package:flutter/material.dart';
import 'package:ijkplayer_example/page/asset_page.dart';
import 'package:ijkplayer_example/page/gallery_page.dart';
import 'package:ijkplayer_example/page/network.dart';

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
