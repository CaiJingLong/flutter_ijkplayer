import 'package:flutter/material.dart';
import 'package:flutter_ijkplayer/flutter_ijkplayer.dart';

class NetworkPage extends StatefulWidget {
  @override
  _NetworkPageState createState() => _NetworkPageState();
}

class _NetworkPageState extends State<NetworkPage> {
  TextEditingController editingController = TextEditingController();
  IjkMediaController mediaController = IjkMediaController();

  @override
  void initState() {
    super.initState();
    editingController.text =
        "https://www.sample-videos.com/video123/mp4/720/big_buck_bunny_720p_30mb.mp4";
    editingController.text =
        "http://img.ksbbs.com/asset/Mon_1703/05cacb4e02f9d9e.mp4";
    editingController.text =
        "http://172.16.100.245:5000/05-2%20ffmpeg%E5%BC%80%E5%8F%91%E5%85%A5%E9%97%A8Log%E7%B3%BB%E7%BB%9F.mp4";
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
        title: Text("播放网络资源"),
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
                child: Text("播放"),
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
