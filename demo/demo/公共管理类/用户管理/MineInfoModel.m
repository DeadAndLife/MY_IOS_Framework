//
//  MineInfoModel.m
//  qukanjs
//
//  Created by iOSzhang Inc on 21/1/14.
//

#import "MineInfoModel.h"
#import "JSONModelClassProperty.h"

#define UserInfoPath  [NSString stringWithFormat:@"%@/Documents/userInfo.user",NSHomeDirectory()]

@implementation MineInfoModel

+ (instancetype)share {
    static MineInfoModel *obj = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSDictionary *dataDict = [NSDictionary dictionaryWithContentsOfFile:UserInfoPath];
        obj = [[MineInfoModel alloc] initWithDictionary:dataDict error:nil];
        if (!obj) {
            obj = [[MineInfoModel alloc] init];
        }
    });
    return obj;
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
//    if ([propertyName isEqualToString:@"id"]) {
//        return false;
//    }
    return true;
}

//+ (JSONKeyMapper *)keyMapper {
//    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{
//        @"token":@"_token"
//    }];
//}

+ (NSArray<NSString *> *)skipPropertyName {
    return @[
    ];
}

/// 请在子类中实现存储位置方法
/// @param dict 替换参数字典
/// @param error 错误信息
- (id)initSaveModelWithDict:(NSDictionary *)dict error:(NSError **)error {
    self = [super initSaveModelWithDict:dict error:error];
    
    [[self toDictionary] writeToFile:UserInfoPath atomically:true];
    
    return self;
}

/// 清空数据
- (void)reset {
    //清除用户模型
    if ([[NSFileManager defaultManager] fileExistsAtPath:UserInfoPath]) {
        [[NSFileManager defaultManager] removeItemAtPath:UserInfoPath error:nil];
    }
//    NSArray *propertiesList = [self performSelector:@selector(__properties__)];
//    //全部内容置空
//    for (JSONModelClassProperty *property in propertiesList) {
//        [self setValue:nil forKey:property.name];
//    }
}

- (void)sharedSaveModelWithDict:(NSDictionary *)dict error:(NSError *__autoreleasing  _Nullable *)error {
    [super sharedSaveModelWithDict:dict error:error];
    
    [[self toDictionary] writeToFile:UserInfoPath atomically:true];
}

@end
