import 'package:flutter/material.dart';
import 'package:flutter_ijkplayer/flutter_ijkplayer.dart';
import 'package:ijkplayer_example/page/paging_page.dart';
import 'package:ijkplayer_example/page/screen_shot_page.dart';
import 'package:ijkplayer_example/page/video_list.dart';

import '../i18n/i18n.dart';
import 'asset_page.dart';
import 'auto_full_screen.dart';
import 'controller_stream_use.dart';
import 'custom_ijk_opt_page.dart';
import 'developing/develop_index.dart';
import 'dialog_video_page.dart';
import 'error_url.dart';
import 'full_screen.dart';
import 'gallery_page.dart';
import 'ijk_status_page.dart';
import 'in_overlay_page.dart';
import 'network.dart';
import 'speed_page.dart';

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
          buildButton("For developer, user don't use.", DevelopingIndexPage()),
          buildButton(currentI18n.networkButton, NetworkPage()),
          buildButton(currentI18n.photoButton, PlayGalleryPage()),
          buildButton(currentI18n.assetButton, AssetPage()),
          buildButton(currentI18n.listViewButton, VideoList()),
          buildButton(currentI18n.fullScreenAutoButton, FullScreen()),
          buildButton(currentI18n.fullScreenManualButton, FullScreen2()),
          buildButton(currentI18n.autoFullScreenOnPlay, AutoFullScreenPage()),
          buildButton(currentI18n.withDialogButton, DialogVideoPage()),
          buildButton(currentI18n.pageViewButton, PagingPickPage()),
          buildButton(currentI18n.useStreamUsage, ControllerStreamUsagePage()),
          buildButton(currentI18n.screenshotTitle, ScreenShotPage()),
          buildButton(currentI18n.overlayPageTitle, InOverlayPage()),
          buildButton(currentI18n.ijkStatusTitle, IjkStatusPage()),
          buildButton(currentI18n.customOption, CustomIjkOptionPage()),
          buildButton(currentI18n.errorUrl, ErrorUrlPage()),
          buildButton(currentI18n.setSpeed, SpeedPage()),
          buildButton(
              currentI18n.customFullScreenWidget, CustomFullControllerPage()),
          FlatButton(
            onPressed: () {
              IjkManager.initIJKPlayer();
            },
            child: Text("release all ijkplayer resource"),
          ),
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
