//
// Created by Caijinglong on 2019-03-15.
//

#import <Foundation/Foundation.h>


@interface KKVideoInfo : NSObject

@property(nonatomic, assign) NSTimeInterval duration;

@property(nonatomic, assign) NSTimeInterval currentPosition;

@property(nonatomic, assign) CGSize size;

- (NSDictionary *)toMap;

@end