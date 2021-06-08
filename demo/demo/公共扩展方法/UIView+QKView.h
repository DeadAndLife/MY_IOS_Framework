//
//  UIView+QKView.h
//  qukanjs
//
//  Created by iOSzhang Inc on 21/1/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (QKView)

/// 扩大点击事件的响应区域
/// @param outset 扩大边界
- (void)expandResponseAreaBounds:(UIEdgeInsets)outset;

#ifdef DEBUG
/// 添加切换host功能
- (void)addChangeHostAction;
#endif

@end

NS_ASSUME_NONNULL_END
