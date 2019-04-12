#import <AVKit/AVKit.h>
#import "IjkplayerPlugin.h"
#import "CoolFlutterIjkManager.h"
#import "CoolFlutterIJK.h"

NSString *flutterOrientationNotifyName = @"io.flutter.plugin.platform.SystemChromeOrientationNotificationName";
const NSString *flutterOrientationNotifyKey = @"io.flutter.plugin.platform.SystemChromeOrientationNotificationKey";

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
//    __weak typeof(&*self) weakSelf = self;
    dispatch_async(mainQueue, ^{
        if ([@"create" isEqualToString:call.method]) {
            @try {
                int64_t id = [self->manager createWithCall:call];
                result(@(id));
            }
            @catch (NSException *exception) {
                result([FlutterError errorWithCode:@"1" message:@"创建失败" details:exception]);
            }
            [self checkVolumeViewShouldShow];
        } else if ([@"dispose" isEqualToString:call.method]) {
            NSDictionary *params = [call arguments];
            int id = [params[@"id"] intValue];
            [self->manager disposeWithId:id];
            [self checkVolumeViewShouldShow];
            result(@(YES));
        } else if ([@"init" isEqualToString:call.method]) {
            [self->manager disposeAll];
            [self checkVolumeViewShouldShow];
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
        } else if ([@"setSystemBrightness" isEqualToString:call.method]) {
            NSDictionary *params = [call arguments];
            CGFloat target = [params[@"brightness"] floatValue];
            [[UIScreen mainScreen] setBrightness:target];
            result(@YES);
        } else if ([@"getSystemBrightness" isEqualToString:call.method]) {
            CGFloat brightness = [UIScreen mainScreen].brightness;
            result(@(brightness));
        } else if ([@"resetBrightness" isEqualToString:call.method]) {
//            CGFloat brightness = [UIScreen mainScreen].brightness;
            result(@YES);
        } else if ([@"setSupportOrientation" isEqualToString:call.method]) {
            [self setSupportOrientationWithCall:call];
            result(@YES);
        } else if([@"setCurrentOrientation" isEqualToString:call.method]){
            [self setCurrentOrientationWithCall:call];
            result(@YES);
        } else if([@"unlockOrientation" isEqualToString:call.method]){
            [self unlockOrientation];
            result(@YES);
        } else {
            result(FlutterMethodNotImplemented);
        }
    });
}

- (UIDeviceOrientation) convertIntToOrientation:(int)orientation{
    switch (orientation) {
        case 0:
            return UIDeviceOrientationPortrait;
        case 1:
            return UIDeviceOrientationLandscapeLeft;
        case 2:
            return UIDeviceOrientationPortraitUpsideDown;
        case 3:
            return UIDeviceOrientationLandscapeRight;
        default:
            return UIDeviceOrientationUnknown;
    }
}

- (void) setOrientationWithCall:(FlutterMethodCall *)call{
    NSDictionary *dict = [call arguments];
    NSArray *orientations = dict[@"orientation"];
    UIInterfaceOrientationMask mask = 0;
    if (orientations.count == 0) {
        mask |= UIInterfaceOrientationMaskAll;
    }
    for (id number in orientations) {
        int value = [number intValue];
        UIDeviceOrientation orientation = [self convertIntToOrientation:value];
        NSLog(@"orientation = %ld",orientation);
        if (orientation == UIDeviceOrientationPortrait){
            mask |= UIInterfaceOrientationMaskPortrait;
        }else if (orientation == UIDeviceOrientationLandscapeLeft) {
            mask |= UIInterfaceOrientationMaskLandscapeLeft;
        }else if (orientation == UIDeviceOrientationPortraitUpsideDown) {
            mask |= UIInterfaceOrientationMaskPortraitUpsideDown;
        }else if (orientation == UIDeviceOrientationLandscapeRight) {
            mask |= UIInterfaceOrientationMaskLandscapeRight;
        }
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:flutterOrientationNotifyName
                                                        object:nil
                                                      userInfo:@{flutterOrientationNotifyKey
                                                                 :@(mask)}];
    
    if(orientations.count != 0 && [[UIDevice currentDevice]respondsToSelector:@selector(setOrientation:)]){
        SEL selector = NSSelectorFromString(@"setOrientation:");
        int value = [orientations[0] intValue];
        UIDeviceOrientation orientation = [self convertIntToOrientation:value];
        int val = orientation;
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}

- (void) setCurrentOrientationWithCall:(FlutterMethodCall *)call {
    if([[UIDevice currentDevice]respondsToSelector:@selector(setOrientation:)]){
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSDictionary *dict = [call arguments];
        int target = [dict[@"target"] intValue];
        UIDeviceOrientation orientation = [self convertIntToOrientation:target];
        int val = orientation;
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
        
        NSLog(@"target orientation = %d", val);
    }
}

- (void) setSupportOrientationWithCall:(FlutterMethodCall *)call {
    NSDictionary *dict = [call arguments];
    NSArray *orientations = dict[@"supportOrientation"];
    UIInterfaceOrientationMask mask = 0;
    if (orientations.count == 0) {
        mask |= UIInterfaceOrientationMaskAll;
    }
    for (id number in orientations) {
        int value = [number intValue];
        UIDeviceOrientation orientation = [self convertIntToOrientation:value];
        NSLog(@"orientation = %ld",orientation);
        if (orientation == UIDeviceOrientationPortrait){
            mask |= UIInterfaceOrientationMaskPortrait;
        }else if (orientation == UIDeviceOrientationLandscapeLeft) {
            mask |= UIInterfaceOrientationMaskLandscapeLeft;
        }else if (orientation == UIDeviceOrientationPortraitUpsideDown) {
            mask |= UIInterfaceOrientationMaskPortraitUpsideDown;
        }else if (orientation == UIDeviceOrientationLandscapeRight) {
            mask |= UIInterfaceOrientationMaskLandscapeRight;
        }
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:flutterOrientationNotifyName
                                                        object:nil
                                                      userInfo:@{flutterOrientationNotifyKey
                                                                 :@(mask)}];
}

- (void) unlockOrientation {
    UIDevice *device = [UIDevice currentDevice];
    if([device respondsToSelector:@selector(setOrientation:)]){
        SEL selector = NSSelectorFromString(@"setOrientation:");
        int val = device.orientation;
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:flutterOrientationNotifyName
                                                        object:nil
                                                      userInfo:@{flutterOrientationNotifyKey
                                                                 :@(UIInterfaceOrientationMaskAll)}];
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
    
    UIWindow *window = UIApplication.sharedApplication.keyWindow;
    [window addSubview:volumeView];
}

- (void) checkVolumeViewShouldShow{
    int count = [manager ijkCount];
    if (count>0){
        [self initVolumeView];
    }else{
        [volumeView removeFromSuperview];
        volumeView = nil;
    }
}

- (void)setSystemVolume:(int)volume {
    [self initVolumeView];

    float targetVolume = ((float) volume) / 100;

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


