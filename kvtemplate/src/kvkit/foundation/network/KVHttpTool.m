//
//  KVHttpTool.m
//  KVTableView
//
//  Created by kevin on 2020/5/12.
//  Copyright © 2020 kevin. All rights reserved.
//

#import <objc/runtime.h>

#import <AFNetworking/AFNetworking.h>

#import "NSObject+WeakObserve.h"

#import "KVHttpTool.h"
#import "KVHttpTool+Business.h"
#import "KVHttpTool+MISC.h"

#import "KVHttpToolCache.h"

#import "KVHttpOpration.h"

@interface KVHttpTool ()

@property (strong, nonatomic, readwrite) KVHttpToolInfos *info;

@property (copy, nonatomic, readwrite) NSString *url;

@property (copy, nonatomic, readwrite) KVHttpTool* _Nullable (^ method) (KVHttpToolMethod method);

@property (copy, nonatomic, readwrite) KVHttpTool* _Nullable (^ params) (NSDictionary * _Nullable params);

@property (copy, nonatomic, readwrite) KVHttpTool* _Nullable (^ headers) (NSDictionary<NSString *, NSString *> * _Nullable headers);

@property (copy, nonatomic, readwrite) KVHttpTool* _Nullable (^ responseSerialization) (KVHttpToolResponseSerialization responseSerialization);

@property (copy, nonatomic, readwrite) KVHttpTool* _Nullable (^ serializationToJSON) (BOOL serializationToJSON);

@property (copy, nonatomic, readwrite) KVHttpTool* _Nullable (^ cacheMate) (KVHttpToolCacheMate cacheMate);

@property (copy, nonatomic, readwrite) KVHttpTool* _Nullable (^ cacheDelegate) (id<KVHttpToolCacheProtocol> cacheDelegate);

@property (copy, nonatomic, readwrite) KVHttpTool* _Nullable (^ businessDelegate) (id<KVHttpToolBusinessProtocol> businessDelegate);

@property (copy, nonatomic, readwrite) KVHttpTool* _Nullable (^ progress) (void (^ _Nullable progressBlock)(NSProgress *progress));

@property (copy, nonatomic, readwrite) KVHttpTool* _Nullable (^ success) (void (^ _Nullable successBlock)(id _Nullable responseObject));

@property (copy, nonatomic, readwrite) KVHttpTool* _Nullable (^ failure) (void (^ _Nullable failureBlock)(NSError * _Nullable error));

@property (copy, nonatomic, readwrite) KVHttpTool* _Nullable (^ cache) (void (^ _Nullable cacheBlock)(id _Nullable responseObject));

@property (copy, nonatomic, readwrite) void (^ send) (void);

@end

@implementation KVHttpTool
{
    dispatch_semaphore_t _semaphore;
    NSOperationQueue *_queue;
    BOOL _isLocked;
}

- (void)dealloc {
    KVKitLog(@"%@ dealloc~", NSStringFromClass(self.class));
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

// 给默认值
- (void)commonInit {
    _semaphore = dispatch_semaphore_create(1);
    _queue = [[NSOperationQueue alloc] init];
    _queue.maxConcurrentOperationCount = 1;
    _info = [[KVHttpToolInfos alloc] init];
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
        [ws impSend];
    };
}

- (void)lock {
    dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
    _isLocked = YES;
//    KVKitLog(@"===lock");
}

- (void)unlock {
    dispatch_semaphore_signal(_semaphore);
    _isLocked = NO;
//    KVKitLog(@"===unlock");
}

- (BOOL)isLocked {
    return _isLocked;
}

- (void)impSend {
    [self lock];
    // 默认只允许send一次
    if (self.queue.operationCount > 0) {
        KVKitLog(@"只允许send一次");
        [self unlock];
        return;
    }
    [self.queue addOperation:[[KVHttpOpration alloc] initWithUrl:self.url info:self.info]];
    [self unlock];
}

- (void)cancel {
    [self lock];
    [self.queue cancelAllOperations];
    [self unlock];
}

- (void)pause {
    [self lock];
    [self.queue.operations enumerateObjectsUsingBlock:^(__kindof KVHttpOpration * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj pause];
    }];
    [self unlock];
}

