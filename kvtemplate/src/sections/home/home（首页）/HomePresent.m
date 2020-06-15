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

- (FBLPromise *)kv_loadDataWithTableView:(id<KVTableViewProtocol>)tableView isRefresh:(BOOL)isRefresh {
    
    return [FBLPromise async:^(FBLPromiseFulfillBlock  _Nonnull fulfill, FBLPromiseRejectBlock  _Nonnull reject) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            sleep(3);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSError *err = [NSError errorWithDomain:@"kv" code:-1 userInfo:@{NSLocalizedDescriptionKey: @"请求出错"}];
                if ([tableView.adapter getOffsetPageWithIsRefresh:isRefresh]%2 == 1) {
                    err = nil;
                }
                
                if (err) {
                    reject(err);
                    return;
                }
                
                NSInteger newPage = [tableView.adapter getOffsetPageWithIsRefresh:isRefresh];
                BOOL hasMore = newPage <= 5;
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
                
                self.data = NSMutableArray.array;
                
                [tableView.adapter updateWithData:self.data page:newPage hasMore:hasMore];
                fulfill(nil);
                
            });
            
        });
        
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
