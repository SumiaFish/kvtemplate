//
//  KVListAdapterInfo.m
//  kvtemplate
//
//  Created by kevin on 2020/6/16.
//  Copyright © 2020 kevin. All rights reserved.
//

#import "KVListAdapterInfo.h"

@implementation KVListAdapterInfo

- (instancetype)initWithData:(NSArray * __nullable)data page:(NSInteger)page hasMore:(BOOL)hasMore {
    if (self = [super init]) {
        _data = data;
        _page = page;
        _hasMore = hasMore;
    }
    return self;
}

+ (instancetype)infoWithData:(NSArray * __nullable)data page:(NSInteger)page hasMore:(BOOL)hasMore {
    return [[KVListAdapterInfo alloc] initWithData:data page:page hasMore:hasMore];
}

@end
