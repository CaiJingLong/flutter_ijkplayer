//
// Created by Caijinglong on 2019-03-08.
//

#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>

@interface FlutterIJK : NSObject

@property(nonatomic, strong) NSObject <FlutterPluginRegistrar> *registrar;

- (instancetype)initWithRegistrar:(NSObject <FlutterPluginRegistrar> *)registrar;

+ (instancetype)ijkWithRegistrar:(NSObject <FlutterPluginRegistrar> *)registrar;

- (int64_t)id;

@end