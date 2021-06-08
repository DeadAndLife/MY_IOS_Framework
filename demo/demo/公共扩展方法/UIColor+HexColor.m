//
//  UIColor+HexColor.m
//  qukanjs
//
//  Created by iOSzhang Inc on 21/1/14.
//

#import "UIColor+HexColor.h"

//用于LAB模型计算
const float param_1_3 = 1.0f / 3.0f;
const float param_16_116 = 16.0f / 116.0f;
//const float Xn = 0.950456f;
//const float Yn = 1.0f;
//const float Zn = 1.088754f;
const float Xn = 0.95047f;
const float Yn = 1.0000001f;
const float Zn = 1.08883f;

@implementation UIColor (HexColor)

/// 判断两个色值是否相近
/// @param firstColor 第一种颜色
/// @param secondColor 第二种颜色
+ (BOOL)isNearColor:(UIColor *)firstColor secondColor:(UIColor *)secondColor {
    return [self differenceColor:firstColor secondColor:secondColor] < 10;
}

/// 两个色值的相似度[0-100]
/// @param firstColor 第一种颜色
/// @param secondColor 第二种颜色
+ (double)differenceColor:(UIColor *)firstColor secondColor:(UIColor *)secondColor {
    float X1, Y1, Z1, X2, Y2, Z2, L1, A1, B1, L2, A2, B2;
    
    [UIColor RGB2XYZ:firstColor X:&X1 Y:&Y1 Z:&Z1];
    [UIColor XYZ2Lab:X1 Y:Y1 Z:Z1 L:&L1 a:&A1 b:&B1];
    [UIColor RGB2XYZ:secondColor X:&X2 Y:&Y2 Z:&Z2];
    [UIColor XYZ2Lab:X2 Y:Y2 Z:Z2 L:&L2 a:&A2 b:&B2];
    
    //参考《现代颜色技术原理及应用》P88数据
    double E00 = 0;               //CIEDE2000色差E00
    double LL1, LL2, aa1, aa2, bb1, bb2; //声明L' a' b' （1,2）
    double delta_LL, delta_CC, delta_hh, delta_HH;        // 第二部的四个量
    double kL, kC, kH;
    double RT = 0;                //旋转函数RT
    double G = 0;                  //G表示CIELab 颜色空间a轴的调整因子,是彩度的函数.
    double mean_Cab = 0;    //两个样品彩度的算术平均值
    double SL, SC, SH, T;
    //------------------------------------------
    //
    kL = 1;
    kC = 1;
    kH = 1;
    //------------------------------------------
    mean_Cab = ([UIColor caiDu:A1 b:B1] + [UIColor caiDu:A2 b:B2]) / 2;
    double mean_Cab_pow7 = pow(mean_Cab, 7);       //两彩度平均值的7次方
    G = 0.5*(1-pow(mean_Cab_pow7 / (mean_Cab_pow7 + pow(25, 7)), 0.5));
    
    LL1 = L1;
    aa1 = A1 * (1 + G);
    bb1 = B1;
    
    LL2 = L2;
    aa2 = A2 * (1 + G);
    bb2 = B2;
    
    double CC1, CC2;               //两样本的彩度值
    CC1 = [UIColor caiDu:aa1 b:bb1];
    CC2 = [UIColor caiDu:aa2 b:bb2];
    double hh1, hh2;                  //两样本的色调角
    hh1 = [UIColor seDiaoJiao:aa1 b:bb1];
    hh2 = [UIColor seDiaoJiao:aa2 b:bb2];
    
    delta_LL = LL1 - LL2;
    delta_CC = CC1 - CC2;
    delta_hh = [UIColor seDiaoJiao:aa1 b:bb1] - [UIColor seDiaoJiao:aa2 b:bb2];
    delta_HH = 2 * sin(M_PI*delta_hh / 360) * pow(CC1 * CC2, 0.5);
    
    //-------第三步--------------
    //计算公式中的加权函数SL,SC,SH,T
    double mean_LL = (LL1 + LL2) / 2;
    double mean_CC = (CC1 + CC2) / 2;
    double mean_hh = (hh1 + hh2) / 2;
    
    SL = 1 + 0.015 * pow(mean_LL - 50, 2) / pow(20 + pow(mean_LL - 50, 2), 0.5);
    SC = 1 + 0.045 * mean_CC;
    T = 1 - 0.17 * cos((mean_hh - 30) * M_PI / 180) + 0.24 * cos((2 * mean_hh) * M_PI / 180)
    + 0.32 * cos((3 * mean_hh + 6) * M_PI / 180) - 0.2 * cos((4 * mean_hh - 63) * M_PI / 180);
    SH = 1 + 0.015 * mean_CC * T;
    
    //------第四步--------
    //计算公式中的RT
    double mean_CC_pow7 = pow(mean_CC, 7);
    double RC = 2 * pow(mean_CC_pow7 / (mean_CC_pow7 + pow(25, 7)), 0.5);
    double delta_xita = 30 * exp(-pow((mean_hh - 275) / 25, 2));        //△θ 以°为单位
    RT = -sin((2 * delta_xita) * M_PI / 180) * RC;
    
    double L_item, C_item, H_item;
    L_item = delta_LL / (kL * SL);
    C_item = delta_CC / (kC * SC);
    H_item = delta_HH / (kH * SH);
    
    E00 = pow(L_item * L_item + C_item * C_item + H_item * H_item + RT * C_item * H_item, 0.5);
    
    NSLog(@"LAB1:%@ : %lf : %lf : %lf, LAB2:%@: %lf : %lf : %lf, difference:%lf", firstColor.toHEXColorString, L1, A1, B1, secondColor.toHEXColorString, L2, A2, B2, E00);
    
    return E00;
}

