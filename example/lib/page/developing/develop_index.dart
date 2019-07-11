import 'package:flutter/material.dart';

import 'develop_prepare_page.dart';
import 'live_interruption_page.dart';
import 'new_full_screen_page.dart';
import 'src_error_page.dart';

class DevelopingIndexPage extends StatefulWidget {
  @override
  DevelopingIndexPageState createState() => DevelopingIndexPageState();
}

class DevelopingIndexPageState extends State<DevelopingIndexPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("For Developer , user don't use."),
      ),
      body: ListView(
        children: <Widget>[
          buildButton("developing preare page", ForPreparePage()),
          buildButton("直播中断", LiveInterruptionPage()),
          buildButton("视频源错误", SreErrorPage()),
          buildButton("新的全屏", NewFullScreenPage()),
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
