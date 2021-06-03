//
//  JSONModel+SaveModel.m
//  zhibo
//
//  Created by iOSzhang Inc on 21/6/2.
//

#import "JSONModel+SaveModel.h"
#import "JSONModelClassProperty.h"

@implementation JSONModel (SaveModel)

+ (NSArray <NSString *>*)skipPropertyName {
    //子类实现
    return @[];
}

+ (BOOL)propertyIsSkip:(NSString *)propertyName {
    return [[self skipPropertyName] containsObject:propertyName];
}

/// 请在子类中实现存储位置方法
/// @param dict 替换参数字典
/// @param error 错误信息
- (id)initSaveModelWithDict:(NSDictionary *)dict error:(NSError **)error {
    if (!self) {
        return [self initWithDictionary:dict error:error];
    }
    for (NSString *key in dict.allKeys) {
        NSString *convertKey = [[self.class keyMapper] convertValue:key];
        
        id jsonValue;
        @try {
            jsonValue = [dict valueForKeyPath:key];
        }
        @catch (NSException *exception) {
            jsonValue = dict[key];
        }
        NSArray *properties = [self performSelector:@selector(__properties__)];
        
        for (JSONModelClassProperty *p in properties) {
            if ([p.name isEqualToString:convertKey]) {
                if ([self.class propertyIsSkip:convertKey]) {
                    [self setValue:jsonValue forKey:convertKey];
                } else {
                    if (!isNull(jsonValue)) {
                        [self setValue:jsonValue forKey:convertKey];
                    }
                }
                break;
            }
        }
    }
    
    return self;
}

@end
