//
//  UIViewController+VisableViewController.h
//  zhibo
//
//  Created by iOSzhang Inc on 21/6/2.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (VisableViewController)

+ (__kindof UIViewController *)MY_visibleViewController;

+ (__kindof UINavigationController *)MY_visibleNavigationController;

+ (__kindof UITabBarController *)MY_visibleTabBarController;

@end

NS_ASSUME_NONNULL_END
