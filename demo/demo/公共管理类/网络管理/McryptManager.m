//
//  McryptManager.m
//  qukanjs
//
//  Created by iOSzhang Inc on 21/1/14.
//

#import "McryptManager.h"
#import <CommonCrypto/CommonCryptor.h>

@implementation McryptManager

#pragma mark - AES_Mathed

/******************************************************************************
 文本数据进行AES加密
 ******************************************************************************/

+ (NSString *)encryptUseAESForString:(NSString *)clearText key:(NSString *)key {
    
    NSString *ciphertext = nil;
    
    //因为ccNoPadding非对齐方式，但是CCCryptorFinal要求对齐，所以在这里自动补位
    NSInteger size = kCCBlockSizeAES128-clearText.length%kCCBlockSizeAES128;
    for (int i=0; i<size; i++) {
        clearText = [clearText stringByAppendingString:@" "];
    }
    
    NSData *textData = [clearText dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    ciphertext = [self encryptUseAESForData:textData key:key];
    
    return ciphertext;
}

+ (NSString *)encryptUseAESForData:(NSData *)data key:(NSString *)key {
    NSString *ciphertext = nil;
    NSUInteger dataLength = [data length];
    
    NSData *ivData = [McryptKey dataUsingEncoding:NSUTF8StringEncoding];
    NSData *keyData = [key dataUsingEncoding:NSUTF8StringEncoding];
    
    // 声明 CCCryptoRef 用于返回结果数据.
    CCCryptorRef cryptorRef = nil;
    
    CCCryptorStatus cryptStatus =
    CCCryptorCreateWithMode(kCCEncrypt,
                            kCCModeCBC,
                            kCCAlgorithmAES,
                            ccNoPadding,
                            ivData.bytes,
                            keyData.bytes,
                            keyData.length,
                            NULL,
                            0,
                            0,
                            0,
                            &cryptorRef);
    if (cryptStatus != kCCSuccess) {
        NSLog(@"AES加密失败CCCryptorCreateWithMode()%d", cryptStatus);
    }
    size_t bufsize = CCCryptorGetOutputLength(cryptorRef, dataLength, false);
    size_t bufused = 0;
    size_t bytesTotal = 0;
    void * buf = malloc(bufsize);
//    NSLog(@"bufsize:%ld", bufsize);
    cryptStatus = CCCryptorUpdate(cryptorRef, data.bytes, data.length, buf, bufsize, &bufused);
//    NSLog(@"bytesTotal:%ld, bufused:%ld", bytesTotal, bufused);
    if (cryptStatus != kCCSuccess) {
        NSLog(@"AES加密失败CCCryptorUpdate()%d", cryptStatus);
    }
    bytesTotal += bufused;
    cryptStatus = CCCryptorFinal(cryptorRef, buf + bufused, bufsize - bufused, &bufused);
    bytesTotal += bufused;
//    NSLog(@"bytesTotal:%ld, bufused:%ld", bytesTotal, bufused);
    
    if (cryptStatus == kCCSuccess) {
        NSData *result = [NSData dataWithBytes:buf length:bytesTotal];
        ciphertext = [self stringWithHexBytes2:result];
        
//        NSLog(@"AES加密成功\t%@", ciphertext);
    } else {
        NSData *result = [NSData dataWithBytes:buf length:bytesTotal];
        NSString *resultString = [self stringWithHexBytes2:result];
        
        NSLog(@"AES加密失败CCCryptorFinal()%d\t%@", cryptStatus, resultString);
    }
    
    free(buf);
    CCCryptorRelease(cryptorRef);
    
    return ciphertext;
}

/******************************************************************************
 文本数据进行AES解密
 ******************************************************************************/
+ (NSString *)decryptUseAES:(NSString *)plainText key:(NSString *)key {
    
    NSString *cleartext = nil;
    
    NSData *textData = [[NSData alloc]initWithBase64EncodedString:plainText options:0];
    NSData *ivData = [[NSData alloc]initWithBase64EncodedString:McryptKey options:0];
    
    NSUInteger dataLength = [textData length];
    
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    
    void *buffer = malloc(bufferSize);
    
    size_t numBytesEncrypted = 0;
    
    CCCryptorStatus cryptStatus =
    CCCrypt(kCCDecrypt,
            kCCAlgorithmAES128,
            kCCOptionECBMode,
            [key UTF8String],
            kCCKeySizeAES256,
            [ivData bytes],
            [textData bytes],
            dataLength,
            buffer,
            bufferSize,
            &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        NSLog(@"AES解密成功");
        
        NSData *data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesEncrypted];
        cleartext = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
    }else{
        NSLog(@"AES解密失败");
    }
    
    free(buffer);
    return cleartext;
}

