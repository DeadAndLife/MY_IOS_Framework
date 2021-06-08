//
//  NSObject+RANotifaction.h
//  rabbit
//
//  Created by iOSzhang Inc on 21/1/5.
//  Copyright © 2021 jixiultd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (RANotifaction)

- (void)setValue:(id)value forKey:(NSString *)key withNotifaction:(NSString *)notifationName;

- (void)addNotifactionWithKeys:(NSArray *)keys withNotifaction:(NSString *)notifationName;

@end

NS_ASSUME_NONNULL_END
