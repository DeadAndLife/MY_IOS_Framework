//
//  UIViewController+VisableViewController.m
//  zhibo
//
//  Created by iOSzhang Inc on 21/6/2.
//

#import "UIViewController+VisableViewController.h"

@implementation UIViewController (VisableViewController)

+ (__kindof UIViewController *)MY_visibleViewController {
    UIViewController *rootViewController = [[UIApplication sharedApplication] keyWindow].rootViewController;
    return [UIViewController visibleViewControllerForController:rootViewController];
}

+ (__kindof UIViewController *)visibleViewControllerForController:(__kindof UIViewController *)viewController {
    if ([viewController isKindOfClass:[UITabBarController class]]) {
        return  [UIViewController visibleViewControllerForController:[(UITabBarController *)viewController selectedViewController]];
    } else if ([viewController isKindOfClass:[UINavigationController class]]) {
        return [UIViewController visibleViewControllerForController:[(UINavigationController *)viewController visibleViewController]];
    } else if ([viewController isKindOfClass:[UIViewController class]]) {
        return viewController;
    } else {
        return nil;
    }
}

+ (__kindof UINavigationController *)MY_visibleNavigationController {
    UIViewController *rootViewController = [[UIApplication sharedApplication] keyWindow].rootViewController;
    return [UIViewController visibleNavigationControllerForController:rootViewController];
}

+ (__kindof UINavigationController *)visibleNavigationControllerForController:(__kindof UIViewController *)viewController {
    if ([viewController isKindOfClass:[UITabBarController class]]) {
        return  [UIViewController visibleViewControllerForController:[(UITabBarController *)viewController selectedViewController]];
    } else if ([viewController isKindOfClass:[UINavigationController class]]) {
        return viewController;
    } else {
        return nil;
    }
}

+ (__kindof UITabBarController *)MY_visibleTabBarController {
    UIViewController *rootViewController = [[UIApplication sharedApplication] keyWindow].rootViewController;
    return [UIViewController visibleTabBarControllerForController:rootViewController];
}

+ (__kindof UITabBarController *)visibleTabBarControllerForController:(__kindof UIViewController *)viewController {
    if ([viewController isKindOfClass:[UITabBarController class]]) {
        return  viewController;
    } else if ([viewController isKindOfClass:[UINavigationController class]]) {
        return [UIViewController visibleViewControllerForController:[(UINavigationController *)viewController visibleViewController]];;
    } else {
        return nil;
    }
}

@end
