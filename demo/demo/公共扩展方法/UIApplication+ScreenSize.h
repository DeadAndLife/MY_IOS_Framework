//
//  UIApplication+ScreenSize.h
//  qukanjs
//
//  Created by iOSzhang Inc on 21/1/14.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIApplication (ScreenSize)

/// 是否全面屏
+ (BOOL)isFullScreen;

/// 状态栏高度
+ (CGFloat)statusBarHeight;

/// 导航高度(+状态栏,非实际值,内参标定)
+ (CGFloat)naviHeight;

/// tabbar高度(+底部高度,非实际值,内参标定)
+ (CGFloat)tabbarHeight;

/// safearea的底部高度
+ (CGFloat)bottomHeight;

@end

NS_ASSUME_NONNULL_END
