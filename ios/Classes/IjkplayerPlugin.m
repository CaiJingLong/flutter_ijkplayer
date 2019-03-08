#import "IjkplayerPlugin.h"

@implementation IjkplayerPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
          methodChannelWithName:@"top.kikt/ijkplayer"
                binaryMessenger:[registrar messenger]];
  IjkplayerPlugin* instance = [[IjkplayerPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {


  if ([@"create" isEqualToString:call.method]) {
  } else if ([@"dispose" isEqualToString:call.method]) {
  } else if ([@"play" isEqualToString:call.method]) {
  } else if ([@"pause" isEqualToString:call.method]) {
  } else if ([@"stop" isEqualToString:call.method]) {
  } else if ([@"setDataSource" isEqualToString:call.method]) {
  } else {
    result(FlutterMethodNotImplemented);
  }
}

@end
