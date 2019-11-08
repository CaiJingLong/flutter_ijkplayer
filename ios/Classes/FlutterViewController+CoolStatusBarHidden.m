//
//  FlutterViewController+CoolViewController.m
//  flutter_ijkplayer
//
//  Created by Caijinglong on 2019/11/8.
//

#import "FlutterViewController+CoolStatusBarHidden.h"
#import <objc/runtime.h>

@implementation FlutterViewController (CoolViewController)

-(void)showStatusBar{
    objc_setAssociatedObject(self, @selector(showStatusBar), @"show", OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [UIView animateWithDuration:1 animations:^{
          [self setNeedsStatusBarAppearanceUpdate];
    }];
}

-(void)hideStatusBar{
    objc_setAssociatedObject(self, @selector(showStatusBar), @"hide", OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [UIView animateWithDuration:1 animations:^{
          [self setNeedsStatusBarAppearanceUpdate];
    }];
}

-(BOOL)isStatusBarShow{
    NSString *value = objc_getAssociatedObject(self, @selector(showStatusBar));
    return ![value isEqualToString:@"hide"];
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation{
    return UIStatusBarAnimationFade;
}

-(BOOL)prefersStatusBarHidden{
    return ![self isStatusBarShow];
}

-(void)viewDidDisappear:(BOOL)animated{
    objc_removeAssociatedObjects(self);
}

@end
