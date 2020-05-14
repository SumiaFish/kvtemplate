//
//  KVHttpTool.h
//  KVTableView
//
//  Created by kevin on 2020/5/12.
//  Copyright © 2020 kevin. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "KVHttpToolHeader.h"
#import "KVHttpToolCache.h"

NS_ASSUME_NONNULL_BEGIN

/// 网络请求类
@interface KVHttpTool : NSObject

/// 外界可以通过task 控制 暂停/取消 操作
@property (strong, nonatomic, readonly) NSURLSessionTask *task;

/// 请求的url
@property (copy, nonatomic, readonly) NSString *url;

/// 请求方法： 默认 GET
@property (copy, nonatomic, readonly) KVHttpTool* _Nullable (^ method) (KVHttpToolMethod method);

/// 请求参数：默认 nil
@property (copy, nonatomic, readonly) KVHttpTool* _Nullable (^ params) (NSDictionary * _Nullable params);

/// 请求头：默认 KVHttpTool+Business 里的全局 headers; AF要求 headers 必须是 { string : string }
@property (copy, nonatomic, readonly) KVHttpTool* _Nullable (^ headers) (NSDictionary<NSString *, NSString *> * _Nullable headers);

/// AFNetworking怎么解析请求结果：默认为data
@property (copy, nonatomic, readonly) KVHttpTool* _Nullable (^ responseSerialization) (KVHttpToolResponseSerialization responseSerialization);

/// 最后要不要把请求结果转为JSON再返回：默认为YES;  如果你的返回结果明确要Data, 需要设为NO(如果不设置，会多一次转换时间，尝试转换失败后会返回原数据)；设置为NO也没法做返回的数据过滤了
@property (copy, nonatomic, readonly) KVHttpTool* _Nullable (^ serializationToJSON) (BOOL serializationToJSON);

/// 匹配缓存策略： 默认不从缓存加载
@property (copy, nonatomic, readonly) KVHttpTool* _Nullable (^ cacheMate) (KVHttpToolCacheMate cacheMate);

/// 单独设置缓存代理: 默认 KVHttpToolCache
@property (copy, nonatomic, readonly) KVHttpTool* _Nullable (^ cacheDelegate) (id<KVHttpToolCacheProtocol> _Nullable cacheDelegate);

/// 单独设置业务代理: 默认 nil
@property (copy, nonatomic, readonly) KVHttpTool* _Nullable (^ businessDelegate) (id<KVHttpToolBusinessProtocol> _Nullable businessDelegate);

/// 请求进度：默认 nil
@property (copy, nonatomic, readonly) KVHttpTool* _Nullable (^ progress) (void (^ _Nullable progressBlock)(NSProgress *progress));

/// 请求成功回调：默认 nil
@property (copy, nonatomic, readonly) KVHttpTool* _Nullable (^ success) (void (^ _Nullable successBlock)(id _Nullable responseObject));

/// 请求成功失败：默认 nil
@property (copy, nonatomic, readonly) KVHttpTool* _Nullable (^ failure) (void (^ _Nullable failureBlock)(NSError * _Nullable error));

/// 读取缓存的回调：默认 nil
@property (copy, nonatomic, readonly) KVHttpTool* _Nullable (^ cache) (void (^ _Nullable cacheBlock)(id _Nullable responseObject));

/// 发送：必须在最后调用
@property (copy, nonatomic, readonly) void (^ send) (void);

+ (instancetype)request:(NSString *)url;

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

@end

/// 上传任务
@interface KVHttpTool (Upload)

@property (copy, nonatomic, readonly, nullable) NSString *filePath;

//+ (instancetype)request:(NSString *)url __attribute__((unavailable("请使用upload:filePath")));

+ (instancetype)upload:(NSString *)url filePath:(NSString *)filePath;

@end

/// 下载任务
//@interface KVHttpTool (Download)
//
///// 请求成功回调：默认 nil
//@property (copy, nonatomic, readonly) KVHttpTool* _Nullable (^ success) (void (^ _Nullable successBlock)(NSURL * _Nullable fileURL));
//
//+ (instancetype)download:(NSString *)url;
//
//@end

NS_ASSUME_NONNULL_END
