//
//  JSONModel+SaveModel.h
//  zhibo
//
//  Created by iOSzhang Inc on 21/6/2.
//

#import <JSONModel/JSONModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface JSONModel (SaveModel)

+ (NSArray <NSString *>*)skipPropertyName;

/// 请在子类中实现存储位置方法
/// @param dict 替换参数字典
/// @param error 错误信息
- (id)initSaveModelWithDict:(NSDictionary *)dict error:(NSError **)error;

/// 单例类存储位置方法 不适用于嵌套model
/// @param dict 替换参数字典
/// @param error 错误信息
- (void)sharedSaveModelWithDict:(NSDictionary *)dict error:(NSError **)error;

@end

NS_ASSUME_NONNULL_END
