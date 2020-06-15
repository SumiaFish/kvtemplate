//
//  KVEmptyDataInfo.m
//  kvtemplate
//
//  Created by kevin on 2020/6/15.
//  Copyright © 2020 kevin. All rights reserved.
//

#import "KVEmptyDataInfo.h"

@implementation KVEmptyDataInfo

+ (instancetype)info {
    KVEmptyDataInfo *info = [[KVEmptyDataInfo alloc] init];
    info.title = KVStateViewInfo_DefaultEmptyDataTitle;
    return info;
}

@end
