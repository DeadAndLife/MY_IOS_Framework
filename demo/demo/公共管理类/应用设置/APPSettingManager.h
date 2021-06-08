//
//  APPSettingManager.h
//  zhibo
//
//  Created by iOSzhang Inc on 21/6/3.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface APPSettingManager : NSObject

+ (instancetype)shared;

- (NSString *)build;

- (NSString *)appVersion;

/// 获取缓存大小
- (NSString *)getCacheSize;

/// 清空缓存
- (void)resetCache;

#ifdef DEBUG
/// 域名列表，仅存在于debug下
- (NSArray *)hostList;

/// 当前使用的域名，仅存在于debug下
- (NSDictionary *)nowHost;

- (void)setNowHost:(NSDictionary *)nowHost;

#endif

@end

NS_ASSUME_NONNULL_END
