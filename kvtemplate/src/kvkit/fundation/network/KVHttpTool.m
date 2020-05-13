//
//  KVHttpTool.m
//  KVTableView
//
//  Created by kevin on 2020/5/12.
//  Copyright © 2020 kevin. All rights reserved.
//

#import <objc/runtime.h>
#import <AFNetworking/AFNetworking.h>

#import "KVHttpTool.h"
#import "KVHttpTool+Business.h"
#import "KVHttpTool+MISC.h"

#import "KVHttpToolCache.h"

@interface KVHttpToolInfos : NSObject

@property (assign, nonatomic) KVHttpToolMethod method;
@property (strong, nonatomic) NSDictionary *params;
@property (strong, nonatomic) NSDictionary<NSString *, NSString *> *headers;
@property (assign, nonatomic) KVHttpToolResponseSerialization responseSerialization;
@property (assign, nonatomic) BOOL serializationToJSON;
@property (assign, nonatomic) KVHttpToolCacheMate cacheMate;
@property (strong, nonatomic) id<KVHttpToolCacheProtocol> cacheDelegate;
@property (strong, nonatomic) id<KVHttpToolBusinessProtocol> businessDelegate;
@property (copy, nonatomic) void (^ progressBlock)(NSProgress *progress);
@property (copy, nonatomic) void (^ successBlock)(id _Nullable responseObject);
@property (copy, nonatomic) void (^ failureBlock)(NSError * _Nullable error);
@property (copy, nonatomic) void (^ cacheBlock)(id _Nullable responseObject);

@end

@implementation KVHttpToolInfos

@end

@interface KVHttpTool ()

@property (strong, nonatomic) KVHttpToolInfos *info;

@property (strong, nonatomic, readwrite) NSURLSessionTask *task;
@property (copy, nonatomic, readwrite) NSString *url;

/// 请求方法： 默认 GET
@property (copy, nonatomic, readwrite) KVHttpTool* _Nullable (^ method) (KVHttpToolMethod method);

/// 请求参数：默认 nil
@property (copy, nonatomic, readwrite) KVHttpTool* _Nullable (^ params) (NSDictionary * _Nullable params);

/// 请求头：默认 KVHttpTool+Business 里的全局 headers; AF要求 headers 必须是 { string : string }
@property (copy, nonatomic, readwrite) KVHttpTool* _Nullable (^ headers) (NSDictionary<NSString *, NSString *> * _Nullable headers);

/// AFNetworking怎么解析请求结果：默认为data
@property (copy, nonatomic, readwrite) KVHttpTool* _Nullable (^ responseSerialization) (KVHttpToolResponseSerialization responseSerialization);

/// 最后要不要把请求结果转为JSON再返回：默认为YES;  如果你的返回结果明确要Data, 需要设为NO(如果不设置，会多一次转换时间，尝试转换失败后会返回原数据)；设置为NO也没法做返回的数据过滤了
@property (copy, nonatomic, readwrite) KVHttpTool* _Nullable (^ serializationToJSON) (BOOL serializationToJSON);

/// 匹配缓存策略： 默认不从缓存加载
@property (copy, nonatomic, readwrite) KVHttpTool* _Nullable (^ cacheMate) (KVHttpToolCacheMate cacheMate);

/// 缓存代理: 默认 KVHttpToolCache
@property (copy, nonatomic, readwrite) KVHttpTool* _Nullable (^ cacheDelegate) (id<KVHttpToolCacheProtocol> cacheDelegate);

/// 单独设置业务代理: 默认 KVHttpToolCache
@property (copy, nonatomic, readwrite) KVHttpTool* _Nullable (^ businessDelegate) (id<KVHttpToolBusinessProtocol> businessDelegate);

/// 请求进度：默认 nil
@property (copy, nonatomic, readwrite) KVHttpTool* _Nullable (^ progress) (void (^ _Nullable progressBlock)(NSProgress *progress));

/// 请求成功回调：默认 nil
@property (copy, nonatomic, readwrite) KVHttpTool* _Nullable (^ success) (void (^ _Nullable successBlock)(id _Nullable responseObject));

/// 请求成功失败：默认 nil
@property (copy, nonatomic, readwrite) KVHttpTool* _Nullable (^ failure) (void (^ _Nullable failureBlock)(NSError * _Nullable error));

