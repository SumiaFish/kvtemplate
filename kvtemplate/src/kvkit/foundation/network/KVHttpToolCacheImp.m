//
//  KVHttpToolCacheImp.m
//  KVTableView
//
//  Created by kevin on 2020/5/13.
//  Copyright © 2020 kevin. All rights reserved.
//

#import "KVHttpToolCacheImp.h"

#import <YYCache/YYCache.h>

#import <CommonCrypto/CommonDigest.h>

@interface KVHttpToolYYCache ()

@end

@implementation KVHttpToolYYCache
{
    YYCache *_cache;
    NSString *_path;
    NSString *_directoryName;
    NSTimeInterval _overdueTimeval;
}

- (instancetype)initWithPath:(NSString *)path directoryName:(NSString *)directoryName overdueTimeval:(NSTimeInterval)overdueTimeval {
    if (self = [super init]) {
        _path = path;
        _directoryName = directoryName;
        _cache = [YYCache cacheWithPath:path];
        _cache.memoryCache.shouldRemoveAllObjectsOnMemoryWarning = YES;
        _cache.memoryCache.shouldRemoveAllObjectsWhenEnteringBackground = YES;
        _overdueTimeval = overdueTimeval;
    }
    return self;
}

- (void)clearOverdue {
    NSString *path = _path;
    BOOL isExistPath = NO;
    if (![path isKindOfClass:NSString.class] ||
        ![[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isExistPath]) {
        // 没有缓存文件
        return;
    }
    
    NSString *directoryName = _directoryName;
    NSString *directoryPath = [self directoryPath];
    if (!directoryName.length ||
        !directoryPath.length) {
        // 没有缓存目录
        return;
    }
    
    NSDate *now = NSDate.date;
    YYCache *cache = _cache;
    NSTimeInterval overdueTimeval = _overdueTimeval;
    [[self getKeys] enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, BOOL * _Nonnull stop) {
        NSTimeInterval time = [self getModtimeWithKey:obj];
        if (now.timeIntervalSince1970 - time >= overdueTimeval) {
            if ([cache containsObjectForKey:obj]) {
                [cache removeObjectForKey:obj];
            }
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:obj];
        }
    }];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSError * error;
    NSArray *array = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:directoryPath error:&error];
    if (error) {
        KVKitLog(@"查找并清理缓存文件是出错 %@\n%@", path, error);
        return;
    }
    NSString *cacheName = [self cacheName];
    [array enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![obj hasPrefix:@"."] &&
            ![obj isEqualToString:cacheName]) {
            // 不是正在使用的都删除
            NSString *filePath = [directoryPath stringByAppendingPathComponent:obj];
            [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
        }
    }];
}

- (void)delete:(NSString *)shortKey {
    YYCache *cache = _cache;
    [[self getKeys] enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj hasPrefix:shortKey]) {
            if ([cache containsObjectForKey:obj]) {
                [cache removeObjectForKey:obj];
            }
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:obj];
        }
    }];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)removeAll {
    [_cache removeAllObjects];
    [[self getKeys] enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, BOOL * _Nonnull stop) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:obj];
    }];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)add:(NSString *)shortKey data:(NSData *)data {
    [self delete:shortKey];
    
    NSString *key = [self insertModtimeForKey:shortKey];
    [_cache setObject:data forKey:key];
    
    NSMutableSet<NSString *> *keys = [NSMutableSet setWithSet:[self getKeys]];
    [keys addObject:key];
    [[NSUserDefaults standardUserDefaults] setObject:keys.allObjects forKey:[self userDefaultsKey]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSData *)get:(NSString *)shortKey {
    __block NSData *res = nil;
    YYCache *cache = _cache;
    [[self getKeys] enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj hasPrefix:shortKey]) {
            if ([cache containsObjectForKey:obj]) {
                res = (NSData *)[cache objectForKey:obj];
                *stop = YES;
            }
        }
    }];
    return res;
}

- (YYCache *)cache {
    return _cache;
}

- (NSString *)directoryPath {
    NSString *directoryName = _directoryName;
    if (directoryName.length > 0) {
        NSArray<NSString *> *array = [_path componentsSeparatedByString:[NSString stringWithFormat:@"/%@/", directoryName]];
        if (array.count >= 2) {
            NSString *directoryPath = [array[0] stringByAppendingPathComponent:directoryName];
            return directoryPath;
        }
    }
    return nil;
}

- (NSString *)cacheName {
    NSString *directoryName = _directoryName;
    if (directoryName.length > 0) {
        NSArray<NSString *> *array = [_path componentsSeparatedByString:[NSString stringWithFormat:@"/%@/", directoryName]];
        if (array.count) {
            NSString *cacheName = array.lastObject;
            return cacheName;
        }
    }
    return nil;
}

- (NSString *)insertModtimeForKey:(NSString *)shortKey {
    return [NSString stringWithFormat:@"%@?mod:%@", shortKey, @(NSDate.date.timeIntervalSince1970)];
}

- (NSTimeInterval)getModtimeWithKey:(NSString *)key {
    NSArray<NSString *> *array = [key componentsSeparatedByString:@"?mod:"];
    if (array.count) {
        return array.lastObject.doubleValue;
    }
    return 0;
}

