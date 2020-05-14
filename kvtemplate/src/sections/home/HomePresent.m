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

- (FBLPromise *)kv_loadDataWithTableView:(id<KVTableViewProtocol>)tableView isRefresh:(BOOL)isRefresh {
    
    [KVHttpTool test];
    
    AppNetworking.toast = [KVToast share];
    AppNetworking.toastShowMode = AppNetworkingToastShowMode_All;
    [AppNetworking request:@"https://www.baidu.com"]
    .send();
    
    KVHttpTool *tool = [KVHttpTool request:@"https://www.baidu.com"];

    tool.success(^(id  _Nullable responseObject) {
        NSLog(@"succ == ==");
    })
    .failure(^(NSError * _Nullable error) {

    });

    tool.send();
    [KVHttpTool todoInGlobalDefaultQueue:^{
        for (NSInteger i = 0; i < 1000; i ++) {
            NSLog(@"aaaaaaa");
//            tool.headers(@{@(i).stringValue: @(i).stringValue});
            sleep(0.01);
            tool.send();
            [KVHttpTool todoInGlobalDefaultQueue:^{
                if (i < 50) {
                    tool.headers(@{@(i).stringValue: @(i).stringValue});
                    NSLog(@"bbbbb");
                    tool.send();
                } else {
                    [tool cancelAll];
                }
                sleep(0.01);
            }];
        }

    }];
    
    NSLog(@"哈哈哈");
    
    return [FBLPromise async:^(FBLPromiseFulfillBlock  _Nonnull fulfill, FBLPromiseRejectBlock  _Nonnull reject) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            sleep(1);
            
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
                    [self.data removeAllObjects];
                }
                if (hasMore) {
                    for (NSInteger i = 0; i < 20; i++) {
                        [self.data addObject:@(i)];
                    }
                }
                [tableView.adapter updateWithData:self.data page:newPage hasMore:hasMore];
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
