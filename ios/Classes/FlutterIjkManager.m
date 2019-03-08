//
// Created by Caijinglong on 2019-03-08.
//

#import "FlutterIjkManager.h"
#import "FlutterIJK.h"
#import <IJKMediaFramework/IJKMediaFramework.h>

@implementation FlutterIjkManager {
    NSMutableDictionary<NSNumber *, FlutterIJK * > *dict;
}


- (instancetype)initWithRegistrar:(NSObject <FlutterPluginRegistrar> *)registrar {
    self = [super init];
    if (self) {
        self.registrar = registrar;
        dict = [NSMutableDictionary new];
    }

    return self;
}

+ (instancetype)managerWithRegistrar:(NSObject <FlutterPluginRegistrar> *)registrar {
    return [[self alloc] initWithRegistrar:registrar];
}

- (int64_t)create {
    FlutterIJK *ijk = [FlutterIJK ijkWithRegistrar:self.registrar];
    NSNumber *number = @([ijk id]);
    dict[number] = ijk;
    return [ijk id];
}

- (FlutterIJK *)findIJKWithId:(int64_t)id {
    return dict[@(id)];
}

- (void)disposeWithId:(int64_t)id {
    FlutterIJK *ijk = dict[@(id)];
    if (ijk) {
        [ijk dispose];
        [dict removeObjectForKey:@(id)];
    }
}

@end