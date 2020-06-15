//
//  KVHttpToolCache.m
//  KVTableView
//
//  Created by kevin on 2020/5/13.
//  Copyright © 2020 kevin. All rights reserved.
//

#import <YYCache/YYCache.h>

#import "KVHttpToolCache.h"

#import "KVHttpTool.h"

#import "KVHttpToolCacheImp.h"

#import "KVStorege.h"
#import "KVOperation.h"

@interface KVHttpToolCacheOperation : KVOperation

@property (copy, nonatomic, readonly) NSString *key;
@property (copy, nonatomic, readonly) void (^ taskBlock) (void);

@end

@implementation KVHttpToolCacheOperation

- (instancetype)initWithKey:(NSString *)key taskBlock:(void (^) (void))taskBlock {
    if (self = [super init]) {
        _key = key;
        _taskBlock = taskBlock;
    }
    return self;
}

- (void)todo {
    _taskBlock? _taskBlock(): nil;
    [self complete];
}

@end

@interface KVHttpToolCache ()
<KVStoregeProtocol>

@end

@implementation KVHttpToolCache
{
    NSOperationQueue *_queue;
    dispatch_semaphore_t _semaphore;
    id<KVHttpToolCacheImpProtocol> _cache;
}

@synthesize overdueTimeval = _overdueTimeval;

static KVHttpToolCache *instance = nil;
static BOOL KVHttpToolCacheInitFlag = NO;

+ (instancetype)share {
    static dispatch_once_t token;
    _dispatch_once(&token, ^{
        KVHttpToolCacheInitFlag = YES;
        instance = [[KVHttpToolCache alloc] init];
        KVHttpToolCacheInitFlag = NO;
    });
    return instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t token;
    _dispatch_once(&token, ^{
        instance = [super allocWithZone:zone];
    });
    return instance;
}

- (instancetype)init {
    if (KVHttpToolCacheInitFlag) {
        if (self = [super init]) {
            _queue = [[NSOperationQueue alloc] init];
            _queue.maxConcurrentOperationCount = KVHttpToolCacheMaxConcurrentOperationCount;
            _semaphore = dispatch_semaphore_create(1);
            
            _cache = [[KVHttpToolFileManager alloc] initWithPath:[self getCachePath] directoryName:[self directoryName] overdueTimeval:self.overdueTimeval];
            
            __weak typeof(self) ws = self;
            KVHttpToolCacheOperation *op = [[KVHttpToolCacheOperation alloc] initWithKey:nil taskBlock:^{
                [ws.cache clearOverdue];
            }];
            [_queue addOperation:op];
            
            [KVStorege createStorege:(id<KVStoregeProtocol>)self.class];
        }
    }
    
    return instance;
}

- (NSOperationQueue *)queue {
    return _queue;
}

- (id<KVHttpToolCacheImpProtocol>)cache {
    return _cache;
}

- (NSTimeInterval)overdueTimeval {
    if (_overdueTimeval == 0) {
        return KVHttpToolCacheOverdueTimeval;
    }
    return _overdueTimeval;
}

#pragma mark - KVStoregeProtocol

// TODO 这里可能有问题
+ (void)clearCache {
    [[self.class share] removeAll];
}

#pragma mark - KVHttpToolCacheProtocol

- (void)cache:(KVHttpToolCacheMate)type url:(nonnull NSString *)url headers:(NSDictionary * _Nullable)headers params:(NSDictionary * _Nullable)params data:(nonnull NSData *)data {

    // 参数检查!!!
    if (!data.length) {
        return;
    }
    NSString *key = [self getKeyWithCache:type url:url headers:headers params:params];
    if (!key.length) {
        return;
    }
    
    [self lock];
    
    __weak typeof(self) ws = self;
    KVHttpToolCacheOperation *op = [[KVHttpToolCacheOperation alloc] initWithKey:key taskBlock:^{
        if (!data) {
            return;
        }
        [ws.cache add:key data:data];
    }];
    [_queue addOperation:op];
    
    [self unlock];
    
}

