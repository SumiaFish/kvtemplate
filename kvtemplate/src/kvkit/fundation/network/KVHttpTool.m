//
//  KVHttpTool.m
//  KVTableView
//
//  Created by kevin on 2020/5/12.
//  Copyright © 2020 kevin. All rights reserved.
//

#import <objc/runtime.h>

#import "NSObject+WeakObserve.h"

#import "KVHttpTool.h"
#import "KVHttpTool+Business.h"
#import "KVHttpTool+MISC.h"

#import "KVHttpToolCache.h"

#import "KVHttpOpration.h"

@interface KVHttpTool ()

@property (strong, nonatomic, readwrite) KVHttpToolInfos *info;
/// 最新的 task
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
{
    dispatch_semaphore_t _semaphore;
    NSOperationQueue *_queue;
    BOOL _isLocked;
}

- (void)dealloc {
    KVHttpToolLog(@"%@ dealloc~", NSStringFromClass(self.class));
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
    _semaphore = dispatch_semaphore_create(1);
    _queue = [[NSOperationQueue alloc] init];
    _queue.maxConcurrentOperationCount = 1;
    self.info = [KVHttpToolInfos new];
    //
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
        __strong typeof(ws) ss = ws;
        [ss.class todoInGlobalDefaultQueue:^{
            [ss impSend];
        }];
    };
}

- (void)lock {
    dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
    _isLocked = YES;
    KVHttpToolLog(@"===lock");
}

- (void)unlock {
    dispatch_semaphore_signal(_semaphore);
    _isLocked = NO;
    KVHttpToolLog(@"===unlock");
}

- (BOOL)isLocked {
    return _isLocked;
}

- (void)impSend {
    [self lock];
    // 默认只允许同时一个在请求
    if (_queue.operations.count) {
        KVHttpToolLog(@"有任务正在进行中，若要开始新的任务，先取消");
        [self unlock];
        return;
    }
    
    KVHttpOpration *op = [[KVHttpOpration alloc] initWithUrl:self.url info:self.info];
    [_queue addOperation:op];
    _task = op.task;
    [self unlock];
}

- (void)cancelAll {
    [self lock];
    [_queue cancelAllOperations];
    [self unlock];
}

- (void)pauseAll {
    [self lock];
    [_queue.operations enumerateObjectsUsingBlock:^(__kindof KVHttpOpration * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj pause];
    }];
    [self unlock];
}

- (NSURLSessionTask *)task {
    return _task;
}

- (NSOperationQueue *)queue {
    return _queue;
}

- (KVHttpTool * _Nullable (^)(KVHttpToolMethod))method {
    if (!_method) {
        __weak typeof(self) ws = self;
        _method = ^KVHttpTool * _Nullable(KVHttpToolMethod obj) {
            [ws lock];
            ws.info.method = obj;
            [ws unlock];
            return ws;
        };
    }
    return _method;
}

- (KVHttpTool * _Nullable (^)(NSDictionary * _Nullable))params {
    if (!_params) {
        __weak typeof(self) ws = self;
        _params = ^KVHttpTool * _Nonnull(NSDictionary * _Nullable obj) {
            [ws lock];
            ws.info.params = obj;
            [ws unlock];
            return ws;
        };
    }
    return _params;
}

- (KVHttpTool * _Nullable (^)(NSDictionary<NSString *,NSString *> * _Nullable))headers {
    if (!_headers) {
        __weak typeof(self) ws = self;
        _headers = ^KVHttpTool * _Nonnull(NSDictionary<NSString *,NSString *> * _Nullable obj) {
            [ws lock];
            ws.info.headers = obj;
            [ws unlock];
            return ws;
        };
    }
    return _headers;
}

- (KVHttpTool * _Nullable (^)(KVHttpToolResponseSerialization))responseSerialization {
    if (!_responseSerialization) {
        __weak typeof(self) ws = self;
        _responseSerialization = ^KVHttpTool * _Nullable(KVHttpToolResponseSerialization obj) {
            [ws lock];
            ws.info.responseSerialization = obj;
            [ws unlock];
            return ws;
        };
    }
    return _responseSerialization;
}

