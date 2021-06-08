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

/// 获取缓存大小
- (NSString *)getCacheSize {
    //sd缓存
    NSUInteger sdImageSize = [SDImageCache sharedImageCache].totalDiskSize;
    //tmp文件夹内容
//    NSUInteger folderSize = [self folderSizeAtPath:NSTemporaryDirectory()];
    //cache文件夹缓存(sd也在该文件夹下) Caches/com.hackemist.SDImageCache/default
    NSInteger allCacheSize = sdImageSize;
    
    return [NSString fileSizeWithInterge:allCacheSize];
}

/// 清空缓存
- (void)resetCache {
    //清除sd缓存
    [[[SDWebImageManager sharedManager] imageCache] clearWithCacheType:SDImageCacheTypeDisk completion:nil];
    //清楚tmp文件
//    [self clearTmpDirectory];
}

#ifdef DEBUG
static NSString *hostKey = @"nowHost";

/// 域名列表，仅存在于debug下
- (NSArray *)hostList {
    return @[
        @{@"desc":@"正式服",@"host":@""},
        @{@"desc":@"测试服",@"host":@""},
//        @{@"desc":@"",@"host":@""},
//        @{@"desc":@"",@"host":@""},
    ];
}

/// 当前使用的域名，仅存在于debug下
- (NSDictionary *)nowHost {
    NSDictionary *nowHost = [[NSUserDefaults standardUserDefaults] dictionaryForKey:hostKey];
    if (!nowHost) {
        [self setNowHost:[self hostList].firstObject];
        nowHost = [self hostList].firstObject;
    }
    return nowHost;
}

- (void)setNowHost:(NSDictionary *)nowHost {
    [[NSUserDefaults standardUserDefaults] setObject:nowHost forKey:hostKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#endif

@end
