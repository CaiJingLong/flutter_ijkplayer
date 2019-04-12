//
// Created by Caijinglong on 2019-03-08.
//

#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>

@class CoolFlutterIJK;

@interface CoolFlutterIjkManager : NSObject

@property(nonatomic, strong) NSObject <FlutterPluginRegistrar> *registrar;

- (instancetype)initWithRegistrar:(NSObject <FlutterPluginRegistrar> *)registrar;

+ (instancetype)managerWithRegistrar:(NSObject <FlutterPluginRegistrar> *)registrar;

- (int64_t)createWithCall:(FlutterMethodCall*) call;

- (CoolFlutterIJK *)findIJKWithId:(int64_t)id1;

- (int) ijkCount;

- (void)disposeWithId:(int64_t)id;

- (void)disposeAll;
@end
