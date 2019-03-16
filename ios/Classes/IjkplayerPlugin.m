#import "IjkplayerPlugin.h"
#import "FlutterIjkManager.h"
#import "FlutterIJK.h"

@interface FlutterMethodCall (Ijk)
- (int64_t)getId;

- (int64_t)getIdParamFromDict;

- (NSString *)getStringParam:(NSString *)key;
@end

static IjkplayerPlugin *__sharedInstance;

@implementation IjkplayerPlugin {
    FlutterIjkManager *manager;

}

+ (instancetype)sharedInstance {
    return __sharedInstance;
}


- (instancetype)initWithRegistrar:(NSObject <FlutterPluginRegistrar> *)registrar {
    self = [super init];
    if (self) {
        self.registrar = registrar;
        manager = [FlutterIjkManager managerWithRegistrar:registrar];
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
        } else {
            result(FlutterMethodNotImplemented);
        }
    });
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
