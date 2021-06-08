//
//  NSArray+SafeArray.m
//  rabbit
//
//  Created by 张氏集团 Inc on 19/12/19.
//  Copyright © 2019 jixiultd. All rights reserved.
//

#import "NSArray+SafeArray.h"

@implementation NSArray (SafeArray)

- (id)objectAtSafeIndex:(NSUInteger)index {
    if (![self isKindOfClass:NSArray.class]) {
        return nil;
    }
    if (index>=self.count) {
        return nil;
    }
    
    id value = [self objectAtIndex:index];
    if (value == [NSNull null]) {
        return nil;
    }
    
    return value;
}

- (id)safeValueForKey:(NSString *)key {
    if (![self isKindOfClass:NSArray.class]) {
        return nil;
    }
    return [self objectAtSafeIndex:key.integerValue];
}

- (id)valueForUndefinedKey:(NSString *)key {
    return nil;
}

@end
