//
// Created by Caijinglong on 2019-03-08.
//

#import "CoolFlutterIjkManager.h"
#import "CoolFlutterIJK.h"
#import <IJKMediaFramework/IJKMediaFramework.h>

@implementation CoolFlutterIjkManager {
    NSMutableDictionary<NSNumber *, CoolFlutterIJK *> *dict;
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
    CoolFlutterIJK *ijk = [CoolFlutterIJK ijkWithRegistrar:self.registrar];
    NSNumber *number = @([ijk id]);
    dict[number] = ijk;
    return [ijk id];
}

- (CoolFlutterIJK *)findIJKWithId:(int64_t)id {
    return dict[@(id)];
}

- (int)ijkCount{
    if(!dict){
        return 0;
    }
    return [dict count];
}

- (void)disposeWithId:(int64_t)id {
    CoolFlutterIJK *ijk = dict[@(id)];
    if (ijk) {
        [ijk dispose];
        [dict removeObjectForKey:@(id)];
    }
}

- (void)disposeAll {
    NSArray<NSNumber *> *keys = dict.allKeys;
    for (NSNumber *key in keys) {
        CoolFlutterIJK *ijk = dict[key];
        [dict removeObjectForKey:key];
        [ijk dispose];
    }
}
@end
