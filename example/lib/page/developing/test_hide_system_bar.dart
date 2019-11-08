import 'package:flutter/material.dart';
import 'package:flutter_ijkplayer/flutter_ijkplayer.dart';

class TestHideSystemBar extends StatefulWidget {
  @override
  _TestHideSystemBarState createState() => _TestHideSystemBarState();
}

class _TestHideSystemBarState extends State<TestHideSystemBar> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Test system bar"),
      ),
      body: Column(
        children: <Widget>[
          FlatButton(
            child: Text("show"),
            onPressed: () => show(true),
          ),
          FlatButton(
            child: Text("hide"),
            onPressed: () => show(false),
          ),
        ],
      ),
    );
  }

  show(bool show) {
    IjkManager.showStatusBar(show);
  }
}
