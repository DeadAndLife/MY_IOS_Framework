//
//  NSDate+Exchange.h
//  qukanjs
//
//  Created by iOSzhang Inc on 21/1/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (Exchange)

/// 将时间戳转换为时间格式
/// @param timeInterval 时间戳
/// @param dateFormater 时间格式
+ (NSString *)dateForTimeIntervalForBirthday:(NSTimeInterval)timeInterval dateFormter:(NSString *)dateFormater;

@end

NS_ASSUME_NONNULL_END
