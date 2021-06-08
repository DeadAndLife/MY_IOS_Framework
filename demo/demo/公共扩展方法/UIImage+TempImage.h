//
//  UIImage+TempImage.h
//  qukanjs
//
//  Created by iOSzhang Inc on 21/1/14.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (TempImage)

+ (UIImage *)imageWithColor:(UIColor *)color;

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

/// 剪裁指定区域的图片后返回
/// @param image 需要剪裁的图片
/// @param rect 剪裁区域
+ (UIImage *)catImageFromImage:(UIImage *)image inRect:(CGRect)rect;

/// UIImage加圆角
/// @param original 图片
/// @param cornerRadius 圆角
+ (UIImage *)p_generateCornerRadiusImage:(UIImage *)original cornerRadius:(CGFloat)cornerRadius;

/// 从base64数据中获取图片
/// @param base64String base64字符串
+ (UIImage *)imageWithBase64String:(NSString *)base64String;

@end

NS_ASSUME_NONNULL_END
