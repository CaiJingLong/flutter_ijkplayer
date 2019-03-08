//
// Created by Caijinglong on 2019-03-08.
//

#import "FlutterIJK.h"
#import <IJKMediaFramework/IJKMediaFramework.h>
#import <IJKMediaFramework/IJKMediaPlayer.h>
#import <AVFoundation/AVFoundation.h>

@interface IJKVideoPlayer : NSObject <FlutterTexture>
@property(nonatomic, strong) IJKFFMoviePlayerController *controller;

- (void)setDataSource:(NSString *)uri;
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
        player = [IJKVideoPlayer new];
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

- (void)dispose {
    IJKFFMoviePlayerController *ctl = [player controller];
    [ctl stop];
    [ctl shutdown];
}

- (void)play {
    IJKFFMoviePlayerController *ctl = [player controller];
    [ctl play];
}

- (void)pause {
    [[player controller] pause];
}

- (void)stop {
    [[player controller] stop];
}

- (void)setDateSourceWithUri:(NSString *)uri {
    [player setDataSource:uri];
}

@end

@implementation IJKVideoPlayer {
//    IJKFFMoviePlayerController *controller;
}

- (instancetype)init {
    self = [super init];
    if (self) {

    }

    return self;
}


- (CVPixelBufferRef _Nullable)copyPixelBuffer {
    return [self.controller framePixelbuffer];
}

- (void)setDataSource:(NSString *)uri {
    IJKFFOptions *options = [IJKFFOptions optionsByDefault];
    self.controller = [[IJKFFMoviePlayerController alloc] initWithContentURLString:uri withOptions:options];
    [self.controller prepareToPlay];
}


@end
