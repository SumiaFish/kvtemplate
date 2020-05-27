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

@interface KVBaseStateView : UIView
<KVStateViewProtocol>

/// 当亲状态
@property (assign, nonatomic, readonly) KVViewState state;

/// 提示文本显示时长: 默认3s
@property (assign, nonatomic) NSNumber *textDuration;

#pragma mark - 子类重写

/// text: 显示文本；duration: 时长
- (void)onShowInfo:(NSString *)text duration:(NSTimeInterval)duration;

/// 隐藏 toast
- (void)onHideToast;

/// 隐藏 loadding
- (void)onDisplayLoadding:(BOOL)isDisplay;

@end

NS_ASSUME_NONNULL_END
