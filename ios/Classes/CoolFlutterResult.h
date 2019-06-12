//
// Created by Caijinglong on 2019-06-12.
//


#import <Flutter/Flutter.h>

@interface CoolFlutterResult : NSObject

@property(nonatomic, strong) FlutterResult result;

@property(nonatomic, assign) BOOL isReply;

- (instancetype)initWithResult:(FlutterResult)result;

+ (instancetype)resultWithResult:(FlutterResult)result;

- (void)replyResult:(id _Nullable)result;

@end