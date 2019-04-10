# 自定义编译选项

本项目可以通过以下的方式自定义编译选项

- [自定义编译选项](#%E8%87%AA%E5%AE%9A%E4%B9%89%E7%BC%96%E8%AF%91%E9%80%89%E9%A1%B9)
  - [获取 ijkplayer 的源码](#%E8%8E%B7%E5%8F%96-ijkplayer-%E7%9A%84%E6%BA%90%E7%A0%81)
  - [初始化及编译项目](#%E5%88%9D%E5%A7%8B%E5%8C%96%E5%8F%8A%E7%BC%96%E8%AF%91%E9%A1%B9%E7%9B%AE)
    - [编译环境](#%E7%BC%96%E8%AF%91%E7%8E%AF%E5%A2%83)
    - [通用部分](#%E9%80%9A%E7%94%A8%E9%83%A8%E5%88%86)
    - [android 部分](#android-%E9%83%A8%E5%88%86)
    - [iOS](#ios)
  - [编译产物置入 flutter 项目](#%E7%BC%96%E8%AF%91%E4%BA%A7%E7%89%A9%E7%BD%AE%E5%85%A5-flutter-%E9%A1%B9%E7%9B%AE)
    - [iOS 篇](#ios-%E7%AF%87)
    - [andorid 篇](#andorid-%E7%AF%87)
  - [LICENSE](#license)

## 获取 ijkplayer 的源码

这部分修改后的源码托管于 gitee

`$ git clone https://gitee.com/kikt/ijkplayer_thrid_party.git ijkplayer`

或者使用

`$ git clone https://cjlspy@dev.azure.com/cjlspy/ijkplayer_for_flutter/_git/ijkplayer_for_flutter ijkplayer`

## 初始化及编译项目

这部分主要参考官方的过程,如果你对于 ijkplayer 有所了解,可以跳过这部分,直接看后面的在 flutter 中使用环节

如果这部分遇到问题可以去官方提问

### 编译环境

我这里是 macOS, 你如果是 linux,可以编译 android 部分

只有在 macOS 下才能完成 iOS 部分的编译

windows: 请放弃

### 通用部分

config/module.sh 是 ijkplayer 中 ffmpeg 的编译选项,你可以根据自己的需求去修改这部分代码, 这里的配置对于整体库文件的大小影响是最大的

Mac 下必须的软件:
git
yasm

因为后面有一些东西需要下载,所以建议你命令行能翻墙,不然可能会很慢(不翻墙一天可能下不完,翻墙 10 分钟内),另外浏览器翻墙和命令行不是一回事

检测终端是否可翻墙`curl google.com`

### android 部分

需求:

- NDK r10e (建议就使用这个,不要用高版本也不要用低版本,除非你很懂 ndk)
- Xcode
- Android SDK

保证你的 git,yasm,都在环境变量中

配置 andorid sdk 和 ndk 到环境变量中

```bash
export ANDROID_SDK=<your sdk path>
export ANDROID_NDK=<your ndk path>
```

初始化

```bash
./init-config.sh # 初始化配置
./init-android.sh # 初始安卓,这里可能会下载ffmpeg,耐心等待
./init-android-openssl.sh  # 初始android的openssl, 如果你不需要https协议,可以跳过这一步
```

编译

```bash
cd android/contrib
./compile-ffmpeg.sh clean
./compile-openssl.sh clean
./compile-openssl.sh all
./compile-ffmpeg.sh all
cd ..
./compile-ijk.sh all
```

这里等待完成后,你就可以到你对应的 cpu 类型中去复制 so 文件,这里就是后续要用应用到项目中的库文件了

![20190402140003.png](https://raw.githubusercontent.com/kikt-blog/image/master/img/20190402140003.png)
替换掉`android/src/main/libs`下的文件就可以了

### iOS

初始化

根目录下执行:

```bash
./init-config.sh
./init-ios.sh
./init-ios-openssl.sh
```

编译

```bash
cd ios
./compile-openssl.sh clean
./compile-ffmpeg.sh clean

./compile-openssl.sh arm64
./compile-openssl.sh x86_64
./compile-openssl.sh i386
./compile-openssl.sh lipo
./compile-ffmpeg.sh arm64
./compile-ffmpeg.sh x86_64
./compile-ffmpeg.sh i386
./compile-ffmpeg.sh lipo
```

这里有一个快捷方式,在 clean 后直接用
`./compile-common.sh`
就可以完成构建步骤了(这个脚本是我自己添加的)

接下来的步骤需要在 xcode 中操作,我这里是 xcode10

`$ open ios/IJKMediaPlayer/IJKMediaPlayer.xcodeproj`
这里可以直接从 xcode 中打开这个项目

这里不要选 SSL 那个项目
![1](https://raw.githubusercontent.com/CaiJingLong/asset_for_picgo/master/20190322205338.png)

Edit Scheme
![1](https://raw.githubusercontent.com/CaiJingLong/asset_for_picgo/master/20190322205412.png)

Release
![1](https://raw.githubusercontent.com/CaiJingLong/asset_for_picgo/master/20190322205454.png)

编译模拟器的 command+b
![1](https://raw.githubusercontent.com/CaiJingLong/asset_for_picgo/master/20190322205548.png)

选择 iOS Device
![1](https://raw.githubusercontent.com/CaiJingLong/asset_for_picgo/master/20190322205634.png)

编译真机的 command+b
![1](https://raw.githubusercontent.com/CaiJingLong/asset_for_picgo/master/20190322205727.png)

打开项目
![1](https://raw.githubusercontent.com/CaiJingLong/asset_for_picgo/master/20190322205727.png)

找到 Products 级别
![1](https://raw.githubusercontent.com/CaiJingLong/asset_for_picgo/master/20190322205839.png)

在命令行进入到这个目录

比如 `$ cd ~/Library/Developer/Xcode/DerivedData/IJKMediaPlayer-bpuwtjeeipcfgffpcjhynhwsndig/Build/Products`

合并真机和模拟器库为通用库

```bash
lipo -create Release-iphoneos/IJKMediaFramework.framework/IJKMediaFramework Release-iphonesimulator/IJKMediaFramework.framework/IJKMediaFramework -output IJKMediaFramework

cp IJKMediaFramework Release-iphoneos/IJKMediaFramework.framework

open Release-iphoneos/
```

这里的就是那个库文件了,iOS 中库是一个文件夹

## 编译产物置入 flutter 项目

1. 将项目 download 或 clone 到你的 flutter 项目中一个单独的文件夹

2. 修改项目的 pubspec.yaml 修改

从

```yaml
dependencies:
  flutter_ijkplayer: ^0.x.x
```

修改为:

```yaml
dependencies:
  flutter_ijkplayer:
    path: ./flutter_ijkplayer
```

### iOS 篇

复制这个 IJKMediaFramework.framework 文件夹到 `flutter_ijkplayer/iOS` 文件夹下,然后修改 podspec 文件

![20190402141140.png](https://raw.githubusercontent.com/kikt-blog/image/master/img/20190402141140.png)
修改这个文件为这样

![20190402141203.png](https://raw.githubusercontent.com/kikt-blog/image/master/img/20190402141203.png)

### andorid 篇

复制所有生成的 ijkplayer 的 so 库文件到 `flutter_ijkplayer/android/src/main/libs/${CPU}`下并且替换

## LICENSE

本项目基于 bilibili/ijkplayer 的 0.8.8 版本开发,使用前你需要确定你的项目满足 ijkplayer 的使用条件

项目中 iOS 有一部分代码来源于 https://github.com/jadennn/flutter_ijk 的选项,这部分的所有修改代码都基于 MIT 协议

本人修改的框架代码部分均与 bilibili/ijkplayer 相同
