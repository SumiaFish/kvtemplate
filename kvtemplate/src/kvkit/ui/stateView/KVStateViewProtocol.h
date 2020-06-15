//
//  KVStateViewProtocol.h
//  kvtemplate
//
//  Created by kevin on 2020/5/22.
//  Copyright © 2020 kevin. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "KVStateViewInfo.h"

NS_ASSUME_NONNULL_BEGIN

@protocol KVStateViewProtocol <NSObject>

- (void)showInitialize;
- (void)showInfo:(id<KVStateViewInfoProtocol>)info;
- (id<KVStateViewInfoProtocol>)info;
- (KVViewState)state;

- (void)setEmptyDataView:(UIView * _Nullable)emptyDataView;
- (UIView * _Nullable)emptyDataView;

@end

NS_ASSUME_NONNULL_END
