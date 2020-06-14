//
//  KVHttpToolHeader.h
//  KVTableView
//
//  Created by kevin on 2020/5/13.
//  Copyright © 2020 kevin. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "KVKitHeader.h"

NS_ASSUME_NONNULL_BEGIN

/** 缓存配置 */
typedef NS_ENUM(NSInteger, KVHttpToolCacheMate) {
    KVHttpToolCacheMate_Undefine = 0,
    KVHttpToolCacheMate_Url,
    KVHttpToolCacheMate_Url_Headers,
    KVHttpToolCacheMate_Url_Params,
    KVHttpToolCacheMate_Url_Headers_Params,
};

/** 请求方法 */
typedef NS_ENUM(NSInteger, KVHttpToolMethod) {
    KVHttpTool_GET,
    KVHttpTool_POST,
};

/** 解析配置 */
typedef NS_ENUM(NSInteger, KVHttpToolResponseSerialization) {
    KVHttpToolResponseSerialization_Data,
    KVHttpToolResponseSerialization_JSON,
};

/** upload Infp */
typedef struct {
    NSData *data;
    NSString *name;
    NSString *fileName;
    NSString *mimeType;
} KVHttpToolUploadFileInfo;

/** 网络请求的数据缓存代理协议 */
@protocol KVHttpToolCacheProtocol <NSObject>

/**
 存数据
 type: 存的方式
 url: url
 headers: headers
 params: params
 data: 网络请求后的二进制结果
 */
- (void)cache:(KVHttpToolCacheMate)type url:(NSString *)url headers:(NSDictionary * _Nullable)headers params:(NSDictionary *_Nullable)params data:(NSData *)data;

/**
 取数据
 type: 取的方式
 url: url
 headers: headers
 params: params
 complete: 完成的回调，返回之前存储的二进制数据
 */
- (void)responseObjectWithCacheType:(KVHttpToolCacheMate)type url:(NSString *)url headers:(NSDictionary *_Nullable)headers params:(NSDictionary *_Nullable)params complete:(void (^) (NSData * _Nullable data))complete;

/**
 删除数据
 type: 取的方式
 url: url
 headers: headers
 params: params
 */
- (void)removeCache:(KVHttpToolCacheMate)type url:(NSString *)url headers:(NSDictionary *_Nullable)headers params:(NSDictionary *_Nullable)params;

/**
 删除所有数据
 */
- (void)removeAll;

@end

@protocol KVHttpToolBusinessProtocol <NSObject>

/**
 数据的业务校验：比如 code == xx, 才成功，否则返回error
 url: url
 responseObject: 请求结果
 */
- (NSError * _Nullable)getBusinessErrorWithUrl:(NSString *)url responseObject:(id _Nullable)responseObject;

@end

NS_ASSUME_NONNULL_END
