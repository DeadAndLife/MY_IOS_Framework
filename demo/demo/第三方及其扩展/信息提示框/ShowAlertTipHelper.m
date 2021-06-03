//
//  ShowAlertTipHelper.m
//  CarProduct
//
//  Created by sven on 2017/9/5.
//  Copyright © 2017年 sven. All rights reserved.
//

#import <MBProgressHUD/MBProgressHUD.h>

@implementation ShowAlertTipHelper

/// 只展示，不限定展示时间，手动调用MBProgressHUD的消失方法
/// @param view 展示的view
/// @param tipText 展示文本
+ (MBProgressHUD *)showInView:(UIView *)view text:(NSString *)tipText {
    if (tipText.length == 0) {
        return nil;
    }
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:view];
    hud.userInteractionEnabled = NO;
    hud.margin = 10.f;
    hud.mode = MBProgressHUDModeText;
    hud.detailsLabel.font = [UIFont systemFontOfSize:14];
    //矫正加到window和加到view的位置偏移
    if ([view isKindOfClass:[UIWindow class]]) {
        hud.offset = CGPointMake(hud.offset.x, 34);
    }
    hud.detailsLabel.text = tipText;
    hud.removeFromSuperViewOnHide = YES;
    [view addSubview:hud];
    [hud showAnimated:true];
    return hud;
}

+ (void)showInView:(UIView *)view text:(NSString *)tipText time:(CGFloat)showTime completeBlock:(void (^)(void))complete{
    MBProgressHUD *hud = [self showInView:view text:tipText];
    if (!hud) {
        return;
    }
    [hud hideAnimated:true afterDelay:showTime];
    hud.completionBlock = ^{
        if (complete) {
            complete();
        }
    };
}

/// 只展示，不限定展示时间，手动调用MBProgressHUD的消失方法
/// @param view 展示的view
/// @param tipText 展示文本
+ (MBProgressHUD *)showInBottomView:(UIView *)view text:(NSString *)tipText {
    if (tipText.length == 0) {
        return nil;
    }
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:view];
    hud.userInteractionEnabled = NO;
    hud.offset = CGPointMake(hud.offset.x, SCREEN_H/6);
    hud.margin = 10.f;
    hud.mode = MBProgressHUDModeText;
    hud.detailsLabel.font = [UIFont systemFontOfSize:14];
    //矫正加到window和加到view的位置偏移
    if ([view isKindOfClass:[UIWindow class]]) {
        hud.offset = CGPointMake(hud.offset.x, SCREEN_H/6+34);
//        hud.yOffset = SCREEN_HEIGHT/6+34;
    }
    hud.detailsLabel.text = tipText;
    hud.removeFromSuperViewOnHide = YES;
    [view addSubview:hud];
    [hud showAnimated:true];
    return hud;
}

+ (void)showInBottomView:(UIView *)view text:(NSString *)tipText time:(CGFloat)showTime completeBlock:(void (^)(void))complete{
    MBProgressHUD *hud = [self showInBottomView:view text:tipText];
    if (!hud) {
        return;
    }
    [hud hideAnimated:true afterDelay:showTime];
    hud.completionBlock = ^{
        if (complete) {
            complete();
        }
    };
}


@end
