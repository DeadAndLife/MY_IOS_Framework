//
//  ChangeHostViewController.h
//  zhibo
//
//  Created by iOSzhang Inc on 21/6/8.
//

#import "BaseViewController.h"

#ifdef DEBUG

NS_ASSUME_NONNULL_BEGIN

@interface ChangeHostViewController : BaseViewController

+ (instancetype)shared;

- (void)showWithCancelAction:(void(^)(void))cancelAction confirmAction:(void(^)(void))confirmAction;

@end

NS_ASSUME_NONNULL_END

#endif