/// 读取缓存的回调：默认 nil
@property (copy, nonatomic, readwrite) KVHttpTool* _Nullable (^ cache) (void (^ _Nullable cacheBlock)(id _Nullable responseObject));

/// 发送：必须在最后调用
@property (copy, nonatomic, readwrite) void (^ send) (void);

@end

@implementation KVHttpTool

- (void)dealloc {
    
}

+ (void)clearCache {
    [self.class.cacheDelegate removeAll];
}

+ (void)removeCache:(KVHttpToolCacheMate)type url:(NSString *)url headers:(NSDictionary *)headers params:(NSDictionary *)params {
    [self.class.cacheDelegate removeCache:type url:url headers:headers params:params];
}

+ (instancetype)request:(NSString *)url {
    return [[self.class alloc] initWithUrl:url];
}

- (instancetype)initWithUrl:(NSString *)url {
    if (self = [super init]) {
        self.url = url;
        [self commonInit];
    }
    return self;
}

/// 给默认值
- (void)commonInit {
    self.method(KVHttpTool_GET);
    self.headers(nil);
    self.params(nil);
    self.responseSerialization(KVHttpToolResponseSerialization_Data);
    self.serializationToJSON(YES);
    self.cacheMate(KVHttpToolCacheMate_Undefine);
    self.cacheDelegate([KVHttpToolCache share]);
    self.businessDelegate(nil);
    self.progress(nil);
    self.success(nil);
    self.failure(nil);
    self.cache(nil);
    //
    __weak typeof(self) ws = self;
    self.send = ^{
        [ws impSend];
    };
}

- (void)impSend {
    /// 开始发起请求
    
    NSString *url = self.url;
    
    KVHttpToolInfos *info = self.info;
    KVHttpToolMethod method = info.method;
    NSDictionary *params = info.params;
    NSDictionary *headers = info.headers;
    KVHttpToolResponseSerialization responseSerialization = info.responseSerialization;
    BOOL serializationToJSON = info.serializationToJSON;
    KVHttpToolCacheMate cacheMate = info.cacheMate;
    id<KVHttpToolCacheProtocol> cacheDelegate = info.cacheDelegate;
//    id<KVHttpToolBusinessProtocol> businessDelegate = info.businessDelegate;
    void (^ progressBlock)(NSProgress *progress) = info.progressBlock;
    void (^ successBlock)(id _Nullable responseObject) = info.successBlock;
    void (^ failureBlock)(NSError * _Nullable error) = info.failureBlock;
    void (^ cacheBlock)(id _Nullable responseObject) = info.cacheBlock;
    
    AFHTTPSessionManager *manager = [self manager];
    manager.responseSerializer = ({
        AFHTTPResponseSerializer *res = [AFHTTPResponseSerializer serializer];
        if (responseSerialization == KVHttpToolResponseSerialization_JSON) {
            res = [AFJSONResponseSerializer serializer];
        }
        res;
    });
    
    
    /// 从缓存加载数据
    void (^ loadCacheDataBlock) (void) = ^ {
        [cacheDelegate responseObjectWithCacheType:(cacheMate) url:url headers:headers params:params complete:^(NSData * _Nullable data) {
            id res = nil;
            if (data &&
                serializationToJSON) {
                NSError *jsonSerializationErr = nil;
                res = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingAllowFragments) error:&jsonSerializationErr];
                if (jsonSerializationErr) {
                    res = data;
                }
            } else {
                res = data;
            }
            //
            [self.class todoInMainQueue:^{
                cacheBlock? cacheBlock(res): nil;
            }];
        }];
    };
    
    /// 请求成功执行的任务
    void (^ successTask) (id responseObject) = ^ (id responseObject) {
        /// 打印结果
        [self log:url headers:headers params:params responseSerialization:responseSerialization responseObject:responseObject error:nil];
        /// 过滤结果
        id originalResponse = responseObject;
        [self filtterWithUrl:url responseSerialization:responseSerialization serializationToJSON:serializationToJSON responseObject:responseObject success:^(id responseObject, BOOL ignore) {
            /// 过滤成功, 回调
            [self.class todoInMainQueue:^{
                successBlock? successBlock(responseObject): nil;
            }];
            
            /// 过滤成功后尝试缓存
            if (cacheMate != KVHttpToolCacheMate_Undefine) {
                /// 做缓存
                NSData *data = nil;
                if (responseSerialization == KVHttpToolResponseSerialization_Data) {
                    data = originalResponse;
                } else {
                    data = [NSJSONSerialization dataWithJSONObject:originalResponse options:(NSJSONWritingPrettyPrinted) error:nil];
                }
                if (data) {
                    [cacheDelegate cache:(cacheMate) url:url headers:headers params:params data:data];
                }
            }
            
        } failure:^(NSError *error) {
            /// 过滤失败回调
            [self.class todoInMainQueue:^{
                failureBlock? failureBlock(error): nil;
            }];
            if (cacheMate != KVHttpToolCacheMate_Undefine) {
                loadCacheDataBlock();
            }
        }];
    };
    
    /// 请求失败执行的任务
    void (^ failureTask) (NSError *error) = ^ (NSError *error) {
        /// 打印
        [self log:url headers:headers params:params responseSerialization:responseSerialization responseObject:nil error:error];
        /// 请求失败回调
        [self.class todoInMainQueue:^{
            failureBlock? failureBlock(error): nil;
        }];
        if (cacheMate != KVHttpToolCacheMate_Undefine) {
            loadCacheDataBlock();
        }
    };
    
    /// 调用manager
    if (method == KVHttpTool_GET) {
        self.task = [manager GET:url parameters:params headers:headers progress:progressBlock success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [self.class todoInGlobalDefaultQueue:^{
                successTask(responseObject);
            }];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self.class todoInGlobalDefaultQueue:^{
                failureTask(error);
            }];
        }];
        
    } else if (method == KVHttpTool_POST) {
        self.task = [manager POST:url parameters:params headers:headers progress:progressBlock success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [self.class todoInGlobalDefaultQueue:^{
                successTask(responseObject);
            }];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self.class todoInGlobalDefaultQueue:^{
                failureTask(error);
            }];
        }];
        
    }
}

