//
//  NSData+Encrypt.m
//  kvtemplate
//
//  Created by kevin on 2020/6/15.
//  Copyright © 2020 kevin. All rights reserved.
//

#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>

#import "NSData+Encrypt.h"

@implementation NSData (Encrypt)

+ (NSData *)aes128ECBEncrypt:(NSData *)data key:(NSString *)key {
    return [NSData dataByAes128ECB:data key:key mode:(kCCEncrypt)];
}

+ (NSData *)aes128ECBDecrypt:(NSData *)data key:(NSString *)key {
    return [NSData dataByAes128ECB:data key:key mode:(kCCDecrypt)];
}

+ (NSData *)aes128CBCEncrypt:(NSData *)data key:(NSString *)key iv:(NSString *)iv {
    return [NSData dataByAes128CBC:data key:key mode:(kCCEncrypt) iv:iv];
}

+ (NSData *)aes128CBCDecrypt:(NSData *)data key:(NSString *)key iv:(NSString *)iv {
    return [NSData dataByAes128CBC:data key:key mode:(kCCDecrypt) iv:iv];
}

+ (NSData *)dataByAes128ECB:(NSData *)data key:(NSString *)key mode:(CCOperation)operation {
    
    if (data.length == 0) {
        return data;
    }
    if (!key.length) {
        key = @"";
    }
    
    char keyPtr[kCCKeySizeAES128 + 1];//选择aes128加密，所以key长度应该是kCCKeySizeAES128，16位
    bzero(keyPtr, sizeof(keyPtr));//清零
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];//秘钥key转成cString
    
    NSUInteger dataLength = data.length;
    size_t bufferSize = dataLength + kCCBlockSizeAES128; // 以AES加密为例解释一下，128、192、256这里都是一样的，AES固定加密块为128位（16个字节），分组之后如果加密块16字节，自动补全，如果加密data.length正好是16的倍数，则需要在后面再补全一个加密块的长度，所以这里申请的空间需要比被操作的数据长度多一个密码块的长度
    
    void * buffer = malloc(bufferSize);
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(operation,
                                          kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,//ECB模式
                                          keyPtr,
                                          kCCKeySizeAES256,
                                          NULL,//选择ECB模式，不需要向量
                                          data.bytes,
                                          dataLength,
                                          buffer,
                                          bufferSize,
                                          &numBytesDecrypted);
    if (cryptStatus == kCCSuccess) {
        NSData * result = [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
        return result;
    }
    free(buffer);
    return nil;
}

+(NSData *)dataByAes128CBC:(NSData *)data key:(NSString *)key mode:(CCOperation)operation iv:(NSString *)iv {
    
    if (data.length == 0) {
        return data;
    }
    if (!key.length) {
        key = @"";
    }
    if (!iv.length) {
        iv = @"";
    }
    
    char keyPtr[kCCKeySizeAES128 + 1];
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    NSUInteger dataLength = data.length;
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void * buffer = malloc(bufferSize);
    size_t numBytesDecrypted = 0;
    
    NSString * initIv = iv;
    char ivPtr[kCCBlockSizeAES128+1];
    memset(ivPtr, 0, sizeof(ivPtr));
    [initIv getCString:ivPtr maxLength:sizeof(ivPtr) encoding:NSUTF8StringEncoding];
    CCCryptorStatus cryptStatus = CCCrypt(operation,
                                          kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding,
                                          keyPtr,
                                          kCCKeySizeAES128,
                                          ivPtr,
                                          data.bytes,
                                          dataLength,
                                          buffer,
                                          bufferSize,
                                          &numBytesDecrypted);
    if (cryptStatus == kCCSuccess) {
        NSData * result = [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
        return result;
    }
    free(buffer);
    return nil;
}

@end
