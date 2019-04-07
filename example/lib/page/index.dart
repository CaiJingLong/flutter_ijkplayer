import 'package:flutter/material.dart';
import 'package:ijkplayer_example/i18n/i18n.dart';
import 'package:ijkplayer_example/page/asset_page.dart';
import 'package:ijkplayer_example/page/controller_stream_use.dart';
import 'package:ijkplayer_example/page/dialog_video_page.dart';
import 'package:ijkplayer_example/page/full_screen.dart';
import 'package:ijkplayer_example/page/gallery_page.dart';
import 'package:ijkplayer_example/page/in_overlay_page.dart';
import 'package:ijkplayer_example/page/network.dart';
import 'package:ijkplayer_example/page/paging_page.dart';
import 'package:ijkplayer_example/page/screen_shot_page.dart';
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
        title: Text(currentI18n.indexTitle),
      ),
      body: ListView(
        children: <Widget>[
          buildButton(currentI18n.networkButton, NetworkPage()),
          buildButton(currentI18n.photoButton, PlayGalleryPage()),
          buildButton(currentI18n.assetButton, AssetPage()),
          buildButton(currentI18n.listViewButton, VideoList()),
          buildButton(currentI18n.fullScreenAutoButton, FullScreen()),
          buildButton(currentI18n.fullScreenManualButton, FullScreen2()),
          buildButton(currentI18n.withDialogButton, DialogVideoPage()),
          buildButton(currentI18n.pageViewButton, PagingPickPage()),
          buildButton(currentI18n.useStreamUsage, ControllerStreamUsagePage()),
          buildButton(currentI18n.screenshotTitle, ScreenShotPage()),
          buildButton(currentI18n.overlayPageTitle, InOverlayPage()),
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
