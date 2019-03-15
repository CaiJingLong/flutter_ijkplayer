//
// Created by Caijinglong on 2019-03-15.
//

#import "KKIjkNotifyChannel.h"
#import "KKVideoInfo.h"


@implementation KKIjkNotifyChannel {
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
        case IJKMPMovieFinishReasonPlaybackError:
            break;
        default:
            break;
    }
    [channel invokeMethod:@"finish" arguments:@{@"type": @(type)}];
}

- (void)loadStateDidChange:(NSNotification *)notification {
//    [channel invokeMethod:@"loadStateChange" arguments:[self getInfo]];
}

@end