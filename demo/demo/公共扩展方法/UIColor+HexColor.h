//
//  UIColor+HexColor.h
//  qukanjs
//
//  Created by iOSzhang Inc on 21/1/14.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (HexColor)

/// 转换成16进制色值
- (NSString *)toHEXColorString;

/// 将16进制hex字符串转换为颜色
/// @param hexString 16进制字符串 ARGB
+ (UIColor *)colorWithHexString:(NSString *)hexString;

/// 判断两个色值是否相近
/// @param firstColor 第一种颜色
/// @param secondColor 第二种颜色
+ (BOOL)isNearColor:(UIColor *)firstColor secondColor:(UIColor *)secondColor;

/// 两个色值的相似度[0-100]
/// @param firstColor 第一种颜色
/// @param secondColor 第二种颜色
+ (double)differenceColor:(UIColor *)firstColor secondColor:(UIColor *)secondColor;

@end

NS_ASSUME_NONNULL_END
