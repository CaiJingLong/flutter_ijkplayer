//
// Created by Caijinglong on 2019-03-15.
//

#import "CoolVideoInfo.h"


@implementation CoolVideoInfo {

}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.degree = 0;
    }

    return self;
}


- (NSDictionary *)toMap {
    NSMutableDictionary *dict = [NSMutableDictionary new];
    dict[@"width"] = @((int) self.size.width);
    dict[@"height"] = @((int) self.size.height);
    dict[@"duration"] = @(self.duration);
    dict[@"currentPosition"] = @(self.currentPosition);
    dict[@"isPlaying"] = @(self.isPlaying);
    dict[@"degree"] = @(self.degree);
    dict[@"tcpSpeed"] = @(self.tcpSpeed);
    dict[@"outputFps"] = @(self.outputFps);
    return dict;
}

@end