//
// Created by Caijinglong on 2019-03-15.
//

#import <Foundation/Foundation.h>


@interface CoolVideoInfo : NSObject

@property(nonatomic, assign) NSTimeInterval duration;

@property(nonatomic, assign) NSTimeInterval currentPosition;

@property(nonatomic, assign) CGSize size;

@property(nonatomic, assign) BOOL isPlaying;

@property(nonatomic, assign) int degree;

/**
 * Unit is Byte.
 */
@property(nonatomic, assign) int64_t tcpSpeed;

@property(nonatomic, assign) CGFloat outputFps;

- (NSDictionary *)toMap;

@end