/// log 并把 responseObject 转为json
- (void)log:(NSString *)url headers:(NSDictionary *)headers params:(NSDictionary * _Nullable)params responseSerialization:(KVHttpToolResponseSerialization)responseSerialization responseObject:(id)responseObject error:(NSError *)error {
#if DEBUG
    printf("\n%s #%d: \n", __func__, __LINE__);
    printf("begin ############################################################\n");
    printf("url: %s\n", [NSString stringWithFormat:@"%@", url].UTF8String);
    printf("headers: %s\n", (headers != nil) ? [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:headers options:(NSJSONWritingPrettyPrinted) error:nil] encoding:(NSUTF8StringEncoding)].UTF8String : "null");
    printf("params: %s\n", (params != nil) ? [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:params options:(NSJSONWritingPrettyPrinted) error:nil] encoding:(NSUTF8StringEncoding)].UTF8String : "null");
    if (error) {
        printf("error: %s\n", [NSString stringWithFormat:@"%@", error].UTF8String);
    } else {
        if (responseSerialization == KVHttpToolResponseSerialization_JSON) {
            printf("responseObject: %s\n", (responseObject != nil) ? [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:responseObject options:(NSJSONWritingPrettyPrinted) error:nil] encoding:(NSUTF8StringEncoding)].UTF8String : "null");
        } else {
            NSError *jsonSerializationErr = nil;
            id json = [NSJSONSerialization JSONObjectWithData:responseObject options:(NSJSONReadingAllowFragments) error:&jsonSerializationErr];
            if (jsonSerializationErr) {
                printf("responseObject is not json: %s\n", [NSString stringWithFormat:@"%@", jsonSerializationErr].UTF8String);
                printf("responseObject: %s\n", (responseObject != nil) ? [[NSString alloc] initWithData:responseObject encoding:(NSUTF8StringEncoding)].UTF8String : "null");
            } else {
                printf("responseObject: %s\n", [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:json options:(NSJSONWritingPrettyPrinted) error:nil] encoding:(NSUTF8StringEncoding)].UTF8String);
            }
        }
    }
    printf("end ############################################################\n \n");
#endif
}

