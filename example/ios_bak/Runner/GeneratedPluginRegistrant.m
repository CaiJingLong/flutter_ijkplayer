//
//  Generated file. Do not edit.
//

#import "GeneratedPluginRegistrant.h"

#if __has_include(<flutter_ijkplayer/IjkplayerPlugin.h>)
#import <flutter_ijkplayer/IjkplayerPlugin.h>
#else
@import flutter_ijkplayer;
#endif

#if __has_include(<photo_manager/ImageScannerPlugin.h>)
#import <photo_manager/ImageScannerPlugin.h>
#else
@import photo_manager;
#endif

@implementation GeneratedPluginRegistrant

+ (void)registerWithRegistry:(NSObject<FlutterPluginRegistry>*)registry {
  [IjkplayerPlugin registerWithRegistrar:[registry registrarForPlugin:@"IjkplayerPlugin"]];
  [ImageScannerPlugin registerWithRegistrar:[registry registrarForPlugin:@"ImageScannerPlugin"]];
}

@end
