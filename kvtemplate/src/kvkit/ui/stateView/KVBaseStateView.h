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
// 这里的方法最好不要重写
<KVStateViewProtocol>

/** 当前状态 */
@property (assign, nonatomic, readonly) KVViewState state;

/** 提示文本显示时长: 默认3s */
@property (assign, nonatomic) NSNumber *textDuration;

/** 阻止交互配置 */
@property (assign, nonatomic) KVBaseStateViewPreventMode preventMode;

#pragma mark - 子类重写，但是要调用super

/** text: 显示文本；duration: 时长 */
- (void)onShowInfo:(NSString *)text duration:(NSTimeInterval)duration;

/** 隐藏 toast */
- (void)onHideToast;

/** 隐藏 loadding */
- (void)onDisplayLoadding:(BOOL)isDisplay;

@end

NS_ASSUME_NONNULL_END
