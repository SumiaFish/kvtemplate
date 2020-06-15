//
//  NSString+Encrypt.m
//  kvtemplate
//
//  Created by kevin on 2020/6/15.
//  Copyright © 2020 kevin. All rights reserved.
//

#import "NSString+Encrypt.h"

#import <CommonCrypto/CommonDigest.h>

@implementation NSString (Encrypt)

//+ (NSString *)aes128ECBEncrypt:(NSString *)string key:(NSString *)key {
//    
//    if (!string.length) {
//        return string;
//    }
//    if (!key.length) {
//        key = @"";
//    }
//    
//    const char *cstr = [string cStringUsingEncoding:NSUTF8StringEncoding];
//    NSData *data = [NSData dataWithBytes:cstr length:string.length];
//    
//    //对数据进行加密
//    NSData *result = [NSData aes128ECBEncrypt:data key:key];
//    
//    //转换为2进制字符串
//    if (result && result.length > 0) {
//        
//        Byte *datas = (Byte*)[result bytes];
//        NSMutableString *output = [NSMutableString stringWithCapacity:result.length * 2];
//        for(int i = 0; i < result.length; i++){
//            [output appendFormat:@"%02x", datas[i]];
//        }
//        return output;
//    }
//    return nil;
//    
//}
//
//+ (NSString *)aes128ECBDecrypt:(NSString *)string key:(NSString *)key {
//    
//    if (!string.length) {
//        return string;
//    }
//    if (!key.length) {
//        key = @"";
//    }
//    
//    //转换为2进制Data
//    NSMutableData *data = [NSMutableData dataWithCapacity:string.length / 2];
//    unsigned char whole_byte;
//    char byte_chars[3] = {'\0','\0','\0'};
//    int i;
//    for (i=0; i < [string length] / 2; i++) {
//        byte_chars[0] = [string characterAtIndex:i*2];
//        byte_chars[1] = [string characterAtIndex:i*2+1];
//        whole_byte = strtol(byte_chars, NULL, 16);
//        [data appendBytes:&whole_byte length:1];
//    }
//    
//    //对数据进行解密
//    NSData* result = [NSData aes128ECBDecrypt:data key:key];
//    if (result && result.length > 0) {
//        return [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
//    }
//    return nil;
//    
//}

+ (NSString *)aes128CBCEncrypt:(NSString *)string key:(NSString *)key iv:(NSString *)iv {
    
    if (!string.length) {
        return string;
    }
    if (!key.length) {
        key = @"";
    }
    if (!iv.length) {
        iv = @"";
    }
    
    const char *cstr = [string cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:string.length];
    
    //对数据进行加密
    NSData *result = [NSData aes128CBCEncrypt:data key:key iv:iv];
    
    //转换为2进制字符串
    if (result && result.length > 0) {
        Byte *datas = (Byte*)[result bytes];
        NSMutableString *output = [NSMutableString stringWithCapacity:result.length * 2];
        for(int i = 0; i < result.length; i++){
            [output appendFormat:@"%02x", datas[i]];
        }
        return output;
    }
    return nil;
    
}

+ (NSString *)aes128CBCDecrypt:(NSString *)string key:(NSString *)key iv:(NSString *)iv {
    
    if (!string.length) {
        return string;
    }
    if (!key.length) {
        key = @"";
    }
    if (!iv.length) {
        iv = @"";
    }
    
    //转换为2进制Data
    NSMutableData *data = [NSMutableData dataWithCapacity:string.length / 2];
    unsigned char whole_byte;
    char byte_chars[3] = {'\0','\0','\0'};
    int i;
    for (i=0; i < [string length] / 2; i++) {
        byte_chars[0] = [string characterAtIndex:i*2];
        byte_chars[1] = [string characterAtIndex:i*2+1];
        whole_byte = strtol(byte_chars, NULL, 16);
        [data appendBytes:&whole_byte length:1];
    }
    
    //对数据进行解密
    NSData* result = [NSData aes128CBCDecrypt:data key:key iv:iv];
    if (result && result.length > 0) {
        return [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
    }
    return nil;
    
}

@end

@implementation NSString (Base64)

+ (NSString *)encodeBase64String:(NSString *)string {
    
    if (!string.length) {
        return string;
    }
    
    NSData *encodeData = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64String = [encodeData base64EncodedStringWithOptions:0];
    return base64String;
    
}

+ (NSString *)decodeBase64String:(NSString *)base64 {
    
    if (!base64.length) {
        return base64;
    }
    
    NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:base64 options:0];
    NSString *decodedString = [[NSString alloc] initWithData:decodedData encoding:NSUTF8StringEncoding];
    return decodedString;
    
}

@end

@implementation NSString (MD5)

+ (NSString *)md5:(NSString *)string key:(NSString *)key {
    
    if (!key) {
        key = @"";
    }
    
    return [self md5:[NSString stringWithFormat:@"%@%@", key, string]];
}

+ (NSString *)md5:(NSString *)string {
    
    const char *cStr = [string UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5(cStr, (CC_LONG)strlen(cStr), digest);
    
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02X", digest[i]];
    }
    
    return result;
    
}

@end
