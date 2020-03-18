import 'package:flutter/material.dart';
import 'package:flutter_ijkplayer/flutter_ijkplayer.dart';
import 'package:ijkplayer_example/i18n/i18n.dart';
import 'package:photo/photo.dart';
import 'package:photo_manager/photo_manager.dart';

class PlayGalleryPage extends StatefulWidget {
  @override
  _PlayGalleryPageState createState() => _PlayGalleryPageState();
}

class _PlayGalleryPageState extends State<PlayGalleryPage> {
  IjkMediaController mediaController = IjkMediaController();

  String mediaUrl;

  @override
  void initState() {
    super.initState();
    mediaController.addIjkPlayerOptions([
      TargetPlatform.iOS,
      TargetPlatform.android,
    ], [
      IjkOption(IjkOptionCategory.player, 'mediacodec', 1),
      IjkOption(IjkOptionCategory.player, 'mediacodec-hevc', 1),
      IjkOption(IjkOptionCategory.player, 'videotoolbox', 1),
      IjkOption(IjkOptionCategory.player, 'video-max-frame-width-default', 1),
      IjkOption(IjkOptionCategory.player, 'videotoolbox-max-frame-width', 1920),
      // IjkOption(IjkOptionCategory.player, 'videotoolbox-max-frame-width', 960),
    ]);
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
          ListTile(
            title: Text("mediaUrl = $mediaUrl"),
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

  void _pickVideo() async {
    var assetList = await PhotoPicker.pickAsset(
      context: context,
      pickType: PickType.onlyVideo,
      maxSelected: 1,
    );
    if (assetList?.isNotEmpty == true) {
      var asset = assetList[0];
      _playVideo(asset);
    }
  }

  void _playVideo(AssetEntity asset) async {
    mediaUrl = await asset.getMediaUrl();
    setState(() {});
    final file = await asset.file;
    if (file != null && file.existsSync()) {
      await mediaController.setFileDataSource(file);
    }
  }
}
