//
//  KVStorege.m
//  kvtemplate
//
//  Created by kevin on 2020/5/13.
//  Copyright © 2020 kevin. All rights reserved.
//

#import "KVStorege.h"

static NSMutableSet *KVStoregeSet;

@interface KVStorege ()

@end

@implementation KVStorege

+ (id<KVStoregeProtocol>)createStorege:(id<KVStoregeProtocol>)obj {
    [self registStorege:obj];
    return obj;
}

+ (void)registStorege:(id<KVStoregeProtocol>)obj {
    [self.set addObject:obj];
}

+ (void)clearCache:(BOOL)inBackgrounQueue {
    
    void (^ block) (void) = ^ {
        [self.set enumerateObjectsUsingBlock:^(id<KVStoregeProtocol>  _Nonnull obj, BOOL * _Nonnull stop) {
            if ([obj respondsToSelector:@selector(clearCache)]) {
                [obj clearCache];
            }
        }];
    };
    
    if (inBackgrounQueue) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            block();
        });
    } else {
        block();
    }
}

+ (NSMutableSet<id<KVStoregeProtocol>> *)set {
    if (!KVStoregeSet) {
        KVStoregeSet = [NSMutableSet set];
    }
    return KVStoregeSet;
}

+ (NSSet<id<KVStoregeProtocol>> *)objects {
    return self.set;
}

@end
