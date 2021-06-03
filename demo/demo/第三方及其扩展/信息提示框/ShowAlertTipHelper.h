//
//  ShowAlertTipHelper.h
//  CarProduct
//
//  Created by sven on 2017/9/5.
//  Copyright © 2017年 sven. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MBProgressHUD;

@interface ShowAlertTipHelper : NSObject

/// 只展示，不限定展示时间，手动调用MBProgressHUD的消失方法
/// @param view 展示的view
/// @param tipText 展示文本
+ (MBProgressHUD *)showInView:(UIView *)view text:(NSString *)tipText;

+ (void)showInView:(UIView *)view text:(NSString *)tipText time:(CGFloat)showTime completeBlock:(void (^)(void))complete;

/// 只展示，不限定展示时间，手动调用MBProgressHUD的消失方法
/// @param view 展示的view
/// @param tipText 展示文本
+ (MBProgressHUD *)showInBottomView:(UIView *)view text:(NSString *)tipText;

+ (void)showInBottomView:(UIView *)view text:(NSString *)tipText time:(CGFloat)showTime completeBlock:(void (^)(void))complete;

@end
