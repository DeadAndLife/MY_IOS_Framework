//
//  NSDictionary+SafeDictionary.m
//  rabbit
//
//  Created by 张氏集团 Inc on 19/12/31.
//  Copyright © 2019 jixiultd. All rights reserved.
//

#import "NSDictionary+SafeDictionary.h"


@implementation NSDictionary (SafeDictionary)

- (id)safeValueForKey:(NSString *)key {
    if (![self isKindOfClass:NSDictionary.class]) {
        return nil;
    }
    id value = [self valueForKey:key];
    if (!value || (value == [NSNull null])) {
        value = nil;
    }
    return value;
}

- (id)objectAtSafeIndex:(NSUInteger)index {
    if (![self isKindOfClass:NSDictionary.class]) {
        return nil;
    }
    return [self safeValueForKey:@(index).stringValue];
}

- (id)valueForUndefinedKey:(NSString *)key {
    return nil;
}

+ (NSDictionary*)dictionaryFromQuery:(NSString*)query {
    NSCharacterSet* delimiterSet = [NSCharacterSet characterSetWithCharactersInString:@"&"];
    NSMutableDictionary* pairs = [NSMutableDictionary dictionary];
    NSScanner* scanner = [[NSScanner alloc] initWithString:query];
    while (![scanner isAtEnd]) {
        NSString* pairString = nil;
        [scanner scanUpToCharactersFromSet:delimiterSet intoString:&pairString];
        [scanner scanCharactersFromSet:delimiterSet intoString:NULL];
        NSArray* kvPair = [pairString componentsSeparatedByString:@"="];
        if (kvPair.count == 2) {
            NSString* key = [[kvPair objectAtIndex:0] stringByRemovingPercentEncoding];
            NSString* value = [[kvPair objectAtIndex:1] stringByRemovingPercentEncoding];
            [pairs setObject:value forKey:key];
        }
    }
    
    return [NSDictionary dictionaryWithDictionary:pairs];
}

@end
