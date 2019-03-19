# ijkplayer

ijkplayer,通过纹理的方式接入 bilibili/ijkplayer

使用前请完整阅读本README并参阅 example/lib/main.dart

有关android跑不起来的问题会详细解释

## About English Readme

At present, it is a preview version, which can be easily used without providing English documents for the time being.
English documents will be provided after the main objectives have been completed.

待主要目标完成后再提供英文文档

## Install

pubspec.yaml  

```yaml
dependencies:
  flutter_ijkplayer: ^0.0.1 
```

## Build

编译规则可以参考这个,如果你有自己的特定需求,可以修改编译选项,这个参考bilibili/ijkplayer或ffmpeg

https://github.com/CaiJingLong/flutter_ijkplayer_pod/blob/master/config/module.sh

### iOS

因为iOS部分代码的库文件比较大,所以创建了一个pod依赖托管iOS的ijkplayer库  
pod库托管在github 仓库内 https://github.com/CaiJingLong/flutter_ijkplayer_pod  
没有采用通用的tar.gz或zip,而是使用tar.xz的方式压缩,这个压缩格式压缩率高,但是压缩和解压缩的的速度慢,综合考虑使用高压缩率的方式  
如果有朋友愿意提供全球cdn加速,可以联系我😁
  
iOS的代码来自于 https://github.com/jadennn/flutter_ijk 中的iOS代码  
在这基础上增加了旋转通知

### Android

和iOS不同,这个没有修改,而是使用bilibili的0.8.8版+openssl编译的so库

构建时可能会报错,或者闪退,这个是因为so库的问题

vscode: 你需要修改.vscode/launch.json
添加 `"args": ["--target-platform", "android-arm"]`

android studio: 你需要点击run左边那个main.dart=>Edit Configurations,然后在Additional Arguments中添加 `--target-platform android-arm`

打包时同理,尽量只保留armv7就可以了

如果你使用模拟器开发,就把参数替换为android-x86,目标机型参阅`flutter run -h` `--target-platform`内的介绍

## Progress

目前正处于初始开发阶段,可能有各种问题,欢迎提出

最初准备参考官方video_player的api方式进行开发,但是觉得调用的方式比较奇怪

需要自定义LifeCycle进行管理,而且自定义控制器不太方便,遂决定重写api的代码结构

## TodoList

- [X] 控制器逻辑

- [ ] 默认控制器UI

  - [ ] 纵向
  - [ ] 横向

初版为预览版,不保证质量
UI

## LICENSE

MIT