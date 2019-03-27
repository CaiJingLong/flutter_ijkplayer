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
    MPVolumeView *volumeView;
    UISlider *volumeViewSlider;
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
            int currentVol = [self getSystemVolume];
            result(@(currentVol));
        } else if ([@"volumeUp" isEqualToString:call.method]) {
            int currentVol = [self getSystemVolume];
            [self setSystemVolume: currentVol + 3];
            currentVol = [self getSystemVolume];
            result(@(currentVol));
        } else if ([@"volumeDown" isEqualToString:call.method]) {
            int currentVol = [self getSystemVolume];
            [self setSystemVolume: currentVol - 3];
            currentVol = [self getSystemVolume];
            result(@(currentVol));
        } else if ([@"hideSystemVolumeBar" isEqualToString:call.method]) {
            [self hideSystemVolumeBar];
            result(@YES);
        } else {
            result(FlutterMethodNotImplemented);
        }
    });
}

- (int) getSystemVolume{
//    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
//    CGFloat currentVol = audioSession.outputVolume * 100;
//    NSLog(@"system volume = %.0f",currentVol);
//    return (int)currentVol;
    return (int)([self getVolumeWithVolumeView] * 100);
}

- (float) getVolumeWithVolumeView{
    [self initVolumeView];
    if(!volumeViewSlider){
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        CGFloat currentVol = audioSession.outputVolume * 100;
        NSLog(@"system volume = %.0f",currentVol);
        return (int)currentVol;
    }
    return volumeViewSlider.value;
}

-(void)initVolumeView{
    if(!volumeView){
        volumeView = [[MPVolumeView alloc] initWithFrame:CGRectMake(-100, 0, 10, 10)];
    }
    if(!volumeViewSlider){
        for (UIView *view in [volumeView subviews]) {
            if ([view.class.description isEqualToString:@"MPVolumeSlider"]) {
                volumeViewSlider = (UISlider *) view;
                break;
            }
        }
    }
}

- (void)setSystemVolume:(int)volume {
    [self initVolumeView];

    float targetVolume = ((float) volume) / 100;

    if(volumeView && !volumeView.superview){
        UIWindow *window = UIApplication.sharedApplication.keyWindow;
        [window addSubview:volumeView];
    }

    if (targetVolume > 1){
        targetVolume = 1;
    } else if(targetVolume < 0){
        targetVolume = 0;
    }
    
    // change system volume, the value is between 0.0f and 1.0f
    [volumeViewSlider setValue:targetVolume animated:NO];

    // send UI control event to make the change effect right now. 立即生效
    [volumeViewSlider sendActionsForControlEvents:UIControlEventTouchUpInside];
    
//    [volumeView removeFromSuperview];
}

-(void) hideSystemVolumeBar {
    if(volumeView && volumeView.superview) {
        [volumeView removeFromSuperview];
        volumeView = nil;
    }
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


