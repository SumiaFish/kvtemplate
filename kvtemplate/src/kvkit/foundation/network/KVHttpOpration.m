//
//  KVHttpOpration.m
//  kvtemplate
//
//  Created by kevin on 2020/5/14.
//  Copyright © 2020 kevin. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

#import "KVHttpOpration.h"

#import "NSObject+WeakObserve.h"

#import "KVHttpTool+MISC.h"

typedef struct {
    BOOL isIgnore;
    id responseObject;
    NSError *error;
}KVHttpOprationFilterResult;

@interface KVHttpOpration ()

@property (strong, nonatomic, readwrite) NSURLSessionTask *task;

@end

@implementation KVHttpOpration
{
    NSProgress *_progress;
    id _responseObject;
    NSError *_error;
    id _loaddingCacheFlag;
    
    dispatch_semaphore_t _semaphore;
}

- (void)dealloc {
#if DEBUG
    NSLog(@"%@ dealloc~", NSStringFromClass(self.class));
#endif
}

- (instancetype)initWithUrl:(NSString *)url info:(KVHttpToolInfos *)info {
    if (self = [super init]) {
        _url = url;
        _info = [info copy];
        _semaphore = dispatch_semaphore_create(1);
    }
    return self;
}

#pragma mark - override

- (void)todo {
    // 开始发起请求

    NSString *url = self.url;
    
    KVHttpToolInfos *info = self.info;
    KVHttpToolMethod method = info.method;
    NSDictionary *params = info.params;
    NSDictionary *headers = info.headers;
    KVHttpToolResponseSerialization responseSerialization = info.responseSerialization;
    
    AFHTTPSessionManager *manager = [self manager];
    manager.responseSerializer = ({
        AFHTTPResponseSerializer *res = [AFHTTPResponseSerializer serializer];
        if (responseSerialization == KVHttpToolResponseSerialization_JSON) {
            res = [AFJSONResponseSerializer serializer];
        }
        res;
    });
    
    // 调用manager
    if (method == KVHttpTool_GET) {
        self.task = [manager GET:url parameters:params headers:headers progress:^(NSProgress * _Nonnull downloadProgress) {
            [self sendProgressTask:downloadProgress];
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [KVHttpTool todoInGlobalDefaultQueue:^{
                //
                [self logTask:responseObject error:nil];
                //
                KVHttpOprationFilterResult result = {};
                [self filterTask:responseObject result:&result];
                NSError *error = result.error;
                id filtterResponseObject = result.responseObject;
                if (error) {
                    [self sendFailedTask:error];
                    //
                    [self sendLoadCacheDataSuccessTask];
                    return;
                }
                //
                [self sendSuccessTask:filtterResponseObject];
            }];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [KVHttpTool todoInGlobalDefaultQueue:^{
                //
                [self logTask:nil error:error];
                //
                [self sendFailedTask:error];
                //
                [self sendLoadCacheDataSuccessTask];
            }];
        }];
        
    } else if (method == KVHttpTool_POST) {
        self.task = [manager POST:url parameters:params headers:headers progress:^(NSProgress * _Nonnull downloadProgress) {
            [self sendProgressTask:downloadProgress];
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [KVHttpTool todoInGlobalDefaultQueue:^{
                //
                [self logTask:responseObject error:nil];
                //
                KVHttpOprationFilterResult result = {};
                [self filterTask:responseObject result:&result];
                NSError *error = result.error;
                id filtterResponseObject = result.responseObject;
                if (error) {
                    [self sendFailedTask:error];
                    //
                    [self sendLoadCacheDataSuccessTask];
                    return;
                }
                //
                [self sendSuccessTask:filtterResponseObject];
            }];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [KVHttpTool todoInGlobalDefaultQueue:^{
                //
                [self logTask:nil error:error];
                //
                [self sendFailedTask:error];
                //
                [self sendLoadCacheDataSuccessTask];
            }];
        }];
        
    }
    
    if (self.task) {
        [self.task kv_addWeakObserve:self keyPath:NSStringFromSelector(@selector(state)) options:(NSKeyValueObservingOptionNew) context:nil];
    }
}

- (void)kv_receiveWeakObserveValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([object isKindOfClass:NSURLSessionTask.class] &&
        object == self.task) {
        if (self.task.state == NSURLSessionTaskStateCanceling) {
            [self cancel];
        } else if (self.task.state == NSURLSessionTaskStateSuspended) {
            [self pause];
        } else if (self.task.state == NSURLSessionTaskStateRunning) {
            [self resume];
        }
    }
}

- (void)onPause {
    
}

- (void)onResume {
    if (_progress) {
        [self sendProgressTask:_progress];
        return;
    }
    if (_responseObject) {
        [self sendSuccessTask:_responseObject];
        return;
    }
    if (_error) {
        [self sendFailedTask:_error];
        return;
    }
    if (_loaddingCacheFlag) {
        [self sendLoadCacheDataSuccessTask];
        return;
    }
}

