//
//  KVHttpToolCache.h
//  KVTableView
//
//  Created by kevin on 2020/5/13.
//  Copyright © 2020 kevin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KVHttpToolHeader.h"

NS_ASSUME_NONNULL_BEGIN

/** 默认过期时间: 60*60*24*7，即7天 */
static NSTimeInterval const KVHttpToolCacheOverdueTimeval = 604800.0; // s

/** 存取缓存默认最大并发数 */
static NSInteger const KVHttpToolCacheMaxConcurrentOperationCount = 10;

@interface KVHttpToolCache : NSObject
<KVHttpToolCacheProtocol>

+ (instancetype)share;

@end

NS_ASSUME_NONNULL_END
