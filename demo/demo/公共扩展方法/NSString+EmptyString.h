//
//  NSString+EmptyString.h
//  qukanjs
//
//  Created by iOSzhang Inc on 21/1/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (EmptyString)

- (BOOL)isNotEmpty;

- (BOOL)isPhoneNumber;

/// id类型转json串
/// @param jsonType json数据
+ (NSString *)jsonToJSONString:(id)jsonType;

/// 计算文件大小字符串，自动返回k，m单位
/// @param size 原始大小
+ (NSString *)fileSizeWithInterge:(NSInteger)size;

@end

NS_ASSUME_NONNULL_END
