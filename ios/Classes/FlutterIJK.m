//
// Created by Caijinglong on 2019-03-08.
//

#import "FlutterIJK.h"
#import <IJKMediaFramework/IJKMediaFramework.h>
#import <IJKMediaFramework/IJKMediaPlayer.h>
#import <AVFoundation/AVFoundation.h>

@interface IJKVideoPlayer : NSObject <FlutterTexture>
@end

@interface FlutterIJK ()
@end

@implementation FlutterIJK {
    int64_t textureId;
    IJKVideoPlayer *player;
}
- (instancetype)initWithRegistrar:(NSObject <FlutterPluginRegistrar> *)registrar {
    self = [super init];
    if (self) {
        self.registrar = registrar;
        IJKMPMoviePlayerController *controller = [[IJKMPMoviePlayerController alloc] initWithContentURLString:@""];
        NSObject <FlutterTextureRegistry> *textures = [self.registrar textures];
        textureId = [textures registerTexture:player];
    }

    return self;
}

+ (instancetype)ijkWithRegistrar:(NSObject <FlutterPluginRegistrar> *)registrar {
    return [[self alloc] initWithRegistrar:registrar];
}

- (int64_t)id {
    return textureId;
}

@end

@implementation IJKVideoPlayer {
    IJKFFMoviePlayerController *controller;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        IJKFFOptions *options = [IJKFFOptions optionsByDefault];
        NSString *urlString = @"https://www.sample-videos.com/video123/mp4/720/big_buck_bunny_720p_1mb.mp4";
        controller = [[IJKFFMoviePlayerController alloc] initWithContentURLString:urlString withOptions:options];
        [controller prepareToPlay];
        [controller play];
    }

    return self;
}


- (CVPixelBufferRef _Nullable)copyPixelBuffer {
    return [controller framePixelbuffer];
}

@end