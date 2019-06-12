//
// Created by Caijinglong on 2019-03-15.
//

#import "CoolIjkNotifyChannel.h"
#import "CoolVideoInfo.h"


@implementation CoolIjkNotifyChannel {
    FlutterMethodChannel *channel;
}

- (instancetype)initWithController:(IJKFFMoviePlayerController *)controller textureId:(int64_t)textureId
                         registrar:(NSObject <FlutterPluginRegistrar> *)registrar {
    self = [super init];
    if (self) {
        self.controller = controller;
        self.textureId = textureId;
        self.registrar = registrar;
        [self initial];
    }

    return self;
}

+ (instancetype)channelWithController:(IJKFFMoviePlayerController *)controller textureId:(int64_t)textureId
                            registrar:(NSObject <FlutterPluginRegistrar> *)registrar {
    return [[self alloc] initWithController:controller textureId:textureId registrar:registrar];
}


- (void)initial {
    NSString *channelName = [NSString stringWithFormat:@"top.kikt/ijkplayer/event/%lli", self.textureId];
    channel = [FlutterMethodChannel methodChannelWithName:channelName binaryMessenger:[self.registrar messenger]];
    [self registerObserver];
}

- (void)dispose {
    channel = nil;
    [self unregisterObservers];
}


- (void)registerObserver {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadStateDidChange:)
                                                 name:IJKMPMoviePlayerLoadStateDidChangeNotification
                                               object:_controller];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackFinish:)
                                                 name:IJKMPMoviePlayerPlaybackDidFinishNotification
                                               object:_controller];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(mediaIsPreparedToPlayDidChange:)
                                                 name:IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification
                                               object:_controller];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackStateDidChange:)
                                                 name:IJKMPMoviePlayerPlaybackStateDidChangeNotification
                                               object:_controller];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(movieRotationChange:)
                                                 name:IJKMPMoviePlayerVideoRotationNotification
                                               object:_controller];
}

- (void)unregisterObservers {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:IJKMPMoviePlayerLoadStateDidChangeNotification
                                                  object:_controller];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:IJKMPMoviePlayerPlaybackDidFinishNotification
                                                  object:_controller];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification
                                                  object:_controller];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:IJKMPMoviePlayerPlaybackStateDidChangeNotification
                                                  object:_controller];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:IJKMPMoviePlayerVideoRotationNotification
                                                  object:_controller];
}

- (NSDictionary *)getInfo {
    return [[_infoDelegate getInfo] toMap];
}

- (void)moviePlayBackStateDidChange:(NSNotification *)notification {
    [channel invokeMethod:@"playStateChange" arguments:[self getInfo]];
}

- (void)mediaIsPreparedToPlayDidChange:(NSNotification *)notification {
    [channel invokeMethod:@"prepare" arguments:[self getInfo]];
}


- (void)moviePlayBackFinish:(NSNotification *)notification {
    int reason = [[[notification userInfo] valueForKey:IJKMPMoviePlayerPlaybackDidFinishReasonUserInfoKey] intValue];
    int type = 2;
    switch (reason) {
        case IJKMPMovieFinishReasonPlaybackEnded:
            type = 0;
            break;
        case IJKMPMovieFinishReasonUserExited:
            type = 1;
            break;
        case IJKMPMovieFinishReasonPlaybackError:{
            int errValue = [[[notification userInfo] valueForKey:@"error"] intValue];
            [channel invokeMethod:@"error" arguments:@(errValue)];
            return;
        }
        default:
            break;
    }
    NSLog(@"type = %d", type);
//    [channel invokeMethod:@"finish" arguments:@{@"type": @(type)}];
    [channel invokeMethod:@"finish" arguments:[self getInfo]];
}

- (void)loadStateDidChange:(NSNotification *)notification {
    NSLog(@"load state change, state = %lu", (unsigned long)_controller.loadState);
    [self.infoDelegate onLoadStateChange];
}

- (void)movieRotationChange:(NSNotification *)notification {
    int rotate = [[[notification userInfo] valueForKey:IJKMPMoviePlayerVideoRotationRotateUserInfoKey] intValue];
    [_infoDelegate setDegree:rotate];
    [channel invokeMethod:@"rotateChanged" arguments:[self getInfo]];
}

@end
