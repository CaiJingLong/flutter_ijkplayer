import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_ijkplayer/flutter_ijkplayer.dart';
import 'package:ijkplayer_example/i18n/i18n.dart';
import 'package:photo/photo.dart';

class PlayGalleryPage extends StatefulWidget {
  @override
  _PlayGalleryPageState createState() => _PlayGalleryPageState();
}

class _PlayGalleryPageState extends State<PlayGalleryPage> {
  IjkMediaController mediaController = IjkMediaController();

  File file;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    mediaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(currentI18n.photoButton),
      ),
      body: ListView(
        children: <Widget>[
          FlatButton(
            child: Text("Pick"),
            onPressed: _pickVideo,
          ),
          _buildFileText(),
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

  _buildFileText() {
    if (file?.existsSync() == true) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          "file.path: ${file.path}",
          textAlign: TextAlign.center,
        ),
      );
    }
    return Container();
  }

  void _pickVideo() async {
    var assetList = await PhotoPicker.pickAsset(
      context: context,
      pickType: PickType.onlyVideo,
      maxSelected: 1,
    );
    if (assetList?.isNotEmpty == true) {
      var asset = assetList[0];
      this.file = await asset.file;
      _playVideo();
    }
  }

  void _playVideo() async {
    if (this.file != null && this.file.existsSync())
      await mediaController.setFileDataSource(
        file,
        autoPlay: true,
      );
  }
}
