//
//  NSData+Encrypt.h
//  kvtemplate
//
//  Created by kevin on 2020/6/15.
//  Copyright © 2020 kevin. All rights reserved.
//

/**
 iOS加解密
 https://www.jianshu.com/p/a455957889ff
 https://www.jianshu.com/p/93466b31f675
 https://www.jianshu.com/p/0f941a79ed99
 */

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSData (Encrypt)

//+ (NSData *)aes128ECBEncrypt:(NSData *)data key:(NSString *)key;
//
//+ (NSData *)aes128ECBDecrypt:(NSData *)data key:(NSString *)key;

+ (NSData *)aes128CBCEncrypt:(NSData *)data key:(NSString * _Nullable)key iv:(NSString * _Nullable)iv;

+ (NSData *)aes128CBCDecrypt:(NSData *)data key:(NSString * _Nullable)key iv:(NSString * _Nullable)iv;

@end

NS_ASSUME_NONNULL_END
