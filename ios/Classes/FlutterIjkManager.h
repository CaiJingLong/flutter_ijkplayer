//
// Created by Caijinglong on 2019-03-08.
//

#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>

@class FlutterIJK;

@interface FlutterIjkManager : NSObject

@property(nonatomic, strong) NSObject <FlutterPluginRegistrar> *registrar;

- (instancetype)initWithRegistrar:(NSObject <FlutterPluginRegistrar> *)registrar;

+ (instancetype)managerWithRegistrar:(NSObject <FlutterPluginRegistrar> *)registrar;

- (int64_t)create;

- (FlutterIJK *)findIJKWithId:(int64_t)id1;

- (void)disposeWithId:(int64_t)id;
@end