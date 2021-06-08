//
//  NSString+EmptyString.m
//  qukanjs
//
//  Created by iOSzhang Inc on 21/1/14.
//

#import "NSString+EmptyString.h"

@implementation NSString (EmptyString)

- (BOOL)isNotEmpty {
    if ([self isEqual:[NSNull null]]) {
        return false;
    }
    if (self.length == 0) {
        return false;
    }
    if ([self isEqualToString:@"null"]) {
        return false;
    }
    return true;
}

- (BOOL)isPhoneNumber {
    if (self.length != 11) {
        return false;
    }else{
        NSString *pattern = @"^1[35789]\\d{9}$";
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
        BOOL isMatch = [predicate evaluateWithObject:self];
        return isMatch;
    }
}

/// id类型转json串
/// @param jsonType json数据
+ (NSString *)jsonToJSONString:(id)jsonType {
    NSError *error = nil;
    NSData *JSONData = [NSJSONSerialization dataWithJSONObject:jsonType options:NSJSONWritingPrettyPrinted error:&error];
    if (JSONData.length == 0 && error) {
        NSLog(@"转换错误%@", error.description);
        return @"";
    } else {
        return [[NSString alloc] initWithData:JSONData encoding:NSUTF8StringEncoding];
    }
}

//计算出大小
+ (NSString *)fileSizeWithInterge:(NSInteger)size {
    // 1k = 1024, 1m = 1024k
    if (size < 1024) {// 小于1k
        return [NSString stringWithFormat:@"%ldB",(long)size];
    } else if (size < 1024 * 1024){// 小于1m
        float aFloat = size/1024;
        return [NSString stringWithFormat:@"%.0fK",aFloat];
    } else if (size < 1024 * 1024 * 1024){// 小于1G
        float aFloat = size/(1024 * 1024);
        return [NSString stringWithFormat:@"%.2fM",aFloat];
    } else {
        float aFloat = size/(1024*1024*1024);
        return [NSString stringWithFormat:@"%.2fG",aFloat];
    }
}

@end