/// 转换成16进制色值
- (NSString *)toHEXColorString {
    CGFloat Red, Green, Blue, Alpha;
    BOOL success = [self getRed:&Red green:&Green blue:&Blue alpha:&Alpha];
    
    int rgb = (int) (Red * 255.0f)<<16 | (int) (Green * 255.0f)<<8 | (int) (Blue * 255.0f)<<0;
    
    //    return [NSString stringWithFormat:@"#%06x, %lf", rgb, Alpha];
    return [NSString stringWithFormat:@"#%06x", rgb];
}

/// 色彩矫正
/// @param x 需矫正的值
+ (float)gamma:(float)x {
    return x>0.04045?powf((x+0.055f)/1.055f,2.4f):(x/12.92);
}

/// RGB转换为XYZ
/// @param color 色值
/// @param X 转换后X的存储位置
/// @param Y 转换后Y的存储位置
/// @param Z 转换后Z的存储位置
+ (void)RGB2XYZ:(UIColor *)color X:(float *)X Y:(float *)Y Z:(float *)Z {
    CGFloat Red, Green, Blue, Alpha;
    BOOL success = [color getRed:&Red green:&Green blue:&Blue alpha:&Alpha];
    
    float RR = [UIColor gamma:Red];
    float GG = [UIColor gamma:Green];
    float BB = [UIColor gamma:Blue];
    
    *X = 0.4124564f * RR + 0.3575761f * GG + 0.1804375f * BB;
    *Y = 0.2126729f * RR + 0.7151522f * GG + 0.0721750f * BB;
    *Z = 0.0193339f * RR + 0.1191920f * GG + 0.9503041f * BB;
}

/// XYZ转换为LAB
/// @param X X
/// @param Y Y
/// @param Z Z
/// @param L 转换后L的存储位置
/// @param a 转换后a的存储位置
/// @param b 转换后b的存储位置
+ (void)XYZ2Lab:(float)X Y:(float)Y Z:(float)Z L:(float *)L a:(float *)a b:(float *)b {
    float fX, fY, fZ;
    
    X /= (Xn);
    Y /= (Yn);
    Z /= (Zn);
    
    fY = Y>0.008856f? pow(Y, param_1_3) : 7.787f*Y + param_16_116;
    fX = X>0.008856f? pow(X, param_1_3) : 7.787f*X + param_16_116;
    fZ = Z>0.008856f? pow(Z, param_1_3) : 7.787f*Z + param_16_116;
    
    *L = 116.0f * fY - 16.0f;
    //L必须为非负数
    *L = *L > 0.0f ? *L : 0.0f;
    *a = 500.0f * (fX - fY);
    *b = 200.0f * (fY - fZ);
}

//彩度计算
+ (double)caiDu:(double)a b:(double)b {
    double Cab = 0;
    Cab = pow(a * a + b * b, 0.5);
    return Cab;
}

//色调角计算
+ (double)seDiaoJiao:(double)a b:(double)b {
    double h = 0;
    double hab = 0;
    
    h = (180 / M_PI) * atan(b/a); //有正有负(a为0)
    
    if (a>0&&b>0) {
        hab = h;
    }
    else if (a<0&&b>0) {
        hab = 180 + h;
    }
    else if (a<0&&b<0) {
        hab = 180 + h;
    }
    else if (a == 0) {
        hab = 90;
    }
    else {
        //a>0&&b<0
        hab = 360 + h;
    }
    return hab;
}

