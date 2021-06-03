//
//  McryptManager.h
//  qukanjs
//
//  Created by iOSzhang Inc on 21/1/14.
//

#import <Foundation/Foundation.h>

#define McryptKey @"Sm9bGEwfkevbj61v"
#define McryptSecretKey @"UbLUa4fNrQ5kMLuW"

NS_ASSUME_NONNULL_BEGIN

@interface McryptManager : NSObject

/*!
 AES加密
 
 @param clearText 需要加密的字符串
 
 @param key 加密密钥
 
 @return NSString 加密后的字符串
 */
+ (NSString *)encryptUseAESForString:(NSString *)clearText key:(NSString *)key;

/**
 AES加密

 @param data 需要加密的数据
 @param key 加密密钥
 @return 加密后的字符串
 */
+ (NSString *)encryptUseAESForData:(NSData *)data key:(NSString *)key;

/*!
 AES解密
 
 @param plainText 需要解密的字符串
 
 @param key 解密密钥
 
 @return NSString 解密后的字符串
 */
+ (NSString *)decryptUseAES:(NSString *)plainText key:(NSString *)key;


+ (NSString*)stringWithHexBytes2:(NSData *)sender;

+ (NSData*)parseHexToByteArray:(NSString*) hexString;


+ (NSString *)parseByte2HexString:(Byte *) bytes;

+ (NSString *)parseByteArray2HexString:(Byte[]) bytes;

@end

NS_ASSUME_NONNULL_END
