import 'package:flutter/material.dart';
import 'package:flutter_ijkplayer/flutter_ijkplayer.dart';
import 'package:ijkplayer_example/const/video_datasource.dart';
import 'package:ijkplayer_example/i18n/i18n.dart';
import 'package:ijkplayer_example/utils/options_utils.dart';

class ErrorUrlPage extends StatefulWidget {
  @override
  _ErrorUrlPageState createState() => _ErrorUrlPageState();
}

class _ErrorUrlPageState extends State<ErrorUrlPage> {
  TextEditingController editingController = TextEditingController();
  IjkMediaController mediaController = IjkMediaController();

  // StreamSubscription statusSub;
  // StreamSubscription ijkErrorSub;
  @override
  void initState() {
    super.initState();

    // editingController.text =
    //     "https://js.wshls.acgvideo.com/live-js/922199/live_8747041_1741679.m3u8?wsSecret=1337e20698b1673ac73ea8f35e2d60e8&wsTime=1556966389&trid=5afe0383d7d149dabe0c0327c2e53a75&order=1&sig=no";

    // statusSub = mediaController.ijkStatusStream.listen((status) {
    //   print("status = $status");
    // });

    // ijkErrorSub = mediaController.ijkErrorStream.listen((error) {
    //   print("error = $error");
    // });
    OptionUtils.addDefaultOptions(mediaController);
    mediaController.setDataSource(
      VideoDataSource.reportErrorM3u8FromAliyun,
      autoPlay: true,
    );
  }

  @override
  void dispose() {
    // statusSub?.cancel();
    // ijkErrorSub?.cancel();
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
