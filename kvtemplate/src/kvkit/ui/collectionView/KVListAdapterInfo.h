//
//  KVListAdapterInfo.h
//  kvtemplate
//
//  Created by kevin on 2020/6/16.
//  Copyright © 2020 kevin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KVListAdapterInfo : NSObject

@property (strong, nonatomic, readonly) NSArray *data;
@property (assign, nonatomic, readonly) NSInteger page;
@property (assign, nonatomic, readonly) BOOL hasMore;

+ (instancetype)infoWithData:(NSArray * __nullable)data page:(NSInteger)page hasMore:(BOOL)hasMore;

@end

NS_ASSUME_NONNULL_END
