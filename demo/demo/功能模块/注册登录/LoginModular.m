//
//  LoginModular.m
//  zhibo
//
//  Created by iOSzhang Inc on 21/6/3.
//

#import "LoginModular.h"
#import "LoginViewController.h"

@implementation LoginModular

+ (instancetype)shared {
    static LoginModular *objc;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        objc = [[LoginModular alloc] init];
    });
    return objc;
}

- (void)begin {
    LoginViewController *vc = [[LoginViewController alloc] init];
    BaseNavigationController *navc = [[BaseNavigationController alloc] initWithRootViewController:vc];
    
    UIViewController *visibleVC = [UIViewController MY_visibleViewController];
    
    [visibleVC presentViewController:navc animated:true completion:^{
    }];
}

@end
