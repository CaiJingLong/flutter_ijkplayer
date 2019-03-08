//
// Created by Caijinglong on 2019-03-08.
//

#import "FlutterIjkManager.h"
#import "FlutterIJK.h"
#import <IJKMediaFramework/IJKMediaFramework.h>

@implementation FlutterIjkManager {
    NSObject <FlutterTextureRegistry> *textures;
}


- (instancetype)initWithRegistrar:(NSObject <FlutterPluginRegistrar> *)registrar {
    self = [super init];
    if (self) {
        self.registrar = registrar;
        textures = [registrar textures];
    }

    return self;
}

+ (instancetype)managerWithRegistrar:(NSObject <FlutterPluginRegistrar> *)registrar {
    return [[self alloc] initWithRegistrar:registrar];
}

- (int64_t)create {
    FlutterIJK *ijk = [FlutterIJK ijkWithRegistrar:self.registrar];
    return [ijk id];
}


@end