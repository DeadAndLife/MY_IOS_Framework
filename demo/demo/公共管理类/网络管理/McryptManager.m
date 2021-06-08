//
//  McryptManager.m
//  qukanjs
//
//  Created by iOSzhang Inc on 21/1/14.
//

#import "McryptManager.h"
#import <CommonCrypto/CommonCryptor.h>

//NSString const *kInitVector = @"";
size_t const kKeySize = kCCKeySizeAES256;

@implementation McryptManager

#pragma mark - AES_Mathed

/******************************************************************************
 文本数据进行AES加密
 ******************************************************************************/

/// AES加密
/// @param clearText 需要加密的字符串
/// @param key 加密密钥
+ (NSString *)encryptUseAESForString:(NSString *)clearText key:(NSString *)key {
    NSString *ciphertext = nil;
    
    //ccnopadding需要自己补位
//    NSInteger size = kCCBlockSizeAES128-clearText.length%kCCBlockSizeAES128;
//    for (int i=0; i<size; i++) {
//        clearText = [clearText stringByAppendingString:@" "];
//    }
    
    NSData *textData = [clearText dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSData *keyData = [key dataUsingEncoding:NSASCIIStringEncoding];
    
    NSData *finalData = cipherOperation(textData, keyData, kCCEncrypt);
    
    ciphertext = [finalData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    ciphertext = [self replaceImageHtml:ciphertext];
    
    return ciphertext;
}

/// AES加密
/// @param data 需要加密的数据
/// @param key 加密密钥
+ (NSString *)encryptUseAESForData:(NSData *)data key:(NSString *)key {
    NSString *ciphertext = nil;
    
    NSData *keyData = [key dataUsingEncoding:NSASCIIStringEncoding];
    
    NSData *finalData = cipherOperation(data, keyData, kCCEncrypt);
    
    ciphertext = [finalData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    ciphertext = [self replaceImageHtml:ciphertext];
    
    return ciphertext;
}

/// AES解密
/// @param plainText 需要解密的字符串
/// @param key 解密密钥
+ (id)decryptUseAES:(NSString *)plainText key:(NSString *)key {
    id ciphertext = nil;
    
    NSData *textData = [[NSData alloc] initWithBase64EncodedString:plainText options:NSDataBase64DecodingIgnoreUnknownCharacters];
    NSData *keyData = [key dataUsingEncoding:NSASCIIStringEncoding];
    
    NSData *finalData = cipherOperation(textData, keyData, kCCDecrypt);
    
    NSError *error;
    ciphertext = [NSJSONSerialization JSONObjectWithData:finalData options:NSJSONReadingMutableContainers error:&error];
    
    return ciphertext;
}

/// AES解密
/// @param data 需要解密的数据
/// @param key 解密密钥
+ (id)decryptUseAESForData:(NSData *)data key:(NSString *)key {
    id ciphertext = nil;
    
    NSData *keyData = [key dataUsingEncoding:NSASCIIStringEncoding];
    NSData *textData = [[NSData alloc] initWithBase64EncodedString:[[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding] options:NSDataBase64DecodingIgnoreUnknownCharacters];
    
    NSData *finalData = cipherOperation(textData, keyData, kCCDecrypt);
    
    NSError *error;
    ciphertext = [NSJSONSerialization JSONObjectWithData:finalData options:NSJSONReadingMutableContainers error:&error];
    
    return ciphertext;
}

NSData *cipherOperation(NSData *contentData, NSData *keyData, CCOperation operation) {
    NSUInteger dataLength = contentData.length;
    void const *initVectorBytes = [McryptIV dataUsingEncoding:NSASCIIStringEncoding].bytes;
    void const *contentBytes = contentData.bytes;
    void const *keyBytes = keyData.bytes;
    size_t operationSize = dataLength + kCCBlockSizeAES128;
    void *operationBytes = malloc(operationSize);
    if (operationBytes == NULL) {
        return nil;
    }
    size_t actualOutSize = 0;
    CCCryptorStatus cryptStatus =
    CCCrypt(operation,
            kCCAlgorithmAES,
            kCCOptionPKCS7Padding,
            keyBytes,
            kKeySize,
            initVectorBytes,
            contentBytes,
            dataLength,
            operationBytes,
            operationSize,
            &actualOutSize);
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:operationBytes length:actualOutSize];
    }
    free(operationBytes);
    operationBytes = NULL;
    return nil;
}

+ (NSString *)replaceImageHtml:(NSString *)string {
    NSString *regex = @"[\\s]";
    NSString *replacement = @"";
    NSRegularExpression *regExp = [[NSRegularExpression alloc] initWithPattern:regex options:NSRegularExpressionCaseInsensitive error:nil];
    NSString *resultStr = string;
    resultStr = [regExp stringByReplacingMatchesInString:string options:NSMatchingReportProgress range:NSMakeRange(0, string.length) withTemplate:replacement];
    return resultStr;
}

@end
