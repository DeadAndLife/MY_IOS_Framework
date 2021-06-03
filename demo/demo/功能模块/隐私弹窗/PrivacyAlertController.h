//
//  PrivacyAlertController.h
//  zhibo
//
//  Created by iOSzhang Inc on 21/6/2.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface PrivacyAlertController : BaseViewController

+ (instancetype)shared;

- (void)showWithCancelAction:(void(^)(void))cancelAction confirmAction:(void(^)(void))confirmAction;

@end

NS_ASSUME_NONNULL_END
