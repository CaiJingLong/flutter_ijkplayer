#import "IjkplayerPlugin.h"
#import "FlutterIjkManager.h"
#import "FlutterIJK.h"

@interface FlutterMethodCall (Ijk)
- (int64_t)getId;

- (int64_t)getIdParamFromDict;

- (NSString *)getStringParam:(NSString *)key;
@end

@implementation IjkplayerPlugin {
    FlutterIjkManager *manager;

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
            int64_t id = [call getId];
            [self->manager disposeWithId:id];
        } else if ([@"play" isEqualToString:call.method]) {
            FlutterIJK *ijk = [self->manager findIJKWithId:call.getId];
            if (ijk) {
                [ijk play];
                result(@(1));
            }
        } else if ([@"pause" isEqualToString:call.method]) {
            FlutterIJK *ijk = [self->manager findIJKWithId:[call getId]];
            if (ijk) {
                [ijk pause];
            }
        } else if ([@"stop" isEqualToString:call.method]) {
            FlutterIJK *ijk = [self->manager findIJKWithId:[call getId]];
            if (ijk) {
                [ijk stop];
            }
        } else if ([@"setDataSource" isEqualToString:call.method]) {
            FlutterIJK *ijk = [self->manager findIJKWithId:[call getIdParamFromDict]];
            if (ijk) {
                NSString *uri = [call getStringParam:@"uri"];
                [ijk setDateSourceWithUri:uri];
                result(nil);
            } else {
                result([FlutterError errorWithCode:@"1" message:@"设置失败" details:nil]);
            }
        } else {
            result(FlutterMethodNotImplemented);
        }
    });
}

- (void)runOnUI:(DISPATCH_NOESCAPE dispatch_block_t)block {
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    dispatch_sync(mainQueue, block);
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
