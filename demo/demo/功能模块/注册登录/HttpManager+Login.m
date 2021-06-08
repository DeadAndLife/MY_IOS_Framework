//
//  HttpManager+Login.m
//  zhibo
//
//  Created by iOSzhang Inc on 21/6/3.
//

#import "HttpManager+Login.h"

@implementation HttpManager (Login)

/// 发送验证码
/// @param phone 手机号
/// @param event 事件
/// @param block 回调
- (void)sendCodeWithPhone:(NSString *)phone event:(NSString *)event block:(NetworkBlock)block {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:phone forKey:@"mobile"];
    [parameters setValue:event forKey:@"event"];
    
    [self GET:hostAutoChange(@"", @"") parameters:parameters networkBlock:block];
}

/// 密码登录
/// @param phone 手机号
/// @param password 密码
/// @param block 回调
- (void)loginWithPhone:(NSString *)phone password:(NSString *)password block:(NetworkBlock)block {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:phone forKey:@"account"];
    [parameters setValue:password forKey:@"password"];
    
    [self GET:hostAutoChange(@"", @"") parameters:parameters networkBlock:block];
}

/// 验证码登录
/// @param phone 手机号
/// @param code 验证码
/// @param block 回调
- (void)loginWithPhone:(NSString *)phone code:(NSString *)code block:(NetworkBlock)block {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:phone forKey:@"mobile"];
    [parameters setValue:code forKey:@"captcha"];
    
    [self GET:hostAutoChange(@"", @"") parameters:parameters networkBlock:block];
}

/// 重置密码
/// @param phone 手机号
/// @param code 验证码
/// @param password 密码
/// @param passwordAgain 密码2
/// @param block 回调
- (void)resetPasswordWithPhone:(NSString *)phone code:(NSString *)code password:(NSString *)password passwordAgain:(NSString *)passwordAgain block:(NetworkBlock)block {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:phone forKey:@"mobile"];
    [parameters setValue:code forKey:@"captcha"];
    [parameters setValue:password forKey:@"newpassword"];
    
    [self GET:hostAutoChange(@"", @"") parameters:parameters networkBlock:block];
}

@end
