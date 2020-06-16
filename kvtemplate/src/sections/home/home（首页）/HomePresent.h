//
//  HomePresent.h
//  KVTableView
//
//  Created by kevin on 2020/5/11.
//  Copyright © 2020 kevin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HomePresent : NSObject

@property (strong, nonatomic, readonly) NSArray<NSArray<NSNumber *> *> *data;

- (FBLPromise *)loadData:(NSInteger)page isRefresh:(BOOL)isRefresh;

- (FBLPromise *)loadCacheData:(NSInteger)page isRefresh:(BOOL)isRefresh;

@end

NS_ASSUME_NONNULL_END