- (void)responseObjectWithCacheType:(KVHttpToolCacheMate)type url:(NSString *)url headers:(NSDictionary *)headers params:(NSDictionary *)params complete:(nonnull void (^)(NSData * _Nullable))complete {
    
    // 参数检查!!!
    NSString *key = [self getKeyWithCache:type url:url headers:headers params:params];
    if (!key.length) {
        complete? complete(nil): nil;
        return;
    }
    
    [self lock];
    
    __weak typeof(self) ws = self;
    KVHttpToolCacheOperation *op = [[KVHttpToolCacheOperation alloc] initWithKey:key taskBlock:^{
        void (^ mainQueueBlock) (id responseObject) = ^ (id responseObject) {
            if (!complete) {
                return;
            }
            // 切换到主线程执行回调
            if (strcmp(dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL), dispatch_queue_get_label(dispatch_get_main_queue())) == 0) {
                complete(responseObject);
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    complete(responseObject);
                });
            }
        };
        mainQueueBlock([ws.cache get:key]);
    }];
    
    [_queue addOperation:op];
    
    [self unlock];
    
}

- (void)removeCache:(KVHttpToolCacheMate)type url:(NSString *)url headers:(NSDictionary *)headers params:(NSDictionary *)params {
    
    // 参数检查!!!
    NSString *key = [self getKeyWithCache:type url:url headers:headers params:params];
    if (!key.length) {
        return;
    }
    
    [self lock];
    
    [_queue.operations enumerateObjectsUsingBlock:^(__kindof KVHttpToolCacheOperation * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.key isEqualToString:key]) {
            [obj cancel];
        }
    }];
    
    __weak typeof(self) ws = self;
    KVHttpToolCacheOperation *op = [[KVHttpToolCacheOperation alloc] initWithKey:key taskBlock:^{
        [ws.cache delete:key];
    }];
    [_queue addOperation:op];
    
    [self unlock];
    
}

- (void)removeAll {
    
    // 停止所有操作
    [self lock];
    
//    _queue.suspended = NO;// 这里不能这么写，会有问题
    [_queue cancelAllOperations];
//    _queue.suspended = YES;
    
    __weak typeof(self) ws = self;
    KVHttpToolCacheOperation *op = [[KVHttpToolCacheOperation alloc] initWithKey:nil taskBlock:^{
        [ws.cache removeAll];
    }];
    [_queue addOperation:op];
    
    [self unlock];
    
}

#pragma mark -

- (void)lock {
    dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
}

- (void)unlock {
    dispatch_semaphore_signal(_semaphore);
}

- (NSString *)getKeyWithCache:(KVHttpToolCacheMate)type url:(nonnull NSString *)url headers:(NSDictionary * _Nullable)headers params:(NSDictionary * _Nullable)params {
    
    if (type == KVHttpToolCacheMate_Undefine) {
        return nil;
    }
    
    NSString *urlString = [NSString stringWithFormat:@"%@", url];
    if (urlString.length == 0) {
        KVKitLog(@"生成文件路径失败: string.length == 0");
        return nil;
    }
    
    NSString *headersString = ({
        NSString *res = nil;
        if (headers) {
            NSError *createHeadersStringError = nil;
            NSJSONWritingOptions opt = NSJSONWritingPrettyPrinted;
            if (@available(iOS 11.0, *)) {
                opt = NSJSONWritingSortedKeys;
            }
            NSData *data = [NSJSONSerialization dataWithJSONObject:headers options:opt error:&createHeadersStringError];
            if (createHeadersStringError) {
                KVKitLog(@"生成文件路径失败: %@", createHeadersStringError);
            } else {
                res = [[NSString alloc] initWithData:data encoding:(NSUTF8StringEncoding)];
            }
        }
        res;
    });
    
    NSString *paramsString = ({
        NSString *res = nil;
        if (params) {
            NSError *createParamsStringError = nil;
            NSJSONWritingOptions opt = NSJSONWritingPrettyPrinted;
            if (@available(iOS 11.0, *)) {
                opt = NSJSONWritingSortedKeys;
            }
            NSData *data = [NSJSONSerialization dataWithJSONObject:params options:(opt) error:&createParamsStringError];
            if (createParamsStringError) {
                KVKitLog(@"生成文件路径失败: %@", createParamsStringError);
                
            } else {
                res = [[NSString alloc] initWithData:data encoding:(NSUTF8StringEncoding)];
            }
        }
        res;
    });
    
    
    if (type == KVHttpToolCacheMate_Url) {
        NSString *res = urlString;
        NSData *data = [res dataUsingEncoding:(NSUTF8StringEncoding)];
        NSString *base64 = [data base64EncodedStringWithOptions:0];
        
        NSString *newUrl = url;
        return [NSString stringWithFormat:@"%@?base64:%@", newUrl, base64];
    }
    
    if (type == KVHttpToolCacheMate_Url_Headers) {
        NSString *u_str = urlString;
        NSString *h_str = headersString;
        if (h_str.length == 0) {
            h_str = @"headers=null";
        }
        NSString *res = [NSString stringWithFormat:@"%@?headers:%@", u_str, h_str];
        NSData *data = [res dataUsingEncoding:(NSUTF8StringEncoding)];
        NSString *base64 = [data base64EncodedStringWithOptions:0];

        NSString *newUrl = url;
        return [NSString stringWithFormat:@"%@?base64:%@", newUrl, base64];
    }
    
    if (type == KVHttpToolCacheMate_Url_Params) {
        NSString *u_str = urlString;
        NSString *p_str = paramsString;
        if (p_str.length == 0) {
            p_str = @"?params=null";
        }
        NSString *res = [NSString stringWithFormat:@"%@?params:%@", u_str, p_str];
        NSData *data = [res dataUsingEncoding:(NSUTF8StringEncoding)];
        NSString *base64 = [data base64EncodedStringWithOptions:0];

        NSString *newUrl = url;
        return [NSString stringWithFormat:@"%@?base64:%@", newUrl, base64];
    }
    
    if (type == KVHttpToolCacheMate_Url_Headers_Params) {
        NSString *u_str = urlString;
        NSString *h_str = headersString;
        NSString *p_str = paramsString;
        if (h_str.length == 0) {
            h_str = @"headers=null";
        }
        if (p_str.length == 0) {
            p_str = @"params=null";
        }
        NSString *res =  [NSString stringWithFormat:@"%@?headers:%@?params:%@", u_str, h_str, p_str];
        NSData *data = [res dataUsingEncoding:(NSUTF8StringEncoding)];
        NSString *base64 = [data base64EncodedStringWithOptions:0];

        NSString *newUrl = url;
        return [NSString stringWithFormat:@"%@?base64:%@", newUrl, base64];
    }
    
    return nil;
    
}

