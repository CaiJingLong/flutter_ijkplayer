//
//  CoolOrientation.m
//  flutter_ijkplayer
//
//  Created by Caijinglong on 2019/3/29.
//

#import "CoolOrientation.h"

const char* const kOrientationUpdateNotificationName = "io.flutter.plugin.platform.SystemChromeOrientationNotificationName";
const char* const kOrientationUpdateNotificationKey = "io.flutter.plugin.platform.SystemChromeOrientationNotificationKey";

@implementation CoolOrientation

- (void)setSystemChromePreferredOrientations:(NSArray*)orientations {
    UIInterfaceOrientationMask mask = 0;
    
    if (orientations.count == 0) {
        mask |= UIInterfaceOrientationMaskAll;
    } else {
        for (NSString* orientation in orientations) {
            if ([orientation isEqualToString:@"DeviceOrientation.portraitUp"])
                mask |= UIInterfaceOrientationMaskPortrait;
            else if ([orientation isEqualToString:@"DeviceOrientation.portraitDown"])
                mask |= UIInterfaceOrientationMaskPortraitUpsideDown;
            else if ([orientation isEqualToString:@"DeviceOrientation.landscapeLeft"])
                mask |= UIInterfaceOrientationMaskLandscapeLeft;
            else if ([orientation isEqualToString:@"DeviceOrientation.landscapeRight"])
                mask |= UIInterfaceOrientationMaskLandscapeRight;
        }
    }
    
    if (!mask)
        return;
    [[NSNotificationCenter defaultCenter] postNotificationName:@(kOrientationUpdateNotificationName)
                                                        object:nil
                                                      userInfo:@{@(kOrientationUpdateNotificationKey)
                                                              :@(mask)}];
}

@end
