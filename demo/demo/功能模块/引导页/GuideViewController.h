//
//  GuideViewController.h
//  zhibo
//
//  Created by iOSzhang Inc on 21/6/3.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface GuideViewController : BaseViewController

+ (instancetype)shared;

- (void)showWithConfirmAction:(void(^)(void))confirmAction;

@end

NS_ASSUME_NONNULL_END