/// 将16进制hex字符串转换为颜色
/// @param hexString 16进制字符串
+ (UIColor *)colorWithHexString:(NSString *)hexString {
    NSString *cString = [[hexString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] lowercaseString];
    
    UIColor *nameForColor = [UIColor colorNameToUIColor:cString];
    if (nameForColor!=nil) {
        return nameForColor;
    }
    
    // 字符串必须最小6个字符
    if (cString.length < 3) return [UIColor clearColor];
    if ([cString hasPrefix:@"0x"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    
    if (![UIColor valideColorStrFormat:cString]) {
        return [UIColor clearColor];
    }
    
    if (cString.length==3) {
        NSArray *colorSplits = [cString componentsSeparatedByString:@""];
        if (colorSplits.count==3) {
            cString = @"";
            for (NSString *item in colorSplits) {
                cString  = [cString stringByAppendingFormat:@"%@%@",item,item];
            }
        }
    }
    if ([cString length] == 6) {// Separate into r, g, b substrings
        NSRange range;
        range.location = 0;
        range.length = 2;
        NSString *rString = [cString substringWithRange:range];
        
        range.location = 2;
        NSString *gString = [cString substringWithRange:range];
        
        range.location = 4;
        NSString *bString = [cString substringWithRange:range];
        
        // Scan values
        unsigned int r, g, b;
        [[NSScanner scannerWithString:rString] scanHexInt:&r];
        [[NSScanner scannerWithString:gString] scanHexInt:&g];
        [[NSScanner scannerWithString:bString] scanHexInt:&b];
        
        return [UIColor colorWithRed:((float) r / 255.0f)
                               green:((float) g / 255.0f)
                                blue:((float) b / 255.0f)
                               alpha:1.0f];
    } else if ([cString length] == 8) {
        NSRange range;
        range.location = 0;
        range.length = 2;
        NSString *aString = [cString substringWithRange:range];
        
        range.location = 2;
        NSString *rString = [cString substringWithRange:range];
        
        range.location = 4;
        NSString *gString = [cString substringWithRange:range];
        
        range.location = 6;
        NSString *bString = [cString substringWithRange:range];
        
        // Scan values
        unsigned int a, r, g, b;
        [[NSScanner scannerWithString:aString] scanHexInt:&a];
        [[NSScanner scannerWithString:rString] scanHexInt:&r];
        [[NSScanner scannerWithString:gString] scanHexInt:&g];
        [[NSScanner scannerWithString:bString] scanHexInt:&b];
        
        return [UIColor colorWithRed:((float) r / 255.0f)
                               green:((float) g / 255.0f)
                                blue:((float) b / 255.0f)
                               alpha:((float) a / 255.0f)];
    } else {
        return [UIColor clearColor];
    }
}

/**
 *
 * 通过颜色名称读取Color
 */
+ (UIColor *)colorNameToUIColor:(NSString *)name {
    if (name==nil || name.length==0) {
        return nil;
    }
    
    name = [name lowercaseString];
    
    NSDictionary *COLOR_DICT = @{
        @"transparent":[UIColor colorWithRed:0 green:0 blue:0 alpha:0],
        @"black":[UIColor blackColor],
        @"white":[UIColor whiteColor],
        @"gray":[UIColor grayColor],
        @"green":[UIColor greenColor],
        @"blue":[UIColor blueColor],
        @"cyan":[UIColor cyanColor],
        @"yellow":[UIColor yellowColor],
        @"magenta":[UIColor magentaColor],
        @"orange":[UIColor orangeColor],
        @"purple":[UIColor purpleColor],
        @"brown":[UIColor brownColor]
    };
    
    if ([COLOR_DICT.allKeys containsObject:name]) {
        return COLOR_DICT[name];
    }
    return  nil;
}

/**
 ** 颜色值校验
 **/
+ (BOOL)valideColorStrFormat:(NSString *)source {
    if (source==nil || source.length==0) {
        return NO;
    }
    
    if (source.length!=3 && source.length!=6 && source.length!=8) {
        return NO;
    }
    
    NSError * error;
    NSString * strNumberRegExp = @"^(([\\da-fA-F]{3}){1,2}|([\\da-fA-F]{8}))$";
    NSRegularExpression * regExp = [NSRegularExpression regularExpressionWithPattern:strNumberRegExp options:NSRegularExpressionDotMatchesLineSeparators|NSRegularExpressionCaseInsensitive error:&error];
    NSArray * matchResults  = [regExp matchesInString:source options:NSMatchingReportCompletion range:NSMakeRange(0, source.length)];
    
    if (matchResults!=nil && matchResults.count==1) {
        NSRange range = [matchResults[0] range];
        return [source isEqualToString:[source substringWithRange:range]];
    }
    
    return NO;
    
}

@end
