//
//  NSObject+WeakProperty.m
//  kvtemplate
//
//  Created by kevin on 2020/6/14.
//  Copyright © 2020 kevin. All rights reserved.
//

#import "NSObject+WeakProperty.h"

@implementation NSObject (WeakProperty)

static void* NSObjectWeakPropertyKey;

- (void)setWeakPropsMap:(NSMapTable<NSString *,id> *)weakPropsMap {
    objc_setAssociatedObject(self, NSObjectWeakPropertyKey, weakPropsMap, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMapTable<NSString *,id> *)weakPropsMap {
    id res = objc_getAssociatedObject(self, NSObjectWeakPropertyKey);
    if (!res) {
        res = [[NSMapTable alloc] initWithKeyOptions:(NSPointerFunctionsStrongMemory) valueOptions:(NSPointerFunctionsWeakMemory) capacity:0];
        self.weakPropsMap = res;
    }
    return res;
}

@end
