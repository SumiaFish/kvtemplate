//
//  KVHttpTool+MISC.m
//  KVTableView
//
//  Created by kevin on 2020/5/13.
//  Copyright © 2020 kevin. All rights reserved.
//

#import "KVHttpTool+MISC.h"
#import "KVHttpToolCache.h"

@implementation KVHttpTool (MISC)

+ (void)todoInMainQueue:(void (^)(void))block {
    if (!block) {
        return;
    }
    if (strcmp(dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL), dispatch_queue_get_label(dispatch_get_main_queue())) == 0) {
        block();
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            block();
        });
    }
}

+ (void)todoInGlobalDefaultQueue:(void (^)(void))block {
    if (!block) {
        return;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        block();
    });
}

+ (void)impTest {
    for (NSInteger i = 0; i < 10000; i++) {
        
        
        [self todoInGlobalDefaultQueue:^{
           
            @autoreleasepool {
                
                NSInteger val = 60+(arc4random()%(300-10+1));
                sleep(val*0.001);
                
                
                NSString *url = @"www.kvhome.xyz";
                NSData *data = [@"优先级翻转的问题 新版 iOS 中，系统维护了 5 个不同的线程优先级/QoS: background，utility，default，user-initiated，user-interactive。高优先级线程始终会在低优先级线程前执行，一个线程不会受到比它更低优先级线程的干扰。这种线程调度算法会产生潜在的优先级反转问题，从而破坏了 spin lock。具体来说，如果一个低优先级的线程获得锁并访问共享资源，这时一个高优先级的线程也尝试获得这个锁，它会处于 spin lock 的忙等状态从而占用大量 CPU。此时低优先级线程无法与高优先级线程争夺 CPU 时间，从而导致任务迟迟完不成、无法释放 lock。这并不只是理论上的问题，libobjc 已经遇到了很多次这个问题了，于是苹果的工程师停用了 OSSpinLock。iOS10以后，苹果给出了新的api, 当然也可以通过前面几章提到的各种锁" dataUsingEncoding:(NSUTF8StringEncoding)];
                [KVHttpToolCache.share cache:(KVHttpToolCacheMate_Url_Headers_Params) url:url headers:@{@(i).stringValue : @(i).stringValue} params:@{@(i).stringValue : @(i%50).stringValue} data:data];
                
                
            }
            
            
            
        }];
        
    }
}

+ (void)test {
    
    [self todoInGlobalDefaultQueue:^{
        [self impTest];
    }];
    
    
}

@end
