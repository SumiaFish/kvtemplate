//
//  KVHttpTool+Business.m
//  KVTableView
//
//  Created by kevin on 2020/5/12.
//  Copyright © 2020 kevin. All rights reserved.
//

#import "KVHttpTool+Business.h"

#import <objc/runtime.h>

@implementation KVHttpTool (Business)

static void* KVHttpToolHeadersKey = &KVHttpToolHeadersKey;
static void* KVHttpToolBusinessKey = &KVHttpToolBusinessKey;
static void* KVHttpToolCacheKey = &KVHttpToolCacheKey;

+ (void)setHeaders:(NSDictionary<NSString *,NSString *> *)headers {
    objc_setAssociatedObject(KVHttpTool.class, KVHttpToolHeadersKey, headers, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (NSDictionary<NSString *,NSString *> *)headers {
    return objc_getAssociatedObject(KVHttpTool.class, KVHttpToolHeadersKey);
}

+ (void)setBusiness:(id<KVHttpToolBusinessProtocol>)business {
    objc_setAssociatedObject(KVHttpTool.class, KVHttpToolBusinessKey, business, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (id<KVHttpToolBusinessProtocol>)business {
    return objc_getAssociatedObject(KVHttpTool.class, KVHttpToolBusinessKey);
}

+ (void)setCacheDelegate:(id<KVHttpToolCacheProtocol>)cacheDelegate {
    objc_setAssociatedObject(self, KVHttpToolCacheKey, cacheDelegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (id<KVHttpToolCacheProtocol>)cacheDelegate {
    return objc_getAssociatedObject(self, KVHttpToolCacheKey);
}

@end
