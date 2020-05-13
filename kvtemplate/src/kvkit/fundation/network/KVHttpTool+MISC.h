//
//  KVHttpTool+MISC.h
//  KVTableView
//
//  Created by kevin on 2020/5/13.
//  Copyright © 2020 kevin. All rights reserved.
//

#import "KVHttpTool.h"

NS_ASSUME_NONNULL_BEGIN

@interface KVHttpTool (MISC)

+ (void)todoInMainQueue:(void (^) (void))block;

+ (void)todoInGlobalDefaultQueue:(void (^) (void))block;

+ (void)test;

@end

NS_ASSUME_NONNULL_END
