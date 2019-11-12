//
// Created by Caijinglong on 2019-03-15.
//

#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>
#import <IJKMediaFramework/IJKMediaFramework.h>

@class CoolVideoInfo;

@protocol KKIjkNotifyDelegate
- (CoolVideoInfo *)getInfo;

- (void)setDegree:(int)newDegree;

- (void)onLoadStateChange;
@end

@interface CoolIjkNotifyChannel : NSObject

@property(nonatomic, strong) IJKFFMoviePlayerController *controller;

@property(nonatomic, assign) int64_t textureId;

@property(nonatomic, strong) NSObject <FlutterPluginRegistrar> *registrar;

@property(nonatomic, weak) NSObject <KKIjkNotifyDelegate> *infoDelegate;

- (instancetype)initWithController:(IJKFFMoviePlayerController *)controller textureId:(int64_t)textureId
                         registrar:(NSObject <FlutterPluginRegistrar> *)registrar;

+ (instancetype)channelWithController:(IJKFFMoviePlayerController *)controller textureId:(int64_t)textureId
                            registrar:(NSObject <FlutterPluginRegistrar> *)registrar;


- (void)dispose;

@end