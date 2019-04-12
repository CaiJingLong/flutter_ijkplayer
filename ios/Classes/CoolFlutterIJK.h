//
// Created by Caijinglong on 2019-03-08.
//

#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>
#import "CoolIjkNotifyChannel.h"
#import "CoolIjkOption.h"

@interface CoolFlutterIJK : NSObject

@property(nonatomic, strong) NSObject <FlutterPluginRegistrar> *registrar;

@property(nonatomic, strong) NSArray<CoolIjkOption*> *options;

- (instancetype)initWithRegistrar:(NSObject <FlutterPluginRegistrar> *)registrar;

+ (instancetype)ijkWithRegistrar:(NSObject <FlutterPluginRegistrar> *)registrar;

- (int64_t)id;

- (void)dispose;

- (void)setDegree:(int)degree;

@end
