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

@end

NS_ASSUME_NONNULL_END
