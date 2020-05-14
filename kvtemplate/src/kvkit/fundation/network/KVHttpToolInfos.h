//
//  KVHttpToolInfos.h
//  kvtemplate
//
//  Created by kevin on 2020/5/14.
//  Copyright © 2020 kevin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KVHttpToolInfos : NSObject
<NSCopying>

@property (assign, nonatomic) KVHttpToolMethod method;
@property (strong, nonatomic, nullable) NSDictionary *params;
@property (strong, nonatomic,  nullable) NSDictionary<NSString *, NSString *> *headers;
@property (assign, nonatomic) KVHttpToolResponseSerialization responseSerialization;
@property (assign, nonatomic) BOOL serializationToJSON;
@property (assign, nonatomic) KVHttpToolCacheMate cacheMate;
@property (strong, nonatomic, nullable) id<KVHttpToolCacheProtocol> cacheDelegate;
@property (strong, nonatomic, nullable) id<KVHttpToolBusinessProtocol> businessDelegate;
@property (copy, nonatomic, nullable) void (^ progressBlock)(NSProgress *progress);
@property (copy, nonatomic, nullable) void (^ successBlock)(id _Nullable responseObject);
@property (copy, nonatomic, nullable) void (^ failureBlock)(NSError * _Nullable error);
@property (copy, nonatomic, nullable) void (^ cacheBlock)(id _Nullable responseObject);

@end

NS_ASSUME_NONNULL_END
