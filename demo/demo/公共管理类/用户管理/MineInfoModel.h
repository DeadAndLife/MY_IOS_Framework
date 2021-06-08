//
//  MineInfoModel.h
//  qukanjs
//
//  Created by iOSzhang Inc on 21/1/14.
//

#import <JSONModel/JSONModel.h>
#import "JSONModel+SaveModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MineInfoModel : JSONModel

+ (instancetype)share;

/// <#Description#>
@property (nonatomic, copy) NSString *id;

/// 清空数据
- (void)reset;

@end

NS_ASSUME_NONNULL_END
