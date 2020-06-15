//
//  KVEmptyDataViewProtocol.h
//  kvtemplate
//
//  Created by kevin on 2020/6/15.
//  Copyright © 2020 kevin. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "KVEmptyDataInfo.h"

NS_ASSUME_NONNULL_BEGIN

@protocol KVEmptyDataViewProtocol <NSObject>

- (void)displayEmptyView:(BOOL)isDisplay;

- (BOOL)isDisplayEmptyView;

- (void)reloadEmptyView:(KVEmptyDataInfo *)info;
- (KVEmptyDataInfo *)emptyDataInfo;

@end

NS_ASSUME_NONNULL_END
