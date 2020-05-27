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

static void* UIViewStateViewKey = &UIViewStateViewKey;

@interface UIView (KVState)
<KVStateViewProtocol>

/// 子视图负责维护 frame
@property (strong, nonatomic) UIView<KVStateViewProtocol> *stateView;

@end

NS_ASSUME_NONNULL_END
