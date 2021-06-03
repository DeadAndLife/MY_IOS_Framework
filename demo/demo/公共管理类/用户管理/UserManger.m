//
//  UserManger.m
//  qukanjs
//
//  Created by iOSzhang Inc on 21/1/14.
//

#import "UserManger.h"
#import "HttpManager.h"
#import "AppDelegate.h"

#define AppUserTokenKey  @"AppUserTokenKey"

@implementation UserManger

+ (instancetype)share {
    static UserManger *obj = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        obj = [[UserManger alloc] init];
    });
    return obj;
}

- (NSString *)getUserToken {
    return [[NSUserDefaults standardUserDefaults] valueForKey:AppUserTokenKey];
}

- (void)setUserToken:(NSString *)userToken {
    [[NSUserDefaults standardUserDefaults] setValue:userToken forKey:AppUserTokenKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[HttpManager share] resetUserToken];
}

- (void)logout {
    //清除token
    [self setUserToken:nil];
    MineInfoModel *userModel = [MineInfoModel share];
    [userModel reset];
    userModel = nil;
    [[LoginModular shared] begin];
}

/// 是否登陆，如果未登录将自动转换到登陆界面，否则返回true
- (BOOL)isLogin {
    return [[self getUserToken] isNotEmpty];
}

- (BOOL)isLoginAndChangeLoginVC {
    if (![self isLogin]) {
        [[LoginModular shared] begin];
    }
    return [self isLogin];
}

@end
