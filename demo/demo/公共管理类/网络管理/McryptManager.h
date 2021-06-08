//
//  McryptManager.h
//  qukanjs
//
//  Created by iOSzhang Inc on 21/1/14.
//

#import <Foundation/Foundation.h>

#define McryptIV @""
#define McryptKey @""

NS_ASSUME_NONNULL_BEGIN

@interface McryptManager : NSObject

/// AES-256-CBC加密
/// @param clearText 需要加密的字符串
/// @param key 加密密钥
+ (NSString *)encryptUseAESForString:(NSString *)clearText key:(NSString *)key;

/// AES-256-CBC加密
/// @param data 需要加密的数据
/// @param key 加密密钥
+ (NSString *)encryptUseAESForData:(NSData *)data key:(NSString *)key;

/// AES-256-CBC解密
/// @param plainText 需要解密的字符串
/// @param key 解密密钥
+ (id)decryptUseAES:(NSString *)plainText key:(NSString *)key;

/// AES-256-CBC解密
/// @param data 需要解密的数据
/// @param key 解密密钥
+ (id)decryptUseAESForData:(NSData *)data key:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