- (NSSet<NSString *> *)getKeys {
    NSArray<NSString *> *keys = [[NSUserDefaults standardUserDefaults] objectForKey:[self userDefaultsKey]];
    keys = keys? keys: @[];
    return [NSSet setWithArray:keys];
}

- (NSString *)userDefaultsKey {
    // bundleid + 类名，避免重名
    NSString *bundleId = [[NSBundle mainBundle].infoDictionary objectForKey:@"CFBundleIdentifier"];
    NSString *clsName = NSStringFromClass(self.class);
    NSString *suffix = @"keys";
    NSString *key = [NSString stringWithFormat:@"%@.%@.%@", bundleId, clsName, suffix];
    return key.lowercaseString;
}

@end

@implementation KVHttpToolFileManager
{
    NSFileManager *_manager;
    NSString *_path;
    NSString *_directoryName;
    NSTimeInterval _overdueTimeval;
}

- (instancetype)initWithPath:(NSString *)path directoryName:(NSString *)directoryName overdueTimeval:(NSTimeInterval)overdueTimeval {
    if (self = [super init]) {
        _path = path;
        _directoryName = directoryName;
        _manager = [NSFileManager defaultManager];
        _overdueTimeval = overdueTimeval;
        
        KVKitLog(@"path: %@", path);
        BOOL isDirectory = NO;
        BOOL isExist = [_manager fileExistsAtPath:path isDirectory:&isDirectory];
        if (path.length) {
            NSError *error = nil;
            if (!isExist) {
                [_manager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
                if (error) {
                    KVKitLog(@"error: %@", error);
                }
            } else {
                if (!isDirectory) {
                    [_manager removeItemAtPath:path error:&error];
                    if (error) {
                        KVKitLog(@"error: %@", error);
                    }
                    [_manager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
                    if (error) {
                        KVKitLog(@"error: %@", error);
                    }
                }
            }
        }
    }
    return self;
}

- (void)clearOverdue {
    NSString *path = _path;
    BOOL isExistPath = NO;
    if (![path isKindOfClass:NSString.class] ||
        ![[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isExistPath]) {
        // 没有缓存文件
        return;
    }
    
    NSString *directoryName = _directoryName;
    NSString *directoryPath = [self directoryPath];
    if (!directoryName.length ||
        !directoryPath.length) {
        // 没有缓存目录
        return;
    }
    
    NSDate *now = NSDate.date;
    NSError * error;
    NSArray *array = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:directoryPath error:&error];
    if (error) {
        KVKitLog(@"查找并清理缓存文件是出错 %@\n%@", path, error);
        return;
    }
    NSString *cacheName = [self cacheName];
    NSFileManager *manager = _manager;
    NSTimeInterval overdueTimeval = _overdueTimeval;
    [array enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![obj hasPrefix:@"."] &&
            ![obj isEqualToString:cacheName]) {
            // 不是正在使用的都删除
            NSString *filePath = [directoryPath stringByAppendingPathComponent:obj];
            NSDictionary *fileAttributes = [manager attributesOfItemAtPath:filePath error:nil];
            NSDate *date = [fileAttributes objectForKey:NSFileCreationDate];
            if (now.timeIntervalSince1970 - date.timeIntervalSince1970 >= overdueTimeval) {
                [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
            }
        }
    }];
}

- (void)delete:(NSString *)shortKey {
//    [_manager removeItemAtPath:[self filePathWithKey:shortKey] error:nil];
}

- (void)removeAll {
    [_manager removeItemAtPath:_path error:nil];
}

- (void)add:(NSString *)shortKey data:(NSData *)data {
    [self delete:shortKey];
    NSString *path = [self filePathWithKey:shortKey];
    [_manager createFileAtPath:path contents:nil attributes:nil];
    NSError *error = nil;
    [data writeToFile:[self filePathWithKey:shortKey] options:(NSDataWritingAtomic) error:&error];
    if (error) {
        KVKitLog(@"error %@", error);
    }
}

- (NSData *)get:(NSString *)shortKey {
    return [_manager contentsAtPath:[self filePathWithKey:shortKey]];
}

- (NSString *)filePathWithKey:(NSString *)shortKey {
    // 做md5是防止文件名过长
    return [_path stringByAppendingPathComponent:[self md5:shortKey]];
}

- (NSString *)directoryPath {
    NSString *directoryName = _directoryName;
    if (directoryName.length > 0) {
        NSArray<NSString *> *array = [_path componentsSeparatedByString:[NSString stringWithFormat:@"/%@/", directoryName]];
        if (array.count >= 2) {
            NSString *directoryPath = [array[0] stringByAppendingPathComponent:directoryName];
            return directoryPath;
        }
    }
    return nil;
}

- (NSString *)cacheName {
    NSString *directoryName = _directoryName;
    if (directoryName.length > 0) {
        NSArray<NSString *> *array = [_path componentsSeparatedByString:[NSString stringWithFormat:@"/%@/", directoryName]];
        if (array.count) {
            NSString *cacheName = array.lastObject;
            return cacheName;
        }
    }
    return nil;
}

- (NSString *)md5:(NSString *)string{
    const char *cStr = [string UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    
    if (@available (iOS 13, *)) {
        CC_MD5(cStr, (CC_LONG)strlen(cStr), digest);
    } else {
        CC_MD5(cStr, (CC_LONG)strlen(cStr), digest);
    }
    
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02X", digest[i]];
    }
    
    return result;
}

@end
