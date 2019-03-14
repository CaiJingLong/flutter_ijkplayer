//
// Created by Caijinglong on 2019-03-08.
//

#import "FlutterIJK.h"
#import <IJKMediaFramework/IJKMediaFramework.h>
#import <IJKMediaFramework/IJKMediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import <libkern/OSAtomic.h>

@interface FlutterIJK () <FlutterTexture>
@end

@implementation FlutterIJK {
    int64_t textureId;
    CADisplayLink *displayLink;
    NSObject <FlutterTextureRegistry> *textures;
    IJKFFMoviePlayerController *controller;
    CVPixelBufferRef latestPixelBuffer;
    FlutterMethodChannel *channel;
    FlutterMethodCallHandler handler;
}

- (instancetype)initWithRegistrar:(NSObject <FlutterPluginRegistrar> *)registrar {
    self = [super init];
    if (self) {
        self.registrar = registrar;
        textures = [self.registrar textures];
        textureId = [textures registerTexture:self];
        NSString *channelName = [NSString stringWithFormat:@"top.kikt/ijkplayer/%lli", textureId];
        channel = [FlutterMethodChannel methodChannelWithName:channelName binaryMessenger:[registrar messenger]];
        [channel setMethodCallHandler:^(FlutterMethodCall *call, FlutterResult result) {
            [self handleMethodCall:call result:result];
        }];
    }

    return self;
}

- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result {
    if ([@"play" isEqualToString:call.method]) {
        [self play];
    } else if ([@"pause" isEqualToString:call.method]) {
        [self pause];
    } else if ([@"stop" isEqualToString:call.method]) {
        [self stop];
    } else if ([@"setDataSource" isEqualToString:call.method]) {
        @try {
            NSDictionary *params = call.arguments;
            NSString *uri = params[@"uri"];
            [self setDateSourceWithUri:uri];
            result(nil);
        }
        @catch (NSException *exception) {
            NSLog(@"Exception occurred: %@, %@", exception, [exception userInfo]);
            result([FlutterError errorWithCode:@"1" message:@"设置失败" details:nil]);
        }
    }
}

+ (instancetype)ijkWithRegistrar:(NSObject <FlutterPluginRegistrar> *)registrar {
    return [[self alloc] initWithRegistrar:registrar];
}

- (int64_t)id {
    return textureId;
}

- (void)dispose {
    [[self.registrar textures]unregisterTexture:self.id];
    [controller stop];
    [controller shutdown];
    controller = nil;
    displayLink.paused = YES;
    [displayLink invalidate];
}

- (void)play {
    [controller play];
}

- (void)pause {
    [controller pause];
}

- (void)stop {
    [controller stop];
}

- (void)setDateSourceWithUri:(NSString *)uri {
    IJKFFOptions *options = [IJKFFOptions optionsByDefault];
    controller = [[IJKFFMoviePlayerController alloc] initWithContentURLString:uri withOptions:options];
    [controller prepareToPlay];
    displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(onDisplayLink:)];
    [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    displayLink.paused = YES;
}

- (void)onDisplayLink:(CADisplayLink *)link {
    [textures textureFrameAvailable:textureId];
}

- (CVPixelBufferRef _Nullable)copyPixelBuffer {
    CVPixelBufferRef newBuffer = [controller framePixelbuffer];
    if (newBuffer) {
        CFRetain(newBuffer);
        CVPixelBufferRef pixelBuffer = latestPixelBuffer;
        while (!OSAtomicCompareAndSwapPtrBarrier(pixelBuffer, newBuffer, (void **) &latestPixelBuffer)) {
            pixelBuffer = latestPixelBuffer;
        }

        return pixelBuffer;
    }
    return NULL;
}


@end
