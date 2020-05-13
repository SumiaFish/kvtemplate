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

@property (strong, nonatomic) NSMutableArray *data;

@end

@implementation HomePresent

- (FBLPromise *)kv_loadData:(id<KVTableViewProtocol>)view isRefresh:(BOOL)isRefresh {
    
    [KVHttpTool test];
    
    return [FBLPromise async:^(FBLPromiseFulfillBlock  _Nonnull fulfill, FBLPromiseRejectBlock  _Nonnull reject) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            sleep(1);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSError *err = [NSError errorWithDomain:@"kv" code:-1 userInfo:@{NSLocalizedDescriptionKey: @"请求出错"}];
                if ([view.adapter getOffsetPageWithIsRefresh:isRefresh]%2 == 1) {
                    err = nil;
                }
                
                if (err) {
                    reject(err);
                    return;
                }
                
                NSInteger newPage = [view.adapter getOffsetPageWithIsRefresh:isRefresh];
                BOOL hasMore = newPage <= 5;
                if (isRefresh) {
                    [self.data removeAllObjects];
                }
                if (hasMore) {
                    for (NSInteger i = 0; i < 20; i++) {
                        [self.data addObject:@(i)];
                    }
                }
                [view.adapter updateWithData:self.data page:newPage hasMore:hasMore];
                fulfill(nil);
                
            });
            
        });
        
    }];
    
}

- (NSMutableArray *)data {
    if (!_data) {
        _data = NSMutableArray.array;
    }
    return _data;
}

@end
