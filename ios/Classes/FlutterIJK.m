//
// Created by Caijinglong on 2019-03-08.
//

#import "FlutterIJK.h"
#import <IJKMediaFramework/IJKMediaFramework.h>
#import <IJKMediaFramework/IJKMediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import <libkern/OSAtomic.h>

@interface IJKVideoPlayer : NSObject <FlutterTexture>
@property(nonatomic, strong) IJKFFMoviePlayerController *controller;
@property(nonatomic, strong) NSObject <FlutterTextureRegistry> *textures;
@property(nonatomic, assign) int64_t textureId;

- (void)setDataSource:(NSString *)uri;

- (void)play;

- (void)dispose;
@end

@interface FlutterIJK ()
@end

@implementation FlutterIJK {
    int64_t textureId;
    IJKVideoPlayer *player;
    CADisplayLink *displayLink;
}
- (instancetype)initWithRegistrar:(NSObject <FlutterPluginRegistrar> *)registrar {
    self = [super init];
    if (self) {
        self.registrar = registrar;
        NSObject <FlutterTextureRegistry> *textures = [self.registrar textures];
        player = [IJKVideoPlayer new];
        textureId = [textures registerTexture:player];
        player.textureId = textureId;
        player.textures = textures;
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
//    IJKFFMoviePlayerController *ctl = [player controller];
//    [ctl stop];
//    [ctl shutdown];
    [[self.registrar textures]unregisterTexture:self.id];
    [player dispose];
}

- (void)play {
    [player play];
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
    CADisplayLink *displayLink;
    CVPixelBufferRef latestPixelBuffer;
}

- (instancetype)init {
    self = [super init];
    if (self) {

    }

    return self;
}

- (CVPixelBufferRef _Nullable)copyPixelBuffer {
    NSLog(@"copyPixelBuffer is running");
    CVPixelBufferRef newBuffer = [self.controller framePixelbuffer];
    if(newBuffer){
        CFRetain(newBuffer);
        CVPixelBufferRef pixelBuffer = latestPixelBuffer;
        while (!OSAtomicCompareAndSwapPtrBarrier(pixelBuffer, newBuffer, (void **)&latestPixelBuffer)) {
            pixelBuffer = latestPixelBuffer;
        }
        
        return pixelBuffer;
    }
    return NULL;
}

- (void)setDataSource:(NSString *)uri {
    IJKFFOptions *options = [IJKFFOptions optionsByDefault];
    self.controller = [[IJKFFMoviePlayerController alloc] initWithContentURLString:uri withOptions:options];
    [self.controller prepareToPlay];
    displayLink = [CADisplayLink displayLinkWithTarget:self
                                              selector:@selector(onDisplayLink:)];
    [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    displayLink.paused = YES;
}

- (void)onDisplayLink:(CADisplayLink *)link {
    [self.textures textureFrameAvailable:self.textureId];
//    CVPixelBufferRef ref = [self copyPixelBuffer];
//    NSLog(@"buffer = %p", ref);
}

- (void) play{
    [self.controller play];
    displayLink.paused = NO;
}

- (void) dispose{
    [self.controller stop];
    [self.controller shutdown];
    self.controller = nil;
    displayLink.paused = YES;
    [displayLink invalidate];
}

@end
