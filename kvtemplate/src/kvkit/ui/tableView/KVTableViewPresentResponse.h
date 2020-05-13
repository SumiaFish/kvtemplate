//
//  KVTableViewPresentResponse.h
//  KVTableView
//
//  Created by kevin on 2020/5/11.
//  Copyright © 2020 kevin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KVTableViewPresentResponse : NSObject

@property (strong, nonatomic, nullable, readonly) NSArray *data;
@property (strong, nonatomic, nullable, readonly) NSError *error;
@property (assign, nonatomic, readonly) NSInteger page;
@property (assign, nonatomic, readonly) BOOL hasMore;

+ (instancetype)resWithErr:(NSError *)err page:(NSInteger)page;

+ (instancetype)resWithData:(NSArray *)data page:(NSInteger)page hasMore:(BOOL)hasMore;

@end

NS_ASSUME_NONNULL_END
