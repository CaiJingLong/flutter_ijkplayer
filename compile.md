# Custom compilation options

This project can customize compilation options in the following ways.

- [Custom compilation options](#custom-compilation-options)
  - [Get source](#get-source)
  - [Initialization and compilation of projects](#initialization-and-compilation-of-projects)
    - [Compiling environment](#compiling-environment)
    - [General part](#general-part)
    - [android](#android)
    - [iOS](#ios)
  - [Compile the product into the flutter project](#compile-the-product-into-the-flutter-project)
    - [With iOS](#with-ios)
    - [With andorid](#with-andorid)
  - [LICENSE](#license)

## Get source

The modified source code is hosted on gitee.

`$ git clone https://gitee.com/kikt/ijkplayer_thrid_party.git ijkplayer`

or

`$ git clone https://cjlspy@dev.azure.com/cjlspy/ijkplayer_for_flutter/_git/ijkplayer_for_flutter ijkplayer`

## Initialization and compilation of projects

This section mainly refers to the official process. If you know something about ijkplayer, you can skip this section and look directly at the following links in flutter.
If this part encounters problems, you can ask questions officially.

### Compiling environment

I'm macOS here. If you're linux, you can compile the Android part.

IOS compilation can only be completed under macOS.

Windows: Please give up

### General part

This is the compilation option of ffmpeg in ijkplayer. You can modify this part of the code according to your own needs. The configuration here has the greatest impact on the size of the overall library file.

Your mac must have the soft:

- git
- yasm

Later, if you don't need the HTTPS protocol, you can skip all openssl-related initialization and compilation.

### android

- NDK r10e(Do not use higher versions, do not guarantee availability)
- Xcode
- Android SDK

Make sure your git, yasm, are in the environment variable.

Configure andorid SDK and NDK to environment variables.

```bash
export ANDROID_SDK=<your sdk path>
export ANDROID_NDK=<your ndk path>
```

initial:

```bash
./init-config.sh
./init-android.sh
./init-android-openssl.sh
```

compile:

```bash
cd android/contrib
./compile-ffmpeg.sh clean
./compile-openssl.sh clean
./compile-openssl.sh all
./compile-ffmpeg.sh all
cd ..
./compile-ijk.sh all
```

After waiting here, you can copy so files in your corresponding CPU type. Here are the library files that will be applied to the project in the future.

### iOS

initial:

```bash
./init-config.sh
./init-ios.sh
./init-ios-openssl.sh
```

compile

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

Here's a quick way to use it directly after cleaning.
`./compile-common.sh`

The next step needs to be done in xcode. Here is Xcode 10.

`$ open ios/IJKMediaPlayer/IJKMediaPlayer.xcodeproj`

Don't choose the SSL project here.
![1](https://raw.githubusercontent.com/CaiJingLong/asset_for_picgo/master/20190322205338.png)

Edit Scheme
![1](https://raw.githubusercontent.com/CaiJingLong/asset_for_picgo/master/20190322205412.png)

Release
![1](https://raw.githubusercontent.com/CaiJingLong/asset_for_picgo/master/20190322205454.png)

command+b to compile library.
![1](https://raw.githubusercontent.com/CaiJingLong/asset_for_picgo/master/20190322205548.png)

choose iOS device
![1](https://raw.githubusercontent.com/CaiJingLong/asset_for_picgo/master/20190322205634.png)

compile with `command+b`
![1](https://raw.githubusercontent.com/CaiJingLong/asset_for_picgo/master/20190322205727.png)

open product
![1](https://raw.githubusercontent.com/CaiJingLong/asset_for_picgo/master/20190322205727.png)

cd into Products
![1](https://raw.githubusercontent.com/CaiJingLong/asset_for_picgo/master/20190322205839.png)

cd dir in shell.

such as: `$ cd ~/Library/Developer/Xcode/DerivedData/IJKMediaPlayer-bpuwtjeeipcfgffpcjhynhwsndig/Build/Products`

lipo your device and simulator.

```bash
lipo -create Release-iphoneos/IJKMediaFramework.framework/IJKMediaFramework Release-iphonesimulator/IJKMediaFramework.framework/IJKMediaFramework -output IJKMediaFramework

cp IJKMediaFramework Release-iphoneos/IJKMediaFramework.framework

open Release-iphoneos/
```

The IJKMediaFramework.framework is a folder.

## Compile the product into the flutter project

1. Download or clone the project to a separate folder in your flutter project

2. Edit your pubspec.yaml

from

```yaml
dependencies:
  flutter_ijkplayer: ^0.x.x
```

to

```yaml
dependencies:
  flutter_ijkplayer:
    path: ./flutter_ijkplayer
```

### With iOS

Copy IJKMediaFramework.framework folder into `flutter_ijkplayer/iOS`,

and edit your podspec file:

From

![20190402141140.png](https://raw.githubusercontent.com/kikt-blog/image/master/img/20190402141140.png)

to

![20190402141203.png](https://raw.githubusercontent.com/kikt-blog/image/master/img/20190402141203.png)

### With andorid

Copy all ijkplayer so files into `flutter_ijkplayer/android/src/main/libs/${CPU}` and replace all.

## LICENSE

The project base on bilibili/ijkplayer 's 0.8.8 version. Before you use it, you need to make sure that your project meets ijkplayer's requirements.

Part of the iOS code in the project comes from https://github.com/jadennn/flutter_ijk, all of which are based on the MIT protocol.

The protocol used in my modified framework code is the same as bilibili/ijkplayer.