#pragma mark - ToHex_Mathed

/*
 nsdata转成16进制字符串
 */
+ (NSString*)stringWithHexBytes2:(NSData *)sender {
    NSMutableString *str = [NSMutableString string];
    [sender enumerateByteRangesUsingBlock:^(const void * _Nonnull bytes, NSRange byteRange, BOOL * _Nonnull stop) {
        for (NSInteger i=0;i<byteRange.length;i++) {
            NSString *hexStr = [NSString stringWithFormat:@"%x",((uint8_t *)bytes)[i] & 0xff];
            if (hexStr.length == 2) {
                [str appendString:hexStr];
            } else {
                [str appendString:[NSString stringWithFormat:@"0%@",hexStr]];
            }
        }
    }];
    return str;
//    static const char hexdigits[] = "0123456789ABCDEF";
//    const size_t numBytes = [sender length];
//    const unsigned char* bytes = [sender bytes];
//    char *strbuf = (char *)malloc(numBytes * 2 + 1);
//    char *hex = strbuf;
//    NSString *hexBytes = nil;
//
//    for (int i = 0; i<numBytes; ++i) {
//        const unsigned char c = *bytes++;
//        *hex++ = hexdigits[(c >> 4) & 0xF];
//        *hex++ = hexdigits[(c ) & 0xF];
//    }
//
//    *hex = 0;
//    hexBytes = [NSString stringWithUTF8String:strbuf];
//
//    free(strbuf);
//    return hexBytes;
}


/*
 将16进制数据转化成NSData数组
 */
+ (NSData*)parseHexToByteArray:(NSString*)hexString {
    int j=0;
    Byte bytes[hexString.length];
    for(int i=0;i<[hexString length];i++)
    {
        int int_ch;  // 两位16进制数转化后的10进制数
        unichar hex_char1 = [hexString characterAtIndex:i]; //两位16进制数中的第一位(高位*16)
        int int_ch1;
        if(hex_char1 >= '0' && hex_char1 <='9')
            int_ch1 = (hex_char1-48)*16;   // 0 的Ascll - 48
        else if(hex_char1 >= 'A' && hex_char1 <='F')
            int_ch1 = (hex_char1-55)*16; // A 的Ascll - 65
        else
            int_ch1 = (hex_char1-87)*16; // a 的Ascll - 97
        i++;
        unichar hex_char2 = [hexString characterAtIndex:i]; ///两位16进制数中的第二位(低位)
        int int_ch2;
        if(hex_char2 >= '0' && hex_char2 <='9')
            int_ch2 = (hex_char2-48); // 0 的Ascll - 48
        else if(hex_char2 >= 'A' && hex_char1 <='F')
            int_ch2 = hex_char2-55; // A 的Ascll - 65
        else
            int_ch2 = hex_char2-87; // a 的Ascll - 97
        
        int_ch = int_ch1+int_ch2;
        bytes[j] = int_ch;  //将转化后的数放入Byte数组里
        j++;
    }
    
    NSData *newData = [[NSData alloc] initWithBytes:bytes length:hexString.length/2];
    return newData;
}

/*
 byte数据转换为字符串
 */
+ (NSString *)parseByte2HexString:(Byte *) bytes {
    NSMutableString *hexStr = [[NSMutableString alloc]init];
    int i = 0;
    if(bytes)
    {
        while (bytes[i] != '\0')
        {
            NSString *hexByte = [NSString stringWithFormat:@"%x",bytes[i] & 0xff];//16进制数
            if([hexByte length]==1)
                [hexStr appendFormat:@"0%@", hexByte];
            else
                [hexStr appendFormat:@"%@", hexByte];
            
            i++;
        }
    }
    return hexStr;
}

/*
 byte数组转换为字符串
 */
+ (NSString *)parseByteArray2HexString:(Byte[]) bytes {
    NSMutableString *hexStr = [[NSMutableString alloc]init];
    int i = 0;
    if(bytes)
    {
        while (bytes[i] != '\0')
        {
            NSString *hexByte = [NSString stringWithFormat:@"%x",bytes[i] & 0xff];//16进制数
            if([hexByte length]==1)
                [hexStr appendFormat:@"0%@", hexByte];
            else
                [hexStr appendFormat:@"%@", hexByte];
            
            i++;
        }
    }
    return [hexStr uppercaseString];
}

@end
