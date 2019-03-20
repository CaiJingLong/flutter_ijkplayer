# ijkplayer

ijkplayer,通过纹理的方式接入 bilibili/ijkplayer

使用前请完整阅读本 README 并参阅 example/lib/main.dart

有关 android 可能跑不起来的问题会详细解释

模拟器用不了,所以调试请使用真机

- android: 我加入了 x86 的 so 库,但是我这里声音解码异常
- iOS: 加入了模拟器的库,但是有声音,无图片

在正式使用前,可以先 star 一下, download 代码跑一下 example 尝试

## English Readme

https://github.com/CaiJingLong/flutter_ijkplayer/blob/master/README-EN.md

## Install

pubspec.yaml

```yaml
dependencies:
  flutter_ijkplayer: ^0.1.0
```

## Build

编译规则可以参考这个,如果你有自己的特定需求,可以修改编译选项,这个参考 bilibili/ijkplayer 或 ffmpeg

https://github.com/CaiJingLong/flutter_ijkplayer_pod/blob/master/config/module.sh

### iOS

因为 iOS 部分代码的库文件比较大,所以创建了一个 pod 依赖托管 iOS 的 ijkplayer 库  
pod 库托管在 github 仓库内 https://github.com/CaiJingLong/flutter_ijkplayer_pod  
没有采用通用的 tar.gz 或 zip,而是使用 tar.xz 的方式压缩,这个压缩格式压缩率高,但是压缩和解压缩的的速度慢,综合考虑使用高压缩率的方式  
如果有朋友愿意提供 cdn 加速,可以联系我 😁

iOS 的代码来自于 https://github.com/jadennn/flutter_ijk 中的 iOS 代码
在这基础上增加了旋转通知

### Android

和 iOS 不同,这个没有修改,而是使用 bilibili 的 0.8.8 版+openssl 编译的 so 库

构建时可能会报错,或者闪退,这个是因为 so 库的问题

vscode: 你需要修改.vscode/launch.json
添加 `"args": ["--target-platform", "android-arm"]`

android studio: 你需要点击 run 左边那个 main.dart=>Edit Configurations,然后在 Additional Arguments 中添加 `--target-platform android-arm`

打包时同理,尽量只保留 armv7 就可以了

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
      // height: 400, // 这里随意
      child: IjkPlayer(
        mediaController: controller,
      ),
    );
  }
}
```

## Usage

### 设置

每个 ijkplayer 对应一个 IjkMediaController;

```dart
IjkMediaController controller = IjkMediaController();
```

将 controller 设置给 ijkplayer

```dart
  var ijkplayer = IjkPlayer(
    mediaController: controller,
  );
```

### 控制器的使用

#### 设置资源

```dart
// 根据你的资源类型设置,设置资源本身是耗时操作,建议await

// 网络
await controller.setNetworkDataSource("https://www.sample-videos.com/video123/mp4/720/big_buck_bunny_720p_20mb.mp4");

// 应用内资源
await controller.setAssetDataSource("assets/test.mp4");

// 文件
await controller.setFileDataSource(File("/sdcard/1.mp4"));

// 还可以添加autoplay参数,这样会在资源准备完成后自动播放
await controller.setNetworkDataSource("https://www.sample-videos.com/video123/mp4/720/big_buck_bunny_720p_20mb.mp4",autoPlay : true);

//或者也可以在设置资源完毕后自己调用play
await controller.setNetworkDataSource("https://www.sample-videos.com/video123/mp4/720/big_buck_bunny_720p_20mb.mp4");
await controller.play();
```

#### 播放的控制

```dart
// 播放或暂停
await controller.playOrPause();

// 不管当前状态,直接play
await controller.play();

// 不管当前状态,直接pause
await controller.pause();

// 停止
// 这里要说明,ijkplayer的stop会释放资源,导致play不能使用,需要重新准备资源,所以这里其实采用的是回到进度条开始,并暂停
await controller.stop();

// 进度跳转
await controller.seekTo(0); //这里是一个double值, 单位是秒, 如1秒100毫秒=1.1s 1分钟=60.0
```

#### 获取播放信息

```dart
  // 包含了一些信息,是否在播放,视频宽,高,视频角度,当前播放进度,总长度等信息
  VideoInfo info = await controller.getVideoInfo();
```

#### 资源监听

使用 stream 的形式向外广播一些信息的变化,原则上以 stream 结尾的属性都是可监听的

```dart
// 当纹理id发生变化时的回调,这个对于用户不敏感
Stream<int> textureIdStream = controller.textureIdStream;

// 播放状态的监听,true为正在播放,false为暂停
Stream<bool> playingStream = controller.playingStream;

// 当有调用controller.refreshVideoInfo()时,这个方法会回调,一般用于controllerUI的自定义,以便于监听当前信息(播放进度,播放状态,宽,高,方向变化等)
Stream<VideoInfo> videoInfoStream = controller.videoInfoStream;

// 音量的变化,这里需要注意,这个变化指的是当前媒体的音量变化,而不是系统的音量变化
Stream<bool> volumeStream = controller.playingStream;
```

#### 释放资源

```dart
await controller.reset(); // 这个方法调用后,会释放所有原生资源,但重新设置dataSource依然可用

await controller.dispose(); //这个方法调用后,当前控制器理论上不再可用,重新设置dataSource无效
```

## Progress

目前正处于初始开发阶段,可能有各种问题,欢迎提出,但不一定会实现,也不一定会修改 😌

最初准备参考官方 video_player 的 api 方式进行开发,但是觉得调用的方式比较奇怪

需要自定义 LifeCycle 进行管理,而且自定义控制器不太方便,遂决定重写 api 的代码结构,同时清晰逻辑

## TodoList

- [x] 控制器逻辑
- [x] 默认控制器 UI
  - [x] 进度条
  - [x] 播放/暂停按钮
  - [x] 横向滑动进度
  - [x] 纵向滑动音量
  - [x] 单击显示/隐藏界面
  - [x] 双击播放/暂停
  - [ ] 拖动进度条快速调节进度
  - [ ] 使用选项切换音量的控制是系统音量还是资源音量
- [x] 根据视频角度自动旋转
- [x] 保证图片宽高比不失真
- [x] 允许自定义控制器 UI

初版为预览版,不保证质量,欢迎试用

UI 控制功能包含常见的播放停止,手势拖动

## LICENSE

MIT
