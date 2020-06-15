//
//  KVEmptyDataInfo.h
//  kvtemplate
//
//  Created by kevin on 2020/6/15.
//  Copyright © 2020 kevin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

static NSString * const KVStateViewInfo_DefaultEmptyDataTitle = @"暂无数据";

@protocol KVEmptyDataInfoProtocol <NSObject>

- (NSString *)title;

@end

@interface KVEmptyDataInfo : NSObject
<KVEmptyDataInfoProtocol>

@property (copy, nonatomic) NSString *title;

+ (instancetype)info;

@end

NS_ASSUME_NONNULL_END
