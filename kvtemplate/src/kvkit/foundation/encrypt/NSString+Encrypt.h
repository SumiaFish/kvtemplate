//
//  NSString+Encrypt.h
//  kvtemplate
//
//  Created by kevin on 2020/6/15.
//  Copyright © 2020 kevin. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NSData+Encrypt.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Encrypt)

//+ (NSString *)aes128ECBEncrypt:(NSString *)string key:(NSString *)key;
//
//+ (NSString *)aes128ECBDecrypt:(NSString *)string key:(NSString *)key;

+ (NSString *)aes128CBCEncrypt:(NSString *)string key:(NSString * _Nullable)key iv:(NSString * _Nullable)iv;

+ (NSString *)aes128CBCDecrypt:(NSString *)string key:(NSString * _Nullable)key iv:(NSString * _Nullable)iv;

@end

@interface NSString (Base64)

+ (NSString *)encodeBase64String:(NSString * _Nullable)string;

+ (NSString *)decodeBase64String:(NSString * _Nullable)base64;

@end

@interface NSString (MD5)

+ (NSString *)md5:(NSString *)string key:(NSString * _Nullable)key;

@end

NS_ASSUME_NONNULL_END
