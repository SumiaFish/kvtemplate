//
//  KVHttpToolHeader.h
//  KVTableView
//
//  Created by kevin on 2020/5/13.
//  Copyright © 2020 kevin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#ifdef DEBUG
#define KVHttpToolLog(format,...) { \
printf("\n%s #%d: \n", __func__, __LINE__); \
printf("%s\n", [NSString stringWithFormat:(format), ##__VA_ARGS__].UTF8String); \
NSLog(@"\n\n"); \
}
#else
#define KVHttpToolLog(...)
#endif

typedef NS_ENUM(NSInteger, KVHttpToolCacheMate) {
    KVHttpToolCacheMate_Undefine = 0,
    KVHttpToolCacheMate_Url,
    KVHttpToolCacheMate_Url_Headers,
    KVHttpToolCacheMate_Url_Params,
    KVHttpToolCacheMate_Url_Headers_Params,
};

typedef NS_ENUM(NSInteger, KVHttpToolMethod) {
    KVHttpTool_GET,
    KVHttpTool_POST,
};

typedef NS_ENUM(NSInteger, KVHttpToolResponseSerialization) {
    KVHttpToolResponseSerialization_Data,
    KVHttpToolResponseSerialization_JSON,
};

typedef struct {
    NSData *data;
    NSString *name;
    NSString *fileName;
    NSString *mimeType;
} KVHttpToolUploadFileInfo;

/// 请求的数据缓存代理
@protocol KVHttpToolCacheProtocol <NSObject>

- (void)cache:(KVHttpToolCacheMate)type url:(NSString *)url headers:(NSDictionary * _Nullable)headers params:(NSDictionary *_Nullable)params data:(NSData *)data;

- (void)responseObjectWithCacheType:(KVHttpToolCacheMate)type url:(NSString *)url headers:(NSDictionary *_Nullable)headers params:(NSDictionary *_Nullable)params complete:(void (^) (NSData * _Nullable data))complete;

- (void)removeCache:(KVHttpToolCacheMate)type url:(NSString *)url headers:(NSDictionary *_Nullable)headers params:(NSDictionary *_Nullable)params;

- (void)removeAll;

@end

@protocol KVHttpToolBusinessProtocol <NSObject>

/// 这里做业务规则判断, 传到这里的 responseObject 都是 JSON类型
- (NSError * _Nullable)getBusinessErrorWithUrl:(NSString *)url responseObject:(id _Nullable)responseObject;

@end

NS_ASSUME_NONNULL_END
