//
//  UserManger.h
//  qukanjs
//
//  Created by iOSzhang Inc on 21/1/14.
//

#import <Foundation/Foundation.h>
#import "MineInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface UserManger : NSObject

+ (instancetype)share;

- (NSString *)getUserToken;

- (void)logout;

/// 是否登陆，如果未登录将自动转换到登陆界面，否则返回true
- (BOOL)isLogin;

- (BOOL)isLoginAndChangeLoginVC;

@end

NS_ASSUME_NONNULL_END
