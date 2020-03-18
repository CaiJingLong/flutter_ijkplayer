import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_ijkplayer/flutter_ijkplayer.dart';
import 'package:ijkplayer_example/utils/options_utils.dart';
import 'package:photo/photo.dart';
import 'package:photo_manager/photo_manager.dart';

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  IjkMediaController controller = IjkMediaController();

  @override
  void initState() {
    super.initState();
    OptionUtils.addDefaultOptions(controller);
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.videocam),
            onPressed: _pickVideo,
          ),
        ],
      ),
      body: Container(
        // width: MediaQuery.of(context).size.width,
        // height: 400,
        child: ListView(
          children: <Widget>[
            buildIjkPlayer(),
            _buildPlayAssetButton(),
            _buildControllerButtons(),
            _buildVolumeBar(),
            _buildSystemVolumeButton(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.play_arrow),
        onPressed: () async {
          await controller.setNetworkDataSource(
//              'http://www.sample-videos.com/video123/mp4/720/big_buck_bunny_720p_20mb.mp4',
              'https://www.sample-videos.com/video123/mp4/720/big_buck_bunny_720p_20mb.mp4',
//              'rtmp://172.16.100.245/live1',
              // 'https://www.sample-videos.com/video123/flv/720/big_buck_bunny_720p_10mb.flv',
//              "https://www.sample-videos.com/video123/mp4/720/big_buck_bunny_720p_1mb.mp4",
              // 'http://184.72.239.149/vod/smil:BigBuckBunny.smil/playlist.m3u8',
              // "file:///sdcard/Download/Sample1.mp4",
              autoPlay: true);
          print("set data source success");
          // controller.playOrPause();
        },
      ),
    );
  }

  Widget buildIjkPlayer() {
    return Container(
      height: 400,
      child: IjkPlayer(
        mediaController: controller,
      ),
    );
  }

  void _pickVideo() async {
    List<AssetEntity> imgList = await PhotoPicker.pickAsset(
      // BuildContext required
      context: context,

      /// The following are optional parameters.
      themeColor: Colors.green,
      // the title color and bottom color
      padding: 1.0,
      // item padding
      dividerColor: Colors.grey,
      // divider color
      disableColor: Colors.grey.shade300,
      // the check box disable color
      itemRadio: 0.88,
      // the content item radio
      maxSelected: 8,
      // max picker image count
      // provider: I18nProvider.english,
      provider: I18nProvider.chinese,
      // i18n provider ,default is chinese. , you can custom I18nProvider or use ENProvider()
      rowCount: 3,
      // item row count
      textColor: Colors.white,
      // text color
      thumbSize: 160,
      // preview thumb size , default is 64
      sortDelegate: SortDelegate.common,
      // default is common ,or you make custom delegate to sort your gallery
      checkBoxBuilderDelegate: DefaultCheckBoxBuilderDelegate(
        activeColor: Colors.white,
        unselectedColor: Colors.white,
      ),
      // default is DefaultCheckBoxBuilderDelegate ,or you make custom delegate to create checkbox

      badgeDelegate: const DurationBadgeDelegate(),
      // badgeDelegate to show badge widget

      pickType: PickType.onlyVideo,
    );

    if (imgList != null && imgList.isNotEmpty) {
      var asset = imgList[0];
      var file = (await asset.file).absolute;
      playFile(file);
    }
  }

  void playFile(File file) async {
    await controller.setFileDataSource(file, autoPlay: true);
  }

  void playUri(String uri) async {
    await controller.setNetworkDataSource(uri, autoPlay: true);
  }

  _buildPlayAssetButton() {
    return FlatButton(
      child: Text("play sample asset"),
      onPressed: () async {
        await controller.setAssetDataSource(
          "assets/sample1.mp4",
          autoPlay: true,
        );

        Timer.periodic(Duration(seconds: 2), (timer) async {
          var info = await controller.getVideoInfo();
          print("info = $info");
          if (info == null) {
            return;
          }

          if (info.progress >= 0.95) {
            timer.cancel();
          }
        });
      },
    );
  }

  _buildControllerButtons() {
    return Row(
      children: <Widget>[
        FlatButton(
          child: StreamBuilder<bool>(
            stream: controller.playingStream,
            initialData: controller?.isPlaying ?? false,
            builder: (context, snapshot) {
              var isPlaying = snapshot.hasData && snapshot.data;
              return Text(isPlaying ? "暂停" : "播放");
            },
          ),
          onPressed: () async {
            await controller?.playOrPause();
          },
        ),
        FlatButton(
          child: Text("停止"),
          onPressed: () async {
            await controller?.stop();
          },
        ),
      ],
    );
  }

  _buildVolumeBar() {
    return StreamBuilder<int>(
      stream: controller?.volumeStream,
      initialData: controller?.volume,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }
        var volume = snapshot.data;
        return Slider(
          value: volume / 100,
          onChanged: (double value) {
            var targetVolume = (value * 100).toInt();
            controller.volume = targetVolume;
          },
        );
      },
    );
  }

  _buildSystemVolumeButton() {
    return FlatButton(
      child: Text("显示系统音量"),
      onPressed: () async {
        var systemVolume = await IjkManager.getSystemVolume();
        print(systemVolume);
      },
    );
  }
}
