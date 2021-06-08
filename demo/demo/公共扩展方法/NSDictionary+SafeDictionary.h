//
//  NSDictionary+SafeDictionary.h
//  rabbit
//
//  Created by 张氏集团 Inc on 19/12/31.
//  Copyright © 2019 jixiultd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (SafeDictionary)

- (id)safeValueForKey:(NSString *)key;

+ (NSDictionary *)dictionaryFromQuery:(NSString*)query;

@end

NS_ASSUME_NONNULL_END
