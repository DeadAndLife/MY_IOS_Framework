//
//  UIApplication+ScreenSize.m
//  qukanjs
//
//  Created by iOSzhang Inc on 21/1/14.
//

#import "UIApplication+ScreenSize.h"
//#import <UIKit/UIKit.h>

@implementation UIApplication (ScreenSize)

+ (BOOL)isFullScreen {
    return self.statusBarHeight > 40;
}

+ (CGFloat)statusBarHeight {
    return CGRectGetHeight([self sharedApplication].statusBarFrame);
}

+ (CGFloat)naviHeight {
    return [self isFullScreen]? 88:64;
}

+ (CGFloat)tabbarHeight {
    return [self isFullScreen]? 83:49;
}

+ (CGFloat)bottomHeight {
    return [self isFullScreen]? 34:0;
}

@end
