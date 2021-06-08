//
//  NSObject+RANotifaction.m
//  rabbit
//
//  Created by iOSzhang Inc on 21/1/5.
//  Copyright © 2021 jixiultd. All rights reserved.
//

#import "NSObject+RANotifaction.h"

@implementation NSObject (RANotifaction)

- (void)setValue:(id)value forKey:(NSString *)key withNotifaction:(NSString *)notifationName {
    [self setValue:value forKey:key];
    if (value) {
        [[NSNotificationCenter defaultCenter] postNotificationName:[notifationName stringByAppendingFormat:@"_%@", key] object:value];        
    }
}

- (void)addNotifactionWithKeys:(NSArray *)keys withNotifaction:(NSString *)notifationName {
    //需要在实现该方法的类dealloc方法手动移除通知监听
    for (NSString *key in keys) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:NSSelectorFromString([NSString stringWithFormat:@"%@ValueChanged:", key]) name:[notifationName stringByAppendingFormat:@"_%@", key] object:nil];
    }
}

@end
