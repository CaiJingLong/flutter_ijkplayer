import 'package:flutter/material.dart';
import 'package:flutter_ijkplayer/flutter_ijkplayer.dart';
import 'package:ijkplayer_example/i18n/i18n.dart';

/// 直播异常中断
class LiveInterruptionPage extends StatefulWidget {
  @override
  _LiveInterruptionPageState createState() => _LiveInterruptionPageState();
}

class _LiveInterruptionPageState extends State<LiveInterruptionPage> {
  TextEditingController editingController = TextEditingController();
  IjkMediaController mediaController = IjkMediaController();

  @override
  void initState() {
    super.initState();

    editingController.text =
        "http://js.flv.huya.com/huyalive/94525224-2460685313-10568562945082523648-2789274524-10057-A-0-1.flv?wsSecret=9b67d35535b6956aec37815c21e43cc8&wsTime=5cbbea84&ratio=2000";
  }

  @override
  void dispose() {
    editingController.dispose();
    mediaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(currentI18n.networkButton),
      ),
      body: ListView(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: TextField(
                  controller: editingController,
                ),
              ),
              FlatButton(
                child: Text(currentI18n.play),
                onPressed: _playInput,
              ),
            ],
          ),
          Container(
            height: 400,
            child: IjkPlayer(
              mediaController: mediaController,
            ),
          ),
        ],
      ),
    );
  }

  void _playInput() async {
    var text = editingController.text;
    await mediaController.setNetworkDataSource(text, autoPlay: true);
  }
}