- (KVHttpTool * _Nullable (^)(BOOL))serializationToJSON {
    if (!_serializationToJSON) {
        __weak typeof(self) ws = self;
        _serializationToJSON = ^KVHttpTool * _Nullable(BOOL obj) {
            [ws lock];
            ws.info.serializationToJSON = obj;
            [ws unlock];
            return ws;
        };
    }
    return _serializationToJSON;
}

- (KVHttpTool * _Nullable (^)(KVHttpToolCacheMate))cacheMate {
    if (!_cacheMate) {
        __weak typeof(self) ws = self;
        _cacheMate = ^KVHttpTool * _Nullable(KVHttpToolCacheMate obj) {
            [ws lock];
            ws.info.cacheMate = obj;
            [ws unlock];
            return ws;
        };
    }
    return _cacheMate;
}

- (KVHttpTool * _Nullable (^)(id<KVHttpToolCacheProtocol> _Nullable))cacheDelegate {
    if (!_cacheDelegate) {
        __weak typeof(self) ws = self;
        _cacheDelegate = ^ (id<KVHttpToolCacheProtocol>  _Nullable obj) {
            [ws lock];
            ws.info.cacheDelegate = obj;
            [ws unlock];
            return ws;
        };
    }
    return _cacheDelegate;
}

- (KVHttpTool * _Nullable (^)(id<KVHttpToolBusinessProtocol> _Nullable))businessDelegate {
    if (!_businessDelegate) {
        __weak typeof(self) ws = self;
        _businessDelegate = ^ (id<KVHttpToolBusinessProtocol>  _Nullable obj) {
            [ws lock];
            ws.info.businessDelegate = obj;
            [ws unlock];
            return ws;
        };
    }
    return _businessDelegate;
}

- (KVHttpTool * _Nullable (^)(void (^ _Nullable)(NSProgress * _Nullable)))progress {
    if (!_progress) {
        __weak typeof(self) ws = self;
        _progress = ^KVHttpTool * _Nullable(void (^ _Nullable obj)(NSProgress * _Nonnull progress)) {
            [ws lock];
            ws.info.progressBlock = obj;
            [ws unlock];
            return ws;
        };
    }
    return _progress;
}

- (KVHttpTool * _Nullable (^)(void (^ _Nullable)(id _Nullable)))success {
    if (!_success) {
        __weak typeof(self) ws = self;
        _success = ^KVHttpTool * _Nullable(void (^ _Nullable obj)(id responseObject)) {
            [ws lock];
            ws.info.successBlock = obj;
            [ws unlock];
            return ws;
        };
    }
    return _success;
}

- (KVHttpTool * _Nullable (^)(void (^ _Nullable)(NSError * _Nullable)))failure {
    if (!_failure) {
        __weak typeof(self) ws = self;
        _failure = ^KVHttpTool * _Nullable(void (^ _Nullable obj)(NSError * error)) {
            [ws lock];
            ws.info.failureBlock = obj;
            [ws unlock];
            return ws;
        };
    }
    return _failure;
}

- (KVHttpTool * _Nullable (^)(void (^ _Nullable)(id _Nullable)))cache {
    if (!_cache) {
        __weak typeof(self) ws = self;
        _cache = ^KVHttpTool * _Nullable(void (^ _Nullable obj)(id responseObject)) {
            [ws lock];
            ws.info.cacheBlock = obj;
            [ws unlock];
            return ws;
        };
    }
    return _cache;
}

@end

@interface _KVHttpUpload : KVHttpTool

@property (copy, nonatomic, readwrite) NSString *filePath;

@end

@implementation _KVHttpUpload

@dynamic filePath;

+ (instancetype)upload:(NSString *)url filePath:(NSString *)filePath {
    _KVHttpUpload *upload = [super request:url];
    upload.filePath = filePath;
    return upload;
}

