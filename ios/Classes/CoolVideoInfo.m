//
// Created by Caijinglong on 2019-03-15.
//

#import "CoolVideoInfo.h"


@implementation CoolVideoInfo {

}

- (NSDictionary *)toMap {
    NSMutableDictionary *dict = [NSMutableDictionary new];
    dict[@"width"] = @((int) self.size.width);
    dict[@"height"] = @((int) self.size.height);
    dict[@"duration"] = @(self.duration);
    dict[@"currentPosition"] = @(self.currentPosition);
    dict[@"isPlaying"] = @(self.isPlaying);
    return dict;
}

@end