// 获取缓存文件路径
- (NSString *)getCachePath {
    // 获取Caches目录路径
    NSString *cachesDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    
    // 这不是全路径，是cache目录下的 rootDirectoryName/directoryName  ==> @"aaa/bbb"
    NSString *defaultsDirectoryName = [self getUserDefaultsDirectoryNameWithKey:[self userDefaultsKey]];
    if (defaultsDirectoryName.length == 0) {
        // 不存在j就创建
        defaultsDirectoryName = [self directoryName];
        NSString *cacheName = NSUUID.UUID.UUIDString;
    
        [self setUserDefaultsDirectoryName:[NSString stringWithFormat:@"%@/%@", defaultsDirectoryName, cacheName] key:[self userDefaultsKey]];
        
        NSString *path = [[cachesDir stringByAppendingPathComponent:defaultsDirectoryName] stringByAppendingPathComponent:cacheName];
        return path;
        
    } else {
        NSString *path = [cachesDir stringByAppendingPathComponent:defaultsDirectoryName];
        return path;
        
    }
}

// 获取UserDefaults中的保存的缓存目录路径 @"directoryName/ cacheName"
- (NSString *)getUserDefaultsDirectoryNameWithKey:(NSString *)key {
    NSString *base64 = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    if ([base64 isKindOfClass:NSString.class]) {
        NSData *data = [[NSData alloc] initWithBase64EncodedString:base64 options:0];
        NSString *userDefaultsValue = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        return userDefaultsValue;
    }
    
    return nil;
}

// 保存缓存目录路径到UserDefaults中 @"directoryName/ cacheName"
- (void)setUserDefaultsDirectoryName:(NSString *)defaultsDirectoryName key:(NSString *)key {
    NSString *userDefaultsValue = defaultsDirectoryName;
    NSData *data = [userDefaultsValue dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64 = [data base64EncodedStringWithOptions:0];
    [[NSUserDefaults standardUserDefaults] setObject:base64 forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)userDefaultsKey {
    // bundleid + 类名，避免重名
    NSString *bundleId = [[NSBundle mainBundle].infoDictionary objectForKey:@"CFBundleIdentifier"];
    NSString *clsName = NSStringFromClass(self.class);
    NSString *suffix = @"directory";
    NSString *key = [NSString stringWithFormat:@"%@.%@.%@", bundleId, clsName, suffix];
    return key.lowercaseString;
}

// 缓存目录
- (NSString *)directoryName {
    return [self userDefaultsKey];
}

@end
