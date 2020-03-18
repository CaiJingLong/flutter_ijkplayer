import 'package:flutter/material.dart';
import 'package:flutter_ijkplayer/flutter_ijkplayer.dart';
import 'package:ijkplayer_example/i18n/i18n.dart';
import 'package:ijkplayer_example/utils/options_utils.dart';

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

    // editingController.text =
    // "https://media001.geekbang.org/f433fd1ce5e84d27b1101f0dad72a126/de563bb4aba94b5f95f448b33be4dd9f-9aede6861be944d696fe365f3a33b7b4-sd.m3u8";

    // editingController.text =
    //     "https://cctvalih5ca.v.myalicdn.com/live/cctv1_2/index.m3u8";

    // editingController.text = "http://222.207.48.30/hls/startv.m3u8";

    // editingController.text = "rtmp://172.16.100.245:1935/live1";

    // editingController.text = "http://172.16.100.245:5000/meng.mp4";
    // editingController.text = "http://172.16.100.245:5000/sample1.mp4";
    // editingController.text =
    //     "http://172.16.100.245:5000/05-2%20ffmpeg%E5%BC%80%E5%8F%91%E5%85%A5%E9%97%A8Log%E7%B3%BB%E7%BB%9F.mp4";
    // editingController.text =
    //     "http://172.16.100.245:5000/09-01%20%E7%AC%AC%E4%B8%80%E4%B8%AAJNI%E7%A8%8B%E5%BA%8F.mp4";
    // editingController.text = "http://172.16.100.245:5000/trailer.mp4";

    OptionUtils.addDefaultOptions(mediaController);
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
    await mediaController.setNetworkDataSource(
      text,
      autoPlay: true,
      headers: <String, String>{},
    );
  }
}
