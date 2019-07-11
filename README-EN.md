# ijkplayer

[![pub package](https://img.shields.io/pub/v/flutter_ijkplayer.svg)](https://pub.dartlang.org/packages/flutter_ijkplayer)

ijkplayer for [bilibili/ijkplayer](https://github.com/bilibili/ijkplayer), use flutter Texture widget.
Read this README and refer to example/lib/main.dart before using it.
The question of Android might not be able to run will be explained in detail.
The simulator is out of use, so please use the real machine for debugging.

- Android: I added the so Library of x86, but my voice decoding here is abnormal.
- iOS: The simulator library is added, but it has sound and no pictures.

Before using library, you can star and download the code to try the example.

## Menu

- [ijkplayer](#ijkplayer)
  - [Menu](#Menu)
  - [Install](#Install)
  - [Build](#Build)
    - [Custom compile library](#Custom-compile-library)
    - [iOS](#iOS)
    - [Android](#Android)
  - [Simple Example](#Simple-Example)
  - [Usage](#Usage)
    - [Usage of ijkplayer](#Usage-of-ijkplayer)
    - [about dispose](#about-dispose)
    - [Usage of controller](#Usage-of-controller)
      - [DataSource](#DataSource)
      - [control your media](#control-your-media)
      - [get media info](#get-media-info)
      - [screen shot](#screen-shot)
      - [Observer for resource](#Observer-for-resource)
      - [Media Speed](#Media-Speed)
      - [IjkStatus](#IjkStatus)
      - [Custom Options](#Custom-Options)
        - [IjkOptionCategory](#IjkOptionCategory)
      - [release resource](#release-resource)
    - [Use self controller UI](#Use-self-controller-UI)
    - [Build widget from IjkStatus](#Build-widget-from-IjkStatus)
    - [Use Texture widget](#Use-Texture-widget)
  - [LICENSE](#LICENSE)

## Install

[![pub package](https://img.shields.io/pub/v/flutter_ijkplayer.svg)](https://pub.dartlang.org/packages/flutter_ijkplayer)

pubspec.yaml

```yaml
dependencies:
  flutter_ijkplayer: ${latest_version}
```

## Build

### Custom compile library

Current config file see [url](https://gitee.com/kikt/ijkplayer_thrid_party/blob/master/config/module.sh).

For custom configuration options, refer to the [bibibili/ijkplayer](https://github.com/bilibili/ijkplayer) or [ffmpeg](http://ffmpeg.org/).

Custom compilation source document:
https://github.com/CaiJingLong/flutter_ijkplayer/blob/master/compile.md

Because I edit some source, so you must see the compile.md to customize your library.

### iOS

Because the libraries of some iOS codes are large, a pod-dependent ijkplayer library for hosting iOS is created.
The pod library is hosted in the GitHub repository at https://github.com/CaiJingLong/flutter_ijkplayer_pod
Instead of tar.gz or zip, we use tar.xz to compress. This compression format has high compression rate, but slow compression and decompression speed. Considering the way of high compression rate, we should use high compression rate.
If a friend is willing to provide CDN acceleration, you can contact me
IOS code comes from iOS code in https://github.com/jadennn/flutter_ijk
On this basis, rotation notification is added.

### Android

Now, use compilation options in [GSYVideoPlayer](https://github.com/CarGuo/GSYVideoPlayer).

## Simple Example

```dart
import 'package:flutter_ijkplayer/flutter_ijkplayer.dart';


class HomePageState extends State<HomePage> {
  IjkMediaController controller = IjkMediaController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
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
          ]
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.play_arrow),
        onPressed: () async {
          await controller.setNetworkDataSource(
              'https://www.sample-videos.com/video123/mp4/720/big_buck_bunny_720p_20mb.mp4',
              // 'rtmp://172.16.100.245/live1',
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
      // height: 400,
      child: IjkPlayer(
        mediaController: controller,
      ),
    );
  }
}
```

## Usage

### Usage of ijkplayer

```dart
IjkMediaController controller = IjkMediaController();
```

```dart
  var ijkplayer = IjkPlayer(
    mediaController: controller,
  );
```

### about dispose

Users need to call `dispose` method to release resources when they decide that they will no longer use controllers. If they do not call `dispose` method, the resources will not be released.

Since a `controller` may be attached by multiple `IjkPlayers`, leading to a `controller` controlling multiple `IjkPlayers`, it is not in principle possible to agree with `dispose`of `IjkPlayer`, so the caller needs to dispose of itself here.

```dart
controller.dispose();
```

### Usage of controller

#### DataSource

```dart
// network
await controller.setNetworkDataSource("https://www.sample-videos.com/video123/mp4/720/big_buck_bunny_720p_20mb.mp4");

// Custom headers for network source
await controller.setNetworkDataSource(url, headers: <String,String>{});

// asset
await controller.setAssetDataSource("assets/test.mp4");

// file
await controller.setFileDataSource(File("/sdcard/1.mp4"));

// dataSource
var dataSource = DataSource.file(File("/sdcard/1.mp4"));
var dataSource = DataSource.network("https://www.sample-videos.com/video123/mp4/720/big_buck_bunny_720p_20mb.mp4", headers:<String,String>{});
var dataSource = DataSource.asset("assets/test.mp4");
await controller.setDataSource(dataSource);


// autoplay param
await controller.setNetworkDataSource("https://www.sample-videos.com/video123/mp4/720/big_buck_bunny_720p_20mb.mp4",autoPlay : true);

// or use play()
await controller.setNetworkDataSource("https://www.sample-videos.com/video123/mp4/720/big_buck_bunny_720p_20mb.mp4");
await controller.play();
```

#### control your media

```dart
// play or pause your media
await controller.playOrPause();

// play your media
await controller.play();

// pause your media
await controller.pause();

// stop
// Here I want to explain that ijkplayer's stop releases resources, which makes play unusable and requires re-preparation of resources. So, in fact, this is to go back to the progress bar and pause.
await controller.stop();

// seek progress to
await controller.seekTo(0); // double value , such as : 1.1 = 1s100ms, 60 = 1min
```

#### get media info

```dart
  // have some properties, width , height , duration
  VideoInfo info = await controller.getVideoInfo();
```

#### screen shot

Intercept the current video frame
This video frame comes from the video frame currently decoded by ffmpeg and does not contain the contents of the controller, etc.
The format in dart is Uint8List.

```dart
var uint8List = await controller.screenShot();
var provider = MemoryImage(uint8List);
Widget image = Image(image:provider);
```

**This is not always the same as the video on display. This is because it intercepts the decoded full video frame, which may be 1-2 frames faster than the current play.** If you can't accept it, please don't use this feature or submit a viable PR.

#### Observer for resource

Broadcasting changes in information outward in the form of streams, in principle the attributes ending with streams are monitorable.

```dart
// Callback when texture ID changes
Stream<int> textureIdStream = controller.textureIdStream;

// Play status monitoring, true is playing, false is pausing
Stream<bool> playingStream = controller.playingStream;

// When controller. refreshVideoInfo () is called, this method calls back, usually for the customization of the controller UI, so as to monitor the current information (playback progress, playback status, width, height, direction change, etc.).
Stream<VideoInfo> videoInfoStream = controller.videoInfoStream;

// Volume change, which should be noted here, refers to the volume change of the current media, not the volume change of the system.
Stream<bool> volumeStream = controller.playingStream;

// When the state changes, the stream is called.
// Detailed descriptions of specific states can be seen in the table below.
Stream<IjkStatus> ijkStatusStream = controller.ijkStatusStream;

```

#### Media Speed

code:

```dart
controller.setSpeed(2.0);
```

Default speed is 1.0, the min value need bigger than 0

Because of the speed change, the tone will change. So you need to use an option to keep the tone unchanged. The option **default value is open**, and if you want to close it, use the code:

```dart
IjkMediaController(needChangeSpeed: false); // set needChangeSpeed to false, the tone will change on speed change.
```

#### IjkStatus

| name              | describe                                                       |
| ----------------- | -------------------------------------------------------------- |
| noDatasource      | The initial state, or the state after calling the reset method |
| preparing         | After setting up src, get ready before src.                    |
| setDatasourceFail | After setting datasource failed.                               |
| prepared          | The datasource was prepared.                                   |
| pause             | Media pause.                                                   |
| error             | An error occurred in playback.                                 |
| playing           | Media is playing.                                              |
| complete          | Media is play complete.                                        |
| disposed          | After Controller calls `dispose()`.                            |

#### Custom Options

**This function may cause problems, such as not playing, etc.** Stop using this feature if you find that you cannot use or have an exception after setting options.

Support custom IJKPlayer options, which are transmitted directly to Android/iOS native. For specific values and meanings, you need to see bilibili/ijkplayer](https://github.com/bilibili/ijkplayer).

However, this option does not take effect immediately.
It will only take effect if you call `setDataSource` again.

Setup method `setIjkPlayerOptions`

```dart
void initIjkController() async {
  var option1 = IjkOption(IjkOptionCategory.format, "fflags", "fastseek");// category, key ,value

  controller.setIjkPlayerOptions(
    [TargetPlatform.iOS, TargetPlatform.android],
    [option1].toSet(),
  );

  await controller.setDataSource(
    DataSource.network(
        "http://img.ksbbs.com/asset/Mon_1703/05cacb4e02f9d9e.mp4"),
    autoPlay: true,
  );
}
```

The first parameter is an array that represents the type of device you choose to target (android/iOS).

The second parameter is a `Set<IjkOption>`, which represents the set of Option, because both categories and keys are covered, so set is used here.

##### IjkOptionCategory

| name   |
| ------ |
| format |
| codec  |
| sws    |
| player |

#### release resource

```dart
await controller.reset(); // When this method is called, all native resources are released, but the dataSource is still available for resetting.

await controller.dispose(); // After this method call, the current controller is theoretically no longer available, resetting dataSource is invalid and may throw an exception.
```

### Use self controller UI

Use `IJKPlayer`'s `controllerWidgetBuilder` params can customize UI, default use `defaultBuildIjkControllerWidget` method to get widget.

The type def sign: `typedef Widget IJKControllerWidgetBuilder(IjkMediaController controller);`

The returned widget will be overwritten on the `Texture`.

```dart
IJKPlayer(
  mediaController: IjkMediaController(),
  controllerWidgetBuilder: (mediaController){
    return Container(); // your controller widget.
  },
);
```

The library use `DefaultIJKControllerWidget` to build the widget.

This class provides some properties for customization. All properties except `controller` are optional:

|               name                |            type            |         default          |                                      desc                                      |
| :-------------------------------: | :------------------------: | :----------------------: | :----------------------------------------------------------------------------: |
|           doubleTapPlay           |            bool            |          false           |                            doubleTap gesture switch                            |
|          verticalGesture          |            bool            |           true           |                            vertical gesture switch                             |
|         horizontalGesture         |            bool            |           true           |                           horizontal gesture switch                            |
|            volumeType             |         VolumeType         |    VolumeType.system     |           vertical gesture changes the type of sound (system,media)            |
|        playWillPauseOther         |            bool            |           true           |                     play the video will pause other medias                     |
|      currentFullScreenState       |            bool            |          false           | **If you are customizing the full screen interface, this must be set to true** |
|       showFullScreenButton        |            bool            |           true           |                   Whether to display the full screen button                    |
| fullscreenControllerWidgetBuilder | IJKControllerWidgetBuilder |                          |                    Can customize the full screen interface                     |
|          fullScreenType           |       FullScreenType       | FullScreenType.rotateBox |               Full screen type (rotate screen, or use RotateBox)               |

### Build widget from IjkStatus

Build different widgets based on the current state.

```dart

Widget buildIjkPlayer() {
  return IjkPlayer(
    mediaController: mediaController,
    stateWidgetBuilder: _buildStatusWidget,
  );
}

Widget _buildStatusWidget(
  BuildContext context,
  IjkMediaController controller,
  IjkStatus status,
) {
  if (status == IjkStatus.noDatasource) {
    return Center(
      child: Text(
        "no data",
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  // you can custom your self status widget
  return IjkStatusWidget.buildStatusWidget(context, controller, status);
}
```

### Use Texture widget

Use `textureBuilder` params to customize `Texture` widget, use `playerBuilder` in before 0.1.8 version.

Default use `buildDefaultIjkPlayer` method, params is `context,controller,videoInfo` and reture a `Widget`.

```dart
IJKPlayer(
  mediaController: IjkMediaController(),
  textureBuilder: (context,mediaController,videoInfo){
    return Texture(); /// Your `Texture` widget
  },
);
```

## LICENSE

MIT
