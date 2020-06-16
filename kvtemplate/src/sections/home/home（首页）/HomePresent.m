//
//  HomePresent.m
//  KVTableView
//
//  Created by kevin on 2020/5/11.
//  Copyright © 2020 kevin. All rights reserved.
//

#import "HomePresent.h"

#import "KVHttpTool+MISC.h"

@interface HomePresent ()

@property (strong, nonatomic, readwrite) NSMutableArray<NSArray<NSNumber *> *> *data;

@end

@implementation HomePresent

- (void)dealloc {
    kLog(@"%@ dealloc~", NSStringFromClass(self.class));
}

- (FBLPromise *)loadData:(NSInteger)page isRefresh:(BOOL)isRefresh {
    
    AppNetworking *appn = [AppNetworking upload:@"https://www.baidu.com" filePath:[NSBundle.mainBundle pathForResource:@"unnamed.jpg" ofType:nil] name:@"image" fileName:@"test.image" mimeType:@"application/image"];
    
    appn.success(^(id  _Nullable responseObject) {
        kLog(@"responseObject: %@", [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
    })
    .failure(^(NSError * _Nullable error) {
        kLog(@"error: %@", error.localizedDescription);
    })
    .send();
    
    return [FBLPromise async:^(FBLPromiseFulfillBlock  _Nonnull fulfill, FBLPromiseRejectBlock  _Nonnull reject) {
        
        [AppNetworking request:@"https://www.baidu.com"]
        .cacheMate(KVHttpToolCacheMate_Url)
        .success(^(id  _Nullable responseObject) {

            // test begin
            NSError *err = nil;// [NSError errorWithDomain:@"kv" code:-1 userInfo:@{NSLocalizedDescriptionKey: @"请求出错"}];
            if (page%2 == 1) {
                err = nil;
            }
            if (err) {
                reject(err);
                return;
            }
            // test end
            
            
            BOOL hasMore = page <= 5;
            if (isRefresh) {
                [self.mtData removeAllObjects];
            }
            if (hasMore) {
                NSMutableArray *items = NSMutableArray.array;
                for (NSInteger i = 0; i < 20; i++) {
                    [items addObject:@(i)];
                }
                [self.mtData addObject:items];
            }

            fulfill([KVListAdapterInfo infoWithData:self.data page:page hasMore:hasMore]);
            
        })
        .failure(^(NSError * _Nullable error) {
            
            reject(error);
            
        }).send();
        
        
        
    }];
}

- (FBLPromise *)loadCacheData:(NSInteger)page isRefresh:(BOOL)isRefresh {
    
    return [FBLPromise async:^(FBLPromiseFulfillBlock  _Nonnull fulfill, FBLPromiseRejectBlock  _Nonnull reject) {
        
        [KVHttpToolCache.share responseObjectWithCacheType:(KVHttpToolCacheMate_Url) url:@"https://www.baidu.com" headers:nil params:nil complete:^(NSData * _Nullable data) {
            
            BOOL hasMore = page <= 5;
            if (isRefresh) {
                [self.mtData removeAllObjects];
            }
            if (hasMore) {
                NSMutableArray *items = NSMutableArray.array;
                for (NSInteger i = 0; i < 20; i++) {
                    [items addObject:@(i)];
                }
                [self.mtData addObject:items];
            }

            fulfill([KVListAdapterInfo infoWithData:self.data page:page hasMore:hasMore]);
            
        }];
        
    }];
    
}

- (NSArray<NSArray<NSNumber *> *> *)data {
    return [self mtData];
}

- (NSMutableArray *)mtData {
    if (!_data) {
        _data = NSMutableArray.array;
    }
    return _data;
}

@end
