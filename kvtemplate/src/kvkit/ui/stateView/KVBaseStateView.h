//
//  KVBaseStateView.h
//  kvtemplate
//
//  Created by kevin on 2020/5/22.
//  Copyright © 2020 kevin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KVStateViewProtocol.h"

NS_ASSUME_NONNULL_BEGIN

/** 阻止交互 */
typedef NS_ENUM(NSInteger, KVBaseStateViewPreventMode) {
    /** 不是loadding的时候都可以响应交互 */
    KVBaseStateViewPreventMode_WhioutLoadding = 0,
    /** stateView显示的时候都不可以响应交互 */
    KVBaseStateViewPreventMode_WhenDisplay = 1,
};

/** stateView 基类 */
@interface KVBaseStateView : UIView
<KVStateViewProtocol>

@property (strong, nonatomic) id<KVStateViewInfoProtocol> info;

/** 阻止交互配置 */
@property (assign, nonatomic) KVBaseStateViewPreventMode preventMode;

#pragma mark - 子类重写

- (void)onSetupView;

@end

NS_ASSUME_NONNULL_END
