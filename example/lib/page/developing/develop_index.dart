import 'package:flutter/material.dart';

import 'develop_prepare_page.dart';

class DevelopingIndexPage extends StatefulWidget {
  @override
  DevelopingIndexPageState createState() => DevelopingIndexPageState();
}

class DevelopingIndexPageState extends State<DevelopingIndexPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("开发中"),
      ),
      body: ListView(
        children: <Widget>[
          buildButton("developing preare page", ForPreparePage()),
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