- (void)filtterWithUrl:(NSString *)url responseSerialization:(KVHttpToolResponseSerialization)responseSerialization serializationToJSON:(BOOL)serializationToJSON  responseObject:(id)responseObject success:(void (^) (id responseObject, BOOL ignore))success failure:(void (^) (NSError *error))failure {
    
    id res = nil;
    BOOL ignore = NO;
    if (serializationToJSON) {
        if (responseSerialization == KVHttpToolResponseSerialization_JSON) {
            res = responseObject;
        } else {
            /// 尝试转为JSON
            NSError *jsonSerializationErr = nil;
            res = [NSJSONSerialization JSONObjectWithData:responseObject options:(NSJSONReadingAllowFragments) error:&jsonSerializationErr];
            if (jsonSerializationErr) {
                /// 没转成功不做过滤
                ignore = YES;
                res = responseObject;
#if DEBUG
                KVHttpToolLog(@"jsonSerializationErr: %@", jsonSerializationErr);
#endif
            }
        }
    } else {
        /// 不做过滤
        ignore = YES;
        res = responseObject;
        
    }
    
    if (ignore == NO) {
        NSError *error = [self.info.businessDelegate getBusinessErrorWithUrl:url responseObject:res];
        if (error) {
            /// 有业务错误
            failure? failure(error): nil;
        } else {
            /// 业务通过
            success? success(res, ignore): nil;
        }
    } else {
        /// 已经忽略了过滤，直接返回吧
        success? success(res, ignore): nil;
    }
}

- (KVHttpToolInfos *)info {
    if (!_info) {
        _info = [KVHttpToolInfos new];
    }
    return _info;
}

- (AFHTTPSessionManager *)manager {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    return manager;
}

- (KVHttpTool * _Nullable (^)(KVHttpToolMethod))method {
    if (!_method) {
        __weak typeof(self) ws = self;
        _method = ^KVHttpTool * _Nullable(KVHttpToolMethod obj) {
            ws.info.method = obj;
            return ws;
        };
    }
    return _method;
}

- (KVHttpTool * _Nullable (^)(NSDictionary * _Nullable))params {
    if (!_params) {
        __weak typeof(self) ws = self;
        _params = ^KVHttpTool * _Nonnull(NSDictionary * _Nullable obj) {
            ws.info.params = obj;
            return ws;
        };
    }
    return _params;
}

- (KVHttpTool * _Nullable (^)(NSDictionary<NSString *,NSString *> * _Nullable))headers {
    if (!_headers) {
        __weak typeof(self) ws = self;
        _headers = ^KVHttpTool * _Nonnull(NSDictionary<NSString *,NSString *> * _Nullable obj) {
            ws.info.headers = obj;
            return ws;
        };
    }
    return _headers;
}

- (KVHttpTool * _Nullable (^)(KVHttpToolResponseSerialization))responseSerialization {
    if (!_responseSerialization) {
        __weak typeof(self) ws = self;
        _responseSerialization = ^KVHttpTool * _Nullable(KVHttpToolResponseSerialization obj) {
            ws.info.responseSerialization = obj;
            return ws;
        };
    }
    return _responseSerialization;
}

- (KVHttpTool * _Nullable (^)(BOOL))serializationToJSON {
    if (!_serializationToJSON) {
        __weak typeof(self) ws = self;
        _serializationToJSON = ^KVHttpTool * _Nullable(BOOL obj) {
            ws.info.serializationToJSON = obj;
            return ws;
        };
    }
    return _serializationToJSON;
}

- (KVHttpTool * _Nullable (^)(KVHttpToolCacheMate))cacheMate {
    if (!_cacheMate) {
        __weak typeof(self) ws = self;
        _cacheMate = ^KVHttpTool * _Nullable(KVHttpToolCacheMate obj) {
            ws.info.cacheMate = obj;
            return ws;
        };
    }
    return _cacheMate;
}

- (KVHttpTool * _Nullable (^)(id<KVHttpToolCacheProtocol> _Nonnull))cacheDelegate {
    if (!_cacheDelegate) {
        __weak typeof(self) ws = self;
        _cacheDelegate = ^ (id<KVHttpToolCacheProtocol>  _Nonnull obj) {
            ws.info.cacheDelegate = obj;
            return ws;
        };
    }
    return _cacheDelegate;
}

- (KVHttpTool * _Nullable (^)(id<KVHttpToolBusinessProtocol> _Nonnull))businessDelegate {
    if (!_businessDelegate) {
        __weak typeof(self) ws = self;
        _businessDelegate = ^ (id<KVHttpToolBusinessProtocol>  _Nonnull obj) {
            ws.info.businessDelegate = obj;
            return ws;
        };
    }
    return _businessDelegate;
}