- (void)impSend {
    
//    [self lock];
//
//    /// 开始发起请求
//
//    NSString *url = self.url;
//    NSString *filePath = self.filePath;
//
//    KVHttpToolInfos *info = self.info;
////    KVHttpToolMethod method = KVHttpTool_POST; //info.method; // 上传只能POST
//    NSDictionary *params = info.params;
//    NSDictionary *headers = info.headers;
//    KVHttpToolResponseSerialization responseSerialization = info.responseSerialization;
//    BOOL serializationToJSON = info.serializationToJSON;
//    void (^ progressBlock)(NSProgress *progress) = info.progressBlock;
//    void (^ successBlock)(id _Nullable responseObject) = info.successBlock;
//    void (^ failureBlock)(NSError * _Nullable error) = info.failureBlock;
//
//
//    /// 检测文件是否存在
//    BOOL isDirectory = NO;
//    BOOL isExecutableFileAtPath = [[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&isDirectory];
//    if (!isExecutableFileAtPath) {
//        NSError *error = [NSError errorWithDomain:url code:-1 userInfo:@{NSLocalizedDescriptionKey: @"文件不存在"}];
//        failureBlock? failureBlock(error): nil;
//        unlockBlock();
//        return;
//    }
    
//    /// 拷贝到一个新目录
//    if (![self createTmpFile:filePath]) {
//        NSError *error = [NSError errorWithDomain:url code:-1 userInfo:@{NSLocalizedDescriptionKey: @"无法拷贝待上传文件"}];
//        failureBlock? failureBlock(error): nil;
//        unlockBlock();
//        return;
//    }
    
   
}

- (void)kv_receiveWeakObserveValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([object isKindOfClass:NSURLSessionTask.class] &&
        object == self.task) {
        if (self.task.state == NSURLSessionTaskStateCanceling) {
            [self clearTmpFile];
        } else if (self.task.state == NSURLSessionTaskStateCompleted) {
            [self clearTmpFile];
        }
    }
}

- (void)clearTmpFile {
    
}

- (BOOL)createTmpFile:(NSString *)fromPath {
    return YES;
}

+ (NSString *)uploadDirectory {
    return @"";
}

@end

@implementation KVHttpTool (Upload)

@dynamic filePath;

+ (instancetype)upload:(NSString *)url filePath:(NSString *)filePath {
    return [_KVHttpUpload upload:url filePath:filePath];
}

- (NSString *)filePath {
    return nil;
}

@end

@interface _KVHttpDownload : KVHttpTool

@property (copy, nonatomic, readwrite) KVHttpTool* _Nullable (^ downloadSuccess) (void (^ _Nullable successBlock)(NSURL * _Nullable fileURL));

@end

@implementation _KVHttpDownload
{
    KVHttpTool* _Nullable (^ _success) (void (^ _Nullable successBlock)(id _Nullable responseObject));
}

@dynamic success;

+ (instancetype)download:(NSString *)url {
    _KVHttpDownload *d = [super request:url];
    return d;
}

- (void)impSend {
    [self lock];
    // 默认只允许同时一个在请求
    if (self.queue.operations.count) {
        KVHttpToolLog(@"有任务正在进行中，若要开始新的任务，先取消");
        [self unlock];
        return;
    }
    
    KVHttpDownloadOpration *op = [[KVHttpDownloadOpration alloc] initWithUrl:self.url info:self.info];
    [self.queue addOperation:op];
    self.task = op.task;
    [self unlock];
}

- (void)setSuccess:(KVHttpTool * _Nullable (^)(void (^ _Nullable)(id _Nullable)))success {
    _downloadSuccess = success;
}

- (KVHttpTool * _Nullable (^)(void (^ _Nullable)(id _Nullable)))success {
    return _downloadSuccess;
}

- (KVHttpTool * _Nullable (^)(void (^ _Nullable)(NSURL * _Nullable)))downloadSuccess {
    if (!_downloadSuccess) {
        __weak typeof(self) ws = self;
        _downloadSuccess = ^KVHttpTool * _Nullable(void (^ _Nonnull obj)(NSURL * fileURL)) {
            [ws lock];
            ws.info.successBlock = obj;
            [ws unlock];
            return ws;
        };
    }
    return _downloadSuccess;
}

@end

@implementation KVHttpTool (Download)

+ (instancetype)download:(NSString *)url {
    return [_KVHttpDownload download:url];
}

- (KVHttpTool * _Nullable (^)(void (^ _Nullable)(NSURL * _Nullable)))downloadSuccess {
    return nil;
}

@end
