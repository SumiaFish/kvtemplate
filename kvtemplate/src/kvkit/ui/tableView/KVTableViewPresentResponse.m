//
//  KVTableViewPresentResponse.m
//  KVTableView
//
//  Created by kevin on 2020/5/11.
//  Copyright © 2020 kevin. All rights reserved.
//

#import "KVTableViewPresentResponse.h"

@interface KVTableViewPresentResponse ()

@property (strong, nonatomic, nullable, readwrite) NSArray *data;
@property (strong, nonatomic, nullable, readwrite) NSError *error;
@property (assign, nonatomic, readwrite) NSInteger page;
@property (assign, nonatomic, readwrite) BOOL hasMore;

@end

@implementation KVTableViewPresentResponse

+ (instancetype)resWithErr:(NSError *)err page:(NSInteger)page {
    KVTableViewPresentResponse *res = [KVTableViewPresentResponse new];
    res.error = err;
    res.page = page;
    return res;
}

+ (instancetype)resWithData:(NSArray *)data page:(NSInteger)page hasMore:(BOOL)hasMore {
    KVTableViewPresentResponse *res = [KVTableViewPresentResponse new];
    res.data = data;
    res.page = page;
    res.hasMore = hasMore;
    return res;
}

@end
