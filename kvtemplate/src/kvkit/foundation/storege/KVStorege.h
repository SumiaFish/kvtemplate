//
//  KVStorege.h
//  kvtemplate
//
//  Created by kevin on 2020/5/13.
//  Copyright © 2020 kevin. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "KVStoregeProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface KVStorege : NSObject

+ (id<KVStoregeProtocol>)createStorege:(id<KVStoregeProtocol>)obj;

+ (void)clearCache:(BOOL)inBackgrounQueue;

+ (NSSet<id<KVStoregeProtocol>> *)objects;

@end

NS_ASSUME_NONNULL_END
