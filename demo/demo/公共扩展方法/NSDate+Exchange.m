//
//  NSDate+Exchange.m
//  qukanjs
//
//  Created by iOSzhang Inc on 21/1/18.
//

#import "NSDate+Exchange.h"

@implementation NSDate (Exchange)

/// 将时间戳转换为时间格式
/// @param timeInterval 时间戳
/// @param dateFormater 时间格式
+ (NSString *)dateForTimeIntervalForBirthday:(NSTimeInterval)timeInterval dateFormter:(NSString *)dateFormater {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:dateFormater];
    
    return [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:timeInterval]];
}

@end
