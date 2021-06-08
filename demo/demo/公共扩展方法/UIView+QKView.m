//
//  UIView+QKView.m
//  qukanjs
//
//  Created by iOSzhang Inc on 21/1/18.
//

#import "UIView+QKView.h"
#import "ChangeHostViewController.h"

@implementation UIView (QKView)

+ (void)load {
    //获取替换后的实例方法
    Method newMethod = class_getInstanceMethod([self class], @selector(qy_pointInside:withEvent:));
    //获取替换前的实例方法
    Method origMethod = class_getInstanceMethod([self class], @selector(pointInside:withEvent:));
    //然后交换实例方法
    method_exchangeImplementations(newMethod, origMethod);
}

static char expandSizeKey;
- (void)expandResponseAreaBounds:(UIEdgeInsets)outset{
    //OBJC_EXPORT void objc_setAssociatedObject(id object, const void *key, id value, objc_AssociationPolicy policy)
    //OBJC_EXPORT 打包lib时，用来说明该函数是暴露给外界调用的。
    //id object 表示关联者，是一个对象
    //id value 表示被关联者，可以理解这个value最后是关联到object上的
    //const void *key 被关联者也许有很多个，所以通过key可以找到指定的那个被关联者
    
    objc_setAssociatedObject(self, &expandSizeKey, [NSValue valueWithUIEdgeInsets:outset], OBJC_ASSOCIATION_COPY_NONATOMIC);
}

//获取设置的扩大size，来扩大button的rect
//当前只是设置了一个扩大的size，当然也可以设置4个扩大的size，上下左右，具体扩大多少对应button的四个边传入对应的size
- (CGRect)expandRect {
    
    NSValue *outsetValue = objc_getAssociatedObject(self, &expandSizeKey);
    UIEdgeInsets outset = outsetValue.UIEdgeInsetsValue;
    //
    if (outsetValue) {
        return CGRectMake(self.bounds.origin.x - outset.left,
                          self.bounds.origin.y - outset.top,
                          self.bounds.size.width + outset.left + outset.right,
                          self.bounds.size.height + outset.top + outset.bottom);
    } else {
        return self.bounds;
    }
}

//响应用户的点击事件
- (BOOL)qy_pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    
    CGRect expandedRect = [self expandRect];
    if (CGRectEqualToRect(expandedRect, self.bounds)) {
        return [self qy_pointInside:point withEvent:event];
    }
    return CGRectContainsPoint(expandedRect, point) ? YES : NO;
}

#ifdef DEBUG
/// 添加切换host功能
- (void)addChangeHostAction {
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changedHost:)];
    tapGR.numberOfTapsRequired = 10;
    [self addGestureRecognizer:tapGR];
}

- (IBAction)changedHost:(UITapGestureRecognizer *)sender {
    [[ChangeHostViewController shared] showWithCancelAction:^{
        //未切换域名
    } confirmAction:^{
        //切换域名后需要重新登录
        [[UserManger share] logout];
    }];
}

#endif

@end
