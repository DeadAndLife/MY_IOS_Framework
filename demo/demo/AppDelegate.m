//
//  AppDelegate.m
//  demo
//
//  Created by iOSzhang Inc on 21/6/3.
//

#import "AppDelegate.h"
#import "PrivacyAlertController.h"
#import "GuideViewController.h"
#import "LoginModular.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [[LoginModular shared] begin];
    
    [[GuideViewController shared] showWithConfirmAction:^{
        NSLog(@"点击了确认");
    }];
    
    [[PrivacyAlertController shared] showWithCancelAction:^{
        NSLog(@"点击了取消");
        exit(0);
    } confirmAction:^{
        NSLog(@"点击了确认");
    }];
    
    return YES;
}

- (void)showMainViewController {
    
}


@end
