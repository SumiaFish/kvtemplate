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

// 60*60*24*7
static NSTimeInterval const KVHttpToolCacheOverdueTimeval = 604800.0; // s

/// 
static NSInteger const KVHttpToolCacheMaxConcurrentOperationCount = 10;

@interface KVHttpToolCache : NSObject
<KVHttpToolCacheProtocol>

+ (instancetype)share;

@end

NS_ASSUME_NONNULL_END
