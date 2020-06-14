//
//  UIView+KVState.h
//  kvtemplate
//
//  Created by kevin on 2020/5/22.
//  Copyright © 2020 kevin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KVStateViewProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIView (KVState)
<KVStateViewProtocol>

/** stateViewFrame == CGRectZero 则和 self 一样的 frame */
@property (assign, nonatomic) CGRect stateViewFrame;

/** 状态视图，默认为空 */
@property (strong, nonatomic, nullable) UIView<KVStateViewProtocol> *stateView;

- (void)setStateView:(UIView<KVStateViewProtocol> * _Nullable)stateView andMoveTo:(UIView *)view;

@end

NS_ASSUME_NONNULL_END
