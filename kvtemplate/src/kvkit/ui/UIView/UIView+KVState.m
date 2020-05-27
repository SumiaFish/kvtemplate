//
//  UIView+KVState.m
//  kvtemplate
//
//  Created by kevin on 2020/5/22.
//  Copyright © 2020 kevin. All rights reserved.
//

#import <objc/runtime.h>
#import "UIView+KVState.h"

@implementation UIView (KVState)

- (void)setStateView:(UIView<KVStateViewProtocol> *)stateView {
    /// nil 则表示只删除
    [self.stateView removeFromSuperview];
    [stateView showInitialize];
    objc_setAssociatedObject(self, UIViewStateViewKey, stateView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView<KVStateViewProtocol> *)stateView {
    return objc_getAssociatedObject(self, UIViewStateViewKey);
}

- (void)showError:(NSError * _Nullable)error {
    [self.stateView showError:error];
}

- (void)showInfo:(nonnull NSString *)text {
    [self.stateView showInfo:text];
}

- (void)showInitialize {
    [self.stateView showInitialize];
}

- (void)showLoadding:(nonnull NSString *)text {
    [self.stateView showLoadding:text];
}

- (void)showSuccess:(nonnull NSString *)text {
    [self.stateView showSuccess:text];
}

- (KVViewState)state {
    return self.stateView.state;
}

@end