- (void)resume {
    [self lock];
    [self.queue.operations enumerateObjectsUsingBlock:^(__kindof KVHttpOpration * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj resume];
    }];
    [self unlock];
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
@property (copy, nonatomic, readwrite) NSString *name;
@property (copy, nonatomic, readwrite) NSString *fileName;
@property (copy, nonatomic, readwrite) NSString *mimeType;

@end

@implementation _KVHttpUpload

+ (instancetype)upload:(NSString *)url filePath:(NSString *)filePath name:(NSString * _Nonnull)name fileName:(NSString * _Nonnull)fileName mimeType:(NSString * _Nonnull)mimeType {
    _KVHttpUpload *upload = [super request:url];
    upload.filePath = filePath;
    upload.name = name;
    upload.fileName = fileName;
    upload.mimeType = mimeType;
    return upload;
}


- (void)impSend {
    [self lock];
    // 默认只允许send一次
    if (self.queue.operationCount > 0) {
        KVKitLog(@"只允许send一次");
        [self unlock];
        return;
    }
    [self.queue addOperation:[[KVHttpUploadOpration alloc] initWithUrl:self.url info:self.info filePath:self.filePath name:self.name fileName:self.fileName mimeType:self.mimeType]];
    [self unlock];
   
}

@end

@implementation KVHttpTool (Upload)

@dynamic filePath;
@dynamic name;
@dynamic fileName;
@dynamic mimeType;

+ (instancetype)upload:(NSString *)url filePath:(NSString *)filePath name:(NSString * _Nonnull)name fileName:(NSString * _Nonnull)fileName mimeType:(NSString * _Nonnull)mimeType {
    return [_KVHttpUpload upload:url filePath:filePath name:name fileName:fileName mimeType:mimeType];
}

- (void)setFilePath:(NSString * _Nullable)filePath {
    self.upload.filePath = filePath;
}

- (NSString *)filePath {
    return self.upload.filePath;
}

- (void)setFileName:(NSString * _Nullable)fileName {
    self.upload.fileName = fileName;
}

- (NSString *)fileName {
    return self.upload.fileName;
}

- (void)setName:(NSString * _Nullable)name {
    self.upload.name = name;
}

- (NSString *)name {
    return self.upload.name;
}

- (void)setMimeType:(NSString * _Nullable)mimeType {
    self.upload.mimeType = mimeType;
}

- (NSString *)mimeType {
    return self.upload.mimeType;
}
- (_KVHttpUpload *)upload {
    if ([self isKindOfClass:_KVHttpUpload.class]) {
        return (_KVHttpUpload *)self;
    }
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
    // 默认只允许send一次
    if (self.queue) {
        KVKitLog(@"只允许send一次");
        [self unlock];
        return;
    }
    [self.queue addOperation:[[KVHttpDownloadOpration alloc] initWithUrl:self.url info:self.info]];
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
    return self.download.downloadSuccess;
}

- (_KVHttpDownload *)download {
    id res = self;
    if ([res isKindOfClass:_KVHttpDownload.class]) {
        return res;
    }
    return nil;
}

@end

@implementation KVHttpTool (NetStatus)

+ (void)listenNetStateChange:(void (^) (KVNetStatus status))block {
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    /*
    AFNetworkReachabilityStatusUnknown          = -1, 未知
    AFNetworkReachabilityStatusNotReachable     = 0,  没有网络
    AFNetworkReachabilityStatusReachableViaWWAN = 1,  蜂窝流量
    AFNetworkReachabilityStatusReachableViaWiFi = 2,  无线
    */
    // 监听网络状态的变化
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                KVKitLog(@"未知网络");
                block? block(KVNetStatus_Unknown): nil;
                break;
            case AFNetworkReachabilityStatusNotReachable:
                KVKitLog(@"没有网络");
                block? block(KVNetStatus_NotReachable): nil;
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                KVKitLog(@"数据网络");
                block? block(KVNetStatus_ReachableViaWWAN): nil;
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                KVKitLog(@"无线网络");
                block? block(KVNetStatus_ReachableViaWiFi): nil;
                break;

            default:
                break;
        }
    }];
    // 开启
    [manager startMonitoring];
}

@end
