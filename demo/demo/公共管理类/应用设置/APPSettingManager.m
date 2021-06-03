//
//  APPSettingManager.m
//  zhibo
//
//  Created by iOSzhang Inc on 21/6/3.
//

#import "APPSettingManager.h"


@implementation APPSettingManager

+ (instancetype)shared {
    static APPSettingManager *objc;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        objc = [[APPSettingManager alloc] init];
    });
    return objc;
}

- (NSString *)build {
    //获取 Build  构建版本号
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
}

- (NSString *)appVersion {
    //获取 Version  版本号
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

@end