- (void)onCancel {
    KVKitLog(@"已取消");
}

- (BOOL)isAsynchronous {
    return NO;
}

#pragma mark - private

// 发送进度回调
- (void)sendProgressTask:(NSProgress *)progress {
    if (!self.info.progressBlock) {
        return;
    }
    
    // 操作前检查一遍有没有被取消 或 暂停
    if (self.isFinished) {
        [self complete];
        return;
    }
    dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
    if (self.isPause) {
        _progress = progress;
        dispatch_semaphore_signal(self->_semaphore);
        return;
    }

    _progress = progress;
    [KVHttpTool todoInMainQueue:^{
        self.info.progressBlock? self.info.progressBlock(progress): nil;
        self->_progress = nil;
        dispatch_semaphore_signal(self->_semaphore);
    }];
}

// 过滤数据
- (void)filterTask:(id)responseObject result:(KVHttpOprationFilterResult *)result {
    NSString *url = self.url;
    KVHttpToolInfos *info = self.info;
    KVHttpToolResponseSerialization responseSerialization = info.responseSerialization;
    BOOL serializationToJSON = info.serializationToJSON;
    id<KVHttpToolBusinessProtocol> business = info.businessDelegate;
    
    [self filter:business url:url responseSerialization:responseSerialization serializationToJSON:serializationToJSON responseObject:responseObject result:result];
}

// 把数据加到缓存
- (void)cacheTask:(id)responseObject {
    id originalResponse = responseObject;
    
    NSString *url = self.url;
    KVHttpToolInfos *info = self.info;
    NSDictionary *params = info.params;
    NSDictionary *headers = info.headers;
    KVHttpToolResponseSerialization responseSerialization = info.responseSerialization;
    KVHttpToolCacheMate cacheMate = info.cacheMate;
    id<KVHttpToolCacheProtocol> cacheDelegate = info.cacheDelegate;
    
    if (cacheMate != KVHttpToolCacheMate_Undefine) {
        // 做缓存
        NSData *data = nil;
        if (responseSerialization == KVHttpToolResponseSerialization_Data) {
            data = originalResponse;
        } else {
            data = originalResponse? [NSJSONSerialization dataWithJSONObject:originalResponse options:(NSJSONWritingPrettyPrinted) error:nil]: nil;
        }
        if (data) {
            [cacheDelegate cache:(cacheMate) url:url headers:headers params:params data:data];
        }
    }
}

// 发送成功的回调
- (void)sendSuccessTask:(id)responseObject {
    if (!self.info.successBlock) {
        return;
    }
    
    if (self.isFinished) {
        [self complete];
        return;
    }
    dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
    if (self.isPause) {
        _responseObject = responseObject;
        dispatch_semaphore_signal(self->_semaphore);
        return;
    }
    
    _responseObject = responseObject;
    [KVHttpTool todoInMainQueue:^{
        self.info.successBlock? self.info.successBlock(responseObject): nil;
        self->_responseObject = nil;
        [self complete];
        dispatch_semaphore_signal(self->_semaphore);
    }];
}

// 发送从缓存获取数据成功的回调
- (void)sendLoadCacheDataSuccessTask {
    if (!self.info.cacheBlock ||
        self.info.cacheMate == KVHttpToolCacheMate_Undefine) {
        return;
    }
    
    if (self.isFinished) {
        [self complete];
        return;
    }
    dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
    if (self.isPause) {
        _loaddingCacheFlag = NSObject.new;
        dispatch_semaphore_signal(self->_semaphore);
        return;
    }
       
    _loaddingCacheFlag = NSObject.new;
    
    NSString *url = self.url;
    KVHttpToolInfos *info = self.info;
    NSDictionary *params = info.params;
    NSDictionary *headers = info.headers;
    BOOL serializationToJSON = info.serializationToJSON;
    KVHttpToolCacheMate cacheMate = info.cacheMate;
    id<KVHttpToolCacheProtocol> cacheDelegate = info.cacheDelegate;
    
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
        [KVHttpTool todoInMainQueue:^{
            self.info.cacheBlock? self.info.cacheBlock(res): nil;
            self->_loaddingCacheFlag = nil;
            [self complete];
            dispatch_semaphore_signal(self->_semaphore);
        }];
    }];
}

// 发送失败的回调
- (void)sendFailedTask:(NSError *)error {
    if (!self.info.failureBlock) {
        return;
    }
    
    if (self.isFinished) {
        [self complete];
        return;
    }
    dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
    if (self.isPause) {
        _error = error;
        dispatch_semaphore_signal(self->_semaphore);
        return;
    }
    
    _error = error;
    // 请求失败回调
    [KVHttpTool todoInMainQueue:^{
        self.info.failureBlock? self.info.failureBlock(error): nil;
        self->_error = nil;
        [self complete];
        dispatch_semaphore_signal(self->_semaphore);
    }];
}

