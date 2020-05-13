//
//  KVHttpTool+Business.h
//  KVTableView
//
//  Created by kevin on 2020/5/12.
//  Copyright © 2020 kevin. All rights reserved.
//

#import "KVHttpTool.h"

NS_ASSUME_NONNULL_BEGIN

@interface KVHttpTool (Business)

/// 配置全局请求头
@property (class, strong, nonatomic, nullable) NSDictionary <NSString *, NSString *> *headers;

/// 数据的业务校验
@property (class, strong, nonatomic, nullable) id<KVHttpToolBusinessProtocol> business;

/// 全局缓存对象
@property (class, strong, nonatomic, nullable) id<KVHttpToolCacheProtocol> cacheDelegate;

@end

NS_ASSUME_NONNULL_END
