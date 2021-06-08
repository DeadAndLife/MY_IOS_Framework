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

/// 单例类存储位置方法
/// @param dict 替换参数字典
/// @param error 错误信息
- (void)sharedSaveModelWithDict:(NSDictionary *)dict error:(NSError **)error {
    //check for nil input
    if (!dict) {
        if (error) *error = [JSONModelError errorInputIsNil];
    }

    //invalid input, just create empty instance
    if (![dict isKindOfClass:[NSDictionary class]]) {
        if (error) *error = [JSONModelError errorInvalidDataWithMessage:@"Attempt to initialize JSONModel object using initWithDictionary:error: but the dictionary parameter was not an 'NSDictionary'."];
    }

    //create a class instance
    if (!self) {

        //super init didn't succeed
        if (error) *error = [JSONModelError errorModelIsInvalid];
    }

    //check incoming data structure
    //校验步骤暂时不做了
//    if (![self __doesDictionary:dict matchModelWithKeyMapper:self.__keyMapper error:error]) {
//    }

    //import the data from a dictionary
    if (![self resaveDictionary:dict withKeyMapper:self.class.keyMapper validation:YES error:error]) {
    }

    //run any custom model validation
    if (![self validate:error]) {
    }
}

- (BOOL)resaveDictionary:(NSDictionary *)dict withKeyMapper:(JSONKeyMapper *)keyMapper validation:(BOOL)validation error:(NSError **)err {
    //loop over the incoming keys and set self's properties
    NSArray *propertiesList = [self performSelector:@selector(__properties__)];
    for (JSONModelClassProperty* property in propertiesList) {
        
        //convert key name to model keys, if a mapper is provided
        NSString* jsonKeyPath = (keyMapper) ? [self performSelector:@selector(__mapString:withKeyMapper:) withObject:property.name withObject:keyMapper] : property.name;
        //JMLog(@"keyPath: %@", jsonKeyPath);
        
        //general check for data type compliance
        id jsonValue;
        @try {
            jsonValue = [dict valueForKeyPath:jsonKeyPath];
        }
        @catch (NSException *exception) {
            jsonValue = dict[jsonKeyPath];
        }
        
        //check for Optional properties
        if (isNull(jsonValue)) {
            //skip this property, continue with next property
            if (property.isOptional || !validation) continue;
            
            if (err) {
                //null value for required property
                NSString* msg = [NSString stringWithFormat:@"Value of required model key %@ is null", property.name];
                JSONModelError* dataErr = [JSONModelError errorInvalidDataWithMessage:msg];
                *err = [dataErr errorByPrependingKeyPathComponent:property.name];
            }
            return NO;
        }
        
        //check if there's matching property in the model
        if (property) {
            // check for custom setter, than the model doesn't need to do any guessing
            // how to read the property's value from JSON
            if ([self performSelector:@selector(__customSetValue:forProperty:) withObject:jsonValue withObject:property]) {
                //skip to next JSON key
                continue;
            };
            
            // 0) handle primitives
            if (property.type == nil && property.structName==nil) {
                
                //generic setter
                if (jsonValue != [self valueForKey:property.name]) {
                    [self setValue:jsonValue forKey: property.name];
                }
                
                //skip directly to the next key
                continue;
            }
            
            // 0.5) handle nils
            if (isNull(jsonValue)) {
                if ([self.class.skipPropertyName containsObject:property.name]) {
                    //包含则nil赋值，否则使用原来的
                    if ([self valueForKey:property.name] != nil) {
                        [self setValue:nil forKey: property.name];
                    }
                }
                continue;
            }
            
            // 1) check if property is itself a JSONModel
            // 不做嵌套执行
            [self setValue:jsonValue forKey: property.name];
        }
    }
    
    return YES;
}

@end
