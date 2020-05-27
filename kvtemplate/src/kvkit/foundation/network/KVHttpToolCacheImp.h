//
//  KVHttpToolCacheImp.h
//  KVTableView
//
//  Created by kevin on 2020/5/13.
//  Copyright © 2020 kevin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol KVHttpToolCacheImpProtocol <NSObject>

- (instancetype)initWithPath:(NSString *)path directoryName:(NSString *)directoryName overdueTimeval:(NSTimeInterval)overdueTimeval;

- (void)clearOverdue;

- (void)delete:(NSString *)shortKey;

- (void)removeAll;

- (void)add:(NSString *)shortKey data:(NSData *)data;

- (NSData *)get:(NSString *)shortKey;

@end

@interface KVHttpToolYYCache : NSObject
<KVHttpToolCacheImpProtocol>

@end

@interface KVHttpToolFileManager : NSObject
<KVHttpToolCacheImpProtocol>

@end

NS_ASSUME_NONNULL_END
