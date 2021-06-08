//
//  NSArray+SafeArray.h
//  rabbit
//
//  Created by 张氏集团 Inc on 19/12/19.
//  Copyright © 2019 jixiultd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (SafeArray)

- (id)objectAtSafeIndex:(NSUInteger)index;
    
@end

NS_ASSUME_NONNULL_END
