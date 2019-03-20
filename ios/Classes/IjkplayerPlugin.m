#import <AVKit/AVKit.h>
#import "IjkplayerPlugin.h"
#import "CoolFlutterIjkManager.h"
#import "CoolFlutterIJK.h"

@interface FlutterMethodCall (Ijk)
- (int64_t)getId;

- (int64_t)getIdParamFromDict;

- (NSString *)getStringParam:(NSString *)key;
@end

static IjkplayerPlugin *__sharedInstance;

@implementation IjkplayerPlugin {
    CoolFlutterIjkManager *manager;

}

+ (instancetype)sharedInstance {
    return __sharedInstance;
}


- (instancetype)initWithRegistrar:(NSObject <FlutterPluginRegistrar> *)registrar {
    self = [super init];
    if (self) {
        self.registrar = registrar;
        manager = [CoolFlutterIjkManager managerWithRegistrar:registrar];
    }

    return self;
}

+ (instancetype)pluginWithRegistrar:(NSObject <FlutterPluginRegistrar> *)registrar {
    return [[self alloc] initWithRegistrar:registrar];
}


+ (void)registerWithRegistrar:(NSObject <FlutterPluginRegistrar> *)registrar {
    FlutterMethodChannel *channel = [FlutterMethodChannel
            methodChannelWithName:@"top.kikt/ijkplayer"
                  binaryMessenger:[registrar messenger]];
    IjkplayerPlugin *instance = [IjkplayerPlugin pluginWithRegistrar:registrar];
    [registrar addMethodCallDelegate:instance channel:channel];
    __sharedInstance = instance;
}

- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result {
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    dispatch_async(mainQueue, ^{
        if ([@"create" isEqualToString:call.method]) {
            @try {
                int64_t id = [self->manager create];
                result(@(id));
            }
            @catch (NSException *exception) {
                result([FlutterError errorWithCode:@"1" message:@"创建失败" details:exception]);
            }
        } else if ([@"dispose" isEqualToString:call.method]) {
            NSDictionary *params = [call arguments];
            int id = [params[@"id"] intValue];
            [self->manager disposeWithId:id];
            result(@(YES));
        } else if ([@"init" isEqualToString:call.method]) {
            [self->manager disposeAll];
            result(@YES);
        } else if ([@"setSystemVolume" isEqualToString:call.method]) {
            NSDictionary *params = [call arguments];
            int volume = [params[@"volume"] intValue];
            [self setSystemVolume:volume];
            result(@YES);
        } else if ([@"getSystemVolume" isEqualToString:call.method]) {
            AVAudioSession *audioSession = [AVAudioSession sharedInstance];
            CGFloat currentVol = audioSession.outputVolume * 100;
            result(@((int) currentVol));
        } else {
            result(FlutterMethodNotImplemented);
        }
    });
}

- (void)setSystemVolume:(int)volume {
    MPVolumeView *volumeView = [[MPVolumeView alloc] init];
    UISlider *volumeViewSlider = nil;
    for (UIView *view in [volumeView subviews]) {
        if ([view.class.description isEqualToString:@"MPVolumeSlider"]) {
            volumeViewSlider = (UISlider *) view;
            break;
        }
    }

    float targetVolume = ((float) volume) / 100;

    volumeView.frame = CGRectMake(-1000, -1000, 100, 100);

    UIWindow *window = UIApplication.sharedApplication.keyWindow;
    [window addSubview:volumeView];

    // change system volume, the value is between 0.0f and 1.0f
    [volumeViewSlider setValue:targetVolume animated:NO];

    // send UI control event to make the change effect right now. 立即生效
    [volumeViewSlider sendActionsForControlEvents:UIControlEventTouchUpInside];
}

@end

@implementation FlutterMethodCall (Ijk)

- (int64_t)getId {
    return [[self arguments] intValue];
}

- (int64_t)getIdParamFromDict {
    return [[self arguments][@"id"] intValue];
}

- (NSString *)getStringParam:(NSString *)key {
    return [self arguments][key];
}
@end