- (KVHttpTool * _Nullable (^)(void (^ _Nonnull)(NSProgress * _Nonnull)))progress {
    if (!_progress) {
        __weak typeof(self) ws = self;
        _progress = ^KVHttpTool * _Nullable(void (^ _Nonnull obj)(NSProgress * _Nonnull progress)) {
            ws.info.progressBlock = obj;
            return ws;
        };
    }
    return _progress;
}

- (KVHttpTool * _Nullable (^)(void (^ _Nonnull)(id _Nullable)))success {
    if (!_success) {
        __weak typeof(self) ws = self;
        _success = ^KVHttpTool * _Nullable(void (^ _Nonnull obj)(id responseObject)) {
            ws.info.successBlock = obj;
            return ws;
        };
    }
    return _success;
}

- (KVHttpTool * _Nullable (^)(void (^ _Nonnull)(NSError * _Nullable)))failure {
    if (!_failure) {
        __weak typeof(self) ws = self;
        _failure = ^KVHttpTool * _Nullable(void (^ _Nonnull obj)(NSError * error)) {
            ws.info.failureBlock = obj;
            return ws;
        };
    }
    return _failure;
}

- (KVHttpTool * _Nullable (^)(void (^ _Nonnull)(id _Nullable)))cache {
    if (!_cache) {
        __weak typeof(self) ws = self;
        _cache = ^KVHttpTool * _Nullable(void (^ _Nonnull obj)(id responseObject)) {
            ws.info.cacheBlock = obj;
            return ws;
        };
    }
    return _cache;
}

@end

@interface KVHttpUploadTool ()

@property (copy, nonatomic, readwrite) NSString *filePath;

@end

@implementation KVHttpUploadTool

+ (instancetype)request:(NSString *)url filePath:(NSString *)filePath {
    KVHttpUploadTool *tool = [super request:url];
    tool.filePath = filePath;
    return tool;
}

- (void)impSend {
    /// 开始发起请求
    
    NSString *url = self.url;
    NSString *filePath = self.filePath;

    KVHttpToolInfos *info = self.info;
//    KVHttpToolMethod method = KVHttpTool_POST; //info.method; // 上传只能POST
    NSDictionary *params = info.params;
    NSDictionary *headers = info.headers;
    KVHttpToolResponseSerialization responseSerialization = info.responseSerialization;
    BOOL serializationToJSON = info.serializationToJSON;
    void (^ progressBlock)(NSProgress *progress) = info.progressBlock;
    void (^ successBlock)(id _Nullable responseObject) = info.successBlock;
    void (^ failureBlock)(NSError * _Nullable error) = info.failureBlock;
    
    /// 检测文件是否存在
    BOOL isDirectory = NO;
    BOOL isExecutableFileAtPath = [[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&isDirectory];
    if (!isExecutableFileAtPath) {
        NSError *error = [NSError errorWithDomain:url code:-1 userInfo:@{NSLocalizedDescriptionKey: @"文件不存在"}];
        failureBlock? failureBlock(error): nil;
        return;
    }
    
    /// 拷贝到一个新目录
    
    
    AFHTTPSessionManager *manager = [self manager];
    manager.responseSerializer = ({
        AFHTTPResponseSerializer *res = [AFHTTPResponseSerializer serializer];
        if (responseSerialization == KVHttpToolResponseSerialization_JSON) {
            res = [AFJSONResponseSerializer serializer];
        }
        res;
    });
    
    self.task = [manager POST:url parameters:params headers:headers progress:progressBlock success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [self log:url headers:headers params:params responseSerialization:responseSerialization responseObject:responseObject error:nil];
        
        [self filtterWithUrl:url responseSerialization:responseSerialization serializationToJSON:serializationToJSON responseObject:responseObject success:^(id responseObject, BOOL ignore) {
            successBlock? successBlock(responseObject): nil;
        } failure:^(NSError *error) {
            failureBlock? failureBlock(error): nil;
        }];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [self log:url headers:headers params:params responseSerialization:responseSerialization responseObject:nil error:error];
        
    }];
}

+ (NSString *)uploadDirectory {
    return @"";
}

@end
