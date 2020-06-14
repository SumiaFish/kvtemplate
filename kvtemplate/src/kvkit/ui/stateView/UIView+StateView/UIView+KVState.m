//
//  UIView+KVState.m
//  kvtemplate
//
//  Created by kevin on 2020/5/22.
//  Copyright © 2020 kevin. All rights reserved.
//

#import <objc/runtime.h>
#import "UIView+KVState.h"

#import "KVKitHeader.h"

#import "NSObject+WeakObserve.h"

#import <Aspects.h>

//static void InstallWillMoveToSuperviewListener(void (^listener)(id _self, UIView* newSuperview)) {
//    if (listener == NULL) {
//        KVKitLog(@"listener cannot be NULL.");
//        return;
//    }
//
//    Method willMoveToSuperview = class_getInstanceMethod([UIView class], @selector(willMoveToSuperview:));
//    IMP originalImp = method_getImplementation(willMoveToSuperview);
//
//    void (^block)(id, UIView*) = ^(id _self, UIView* newSuperview) {
//        originalImp();
//        listener(_self, newSuperview);
//    };
//
//    IMP newImp = imp_implementationWithBlock(block);
//    method_setImplementation(willMoveToSuperview, newImp);
//}

//static void InstallWillRemoveSubviewListener(void (^listener)(id _self, UIView* subview)) {
//    if (listener == NULL) {
//        KVKitLog(@"listener cannot be NULL.");
//        return;
//    }
//
//    Method willRemoveSubview = class_getInstanceMethod([UIView class], @selector(willRemoveSubview:));
//    IMP originalImp = method_getImplementation(willRemoveSubview);
//
//    void (^block)(id, UIView*) = ^(id _self, UIView* subview) {
//        [_self willChangeValueForKey:@"superview"];
//        originalImp(_self, @selector(willMoveToSuperview:), superview);
//        [_self didChangeValueForKey:@"superview"];
//
//        originalImp(_self, @selector(willRemoveSubview:), subview);
//        listener(_self, subview);
//    };
//
//    IMP newImp = imp_implementationWithBlock(block);
//    method_setImplementation(willRemoveSubview, newImp);
//}

@implementation UIView (KVState)

static void* UIViewStateViewKey = &UIViewStateViewKey;

static void* UIViewStateViewFrameKey = &UIViewStateViewFrameKey;

- (void)setStateView:(UIView<KVStateViewProtocol> *)stateView {
    [self setStateView:stateView andMoveTo:self];
}

- (UIView<KVStateViewProtocol> *)stateView {
    return objc_getAssociatedObject(self, UIViewStateViewKey);
}

- (void)setStateViewFrame:(CGRect)stateViewFrame {
    objc_setAssociatedObject(self, UIViewStateViewFrameKey, [NSValue valueWithCGRect:stateViewFrame], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGRect)stateViewFrame {
    return ((NSValue *)objc_getAssociatedObject(self, UIViewStateViewFrameKey)).CGRectValue;
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

- (void)setStateView:(UIView<KVStateViewProtocol> *)stateView andMoveTo:(UIView *)view {
    // nil 则表示只删除
    [self.stateView removeFromSuperview];
    [stateView showInitialize];
    objc_setAssociatedObject(self, UIViewStateViewKey, stateView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    //
    [self stateViewBindSuperView:view];
    //
    [self layoutStateView];
    // superView 是不能以kvo监听的??!!
    [self kv_addWeakObserve:self keyPath:@"frame" options:(NSKeyValueObservingOptionNew) context:(__bridge void * _Nullable)(self) isCallBackInMain:YES];
}

- (void)kv_receiveWeakObserveValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (object == self &&
        context == (__bridge void * _Nullable)(self)) {
        if ([keyPath isEqualToString:@"frame"]) {
            [self layoutStateView];
            return;
        }
    }
    
    [super kv_receiveWeakObserveValueForKeyPath:keyPath ofObject:object change:change context:context];
}

- (void)stateViewBindSuperView:(UIView *)view {
    
    if (self.stateView) {
        UIView *superView = view;
        if (self.stateView.superview != view ||
            ![superView.subviews containsObject:self.stateView]) {
            [self.stateView removeFromSuperview];
            [superView addSubview:self.stateView];
            //
            __weak typeof(self) ws = self;
            [self aspect_hookSelector:@selector(willRemoveSubview:) withOptions:(AspectPositionAfter) usingBlock:^{
                if (ws.stateView.superview) {
                    [ws.stateView removeFromSuperview];
                }
            } error:nil];
        }
    }
}

- (void)layoutStateView {
    if (CGRectEqualToRect(self.stateViewFrame, CGRectZero)) {
        self.stateView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    } else {
        self.stateView.frame = CGRectMake(0, 0, self.stateViewFrame.size.width, self.stateViewFrame.size.height);;
    }
}

- (BOOL)isControllerRootView {
    if ([self.nextResponder isKindOfClass:UIViewController.class]) {
        UIViewController *vc = (UIViewController *)self.nextResponder;
        if (vc.view == self) {
            return YES;
        }
    }
    
    return NO;
}

@end
