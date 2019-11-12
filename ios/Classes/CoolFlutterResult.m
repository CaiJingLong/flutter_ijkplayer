//
// Created by Caijinglong on 2019-06-12.
//

#import "CoolFlutterResult.h"

@implementation CoolFlutterResult {

}
- (instancetype)initWithResult:(FlutterResult)result {
    self = [super init];
    if (self) {
        self.result = result;
        self.isReply = NO;
    }

    return self;
}

+ (instancetype)resultWithResult:(FlutterResult)result {
    return [[self alloc] initWithResult:result];
}

- (void)replyResult:(id _Nullable)result {
    if (self.isReply) {
        return;
    }
    self.isReply = YES;
    self.result(result);
}


@end