- (void)logTask:(id)responseObject error:(NSError *)error {
    // 打印结果(与取消无关)
    NSString *url = self.url;
    KVHttpToolInfos *info = self.info;
    NSDictionary *params = info.params;
    NSDictionary *headers = info.headers;
    KVHttpToolResponseSerialization responseSerialization = info.responseSerialization;
    
    [self log:url headers:headers params:params responseSerialization:responseSerialization responseObject:responseObject error:error];
}


#pragma mark - 纯函数

// log
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
            id json = (responseObject != nil) ? [NSJSONSerialization JSONObjectWithData:responseObject options:(NSJSONReadingAllowFragments) error:&jsonSerializationErr]: nil;
            if (jsonSerializationErr) {
                printf("responseObject is not json: %s\n", [NSString stringWithFormat:@"%@", jsonSerializationErr].UTF8String);
                printf("responseObject: %s\n", (responseObject != nil) ? [[NSString alloc] initWithData:responseObject encoding:(NSUTF8StringEncoding)].UTF8String : "null");
            } else {
                printf("responseObject: %s\n", (json != nil) ? [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:json options:(NSJSONWritingPrettyPrinted) error:nil] encoding:(NSUTF8StringEncoding)].UTF8String : "null");
            }
        }
    }
    printf("end ############################################################\n \n");
#endif
}

- (void)filter:(id<KVHttpToolBusinessProtocol>)businessDelegate url:(NSString *)url responseSerialization:(KVHttpToolResponseSerialization)responseSerialization serializationToJSON:(BOOL)serializationToJSON responseObject:(id)responseObject result:(KVHttpOprationFilterResult *)result  {
    
    id res = nil;
    BOOL ignore = NO;
    if (serializationToJSON) {
        if (responseSerialization == KVHttpToolResponseSerialization_JSON) {
            res = responseObject;
        } else {
            // 尝试转为JSON
            NSError *jsonSerializationErr = nil;
            res = responseObject? [NSJSONSerialization JSONObjectWithData:responseObject options:(NSJSONReadingAllowFragments) error:&jsonSerializationErr]: nil;
            if (jsonSerializationErr) {
                // 没转成功不做过滤
                ignore = YES;
                res = responseObject;
#if DEBUG
                KVKitLog(@"jsonSerializationErr: %@", jsonSerializationErr);
#endif
            }
        }
    } else {
        // 不做过滤
        ignore = YES;
        res = responseObject;
        
    }
    
    if (ignore == NO) {
        NSError *error = [businessDelegate getBusinessErrorWithUrl:url responseObject:res];
        if (error) {
            // 有业务错误
            result->error = error;
            result->responseObject = nil;
            result->isIgnore = ignore;
        } else {
            // 业务通过
            result->error = nil;
            result->responseObject = res;
            result->isIgnore = ignore;
        }
    } else {
        // 已经忽略了过滤，直接返回吧
        result->error = nil;
        result->responseObject = res;
        result->isIgnore = ignore;
    }
}

#pragma mark -

- (AFHTTPSessionManager *)manager {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    return manager;
}

@end

@implementation KVHttpDownloadOpration

- (void)todo {
    // 开始发起请求

    NSString *url = self.url;
    
    KVHttpToolInfos *info = self.info;
    KVHttpToolMethod method = info.method;
    NSDictionary *params = info.params;
    NSDictionary *headers = info.headers;
    KVHttpToolResponseSerialization responseSerialization = info.responseSerialization;
    
    AFHTTPSessionManager *manager = [self manager];
    manager.responseSerializer = ({
        AFHTTPResponseSerializer *res = [AFHTTPResponseSerializer serializer];
        if (responseSerialization == KVHttpToolResponseSerialization_JSON) {
            res = [AFJSONResponseSerializer serializer];
        }
        res;
    });
    
    NSString *methodString = method == KVHttpTool_GET? @"GET": @"POST";
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    req.HTTPMethod = methodString;
    
    [headers enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:NSString.class]) {
            [req setValue:key forHTTPHeaderField:obj];
        }
    }];
    
    NSData *HTTPBodyData = nil;
    if (params) {
        HTTPBodyData = [NSJSONSerialization dataWithJSONObject:params options:(NSJSONWritingPrettyPrinted) error:nil];
    }
    req.HTTPBody = HTTPBodyData;
    
    self.task = [manager downloadTaskWithRequest:req progress:^(NSProgress * _Nonnull downloadProgress) {
        [self sendProgressTask:downloadProgress];
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        self->_fileURL = targetPath;
        return targetPath;
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if (error) {
            [KVHttpTool todoInGlobalDefaultQueue:^{
                //
                [self logTask:nil error:error];
                //
                [self sendFailedTask:error];
            }];
            return;
        }
        
        [KVHttpTool todoInGlobalDefaultQueue:^{
            //
            [self logTask:nil error:nil];
            //
            [self sendSuccessTask:self->_fileURL];
        }];
    }];
    
    if (self.task) {
        [self.task kv_addWeakObserve:self keyPath:NSStringFromSelector(@selector(state)) options:(NSKeyValueObservingOptionNew) context:nil];
    }
}

@end
