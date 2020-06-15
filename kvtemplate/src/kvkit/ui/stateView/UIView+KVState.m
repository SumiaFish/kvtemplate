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

static void* UIViewEmptyDataViewKey = &UIViewEmptyDataViewKey;

static void* UIViewEmptyDataViewFrameKey = &UIViewEmptyDataViewFrameKey;

static void* UIViewStateViewKey = &UIViewStateViewKey;

static void* UIViewStateViewFrameKey = &UIViewStateViewFrameKey;

- (void)setEmptyDataView:(UIView *)emptyDataView {
    // nil 则表示只删除
    [self.emptyDataView removeFromSuperview];
    [emptyDataView displayEmptyView:NO];
    objc_setAssociatedObject(self, UIViewEmptyDataViewKey, emptyDataView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (emptyDataView == nil) {
        return;
    }
    //
    [self emptyDataViewBindSuperView:self];
    //
    [self layoutEmptyDataView];
    // 监听frame
    [self kv_addWeakObserve:self keyPath:@"frame" options:(NSKeyValueObservingOptionNew) context:(__bridge void * _Nullable)(self) isCallBackInMain:YES];
}

- (UIView *)emptyDataView {
    return objc_getAssociatedObject(self, UIViewEmptyDataViewKey);
}

- (void)setEmptyDataViewFrame:(CGRect)emptyDataViewFrame {
    objc_setAssociatedObject(self, UIViewEmptyDataViewFrameKey, [NSValue valueWithCGRect:emptyDataViewFrame], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGRect)emptyDataViewFrame {
    return ((NSValue *)objc_getAssociatedObject(self, UIViewEmptyDataViewFrameKey)).CGRectValue;
}

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

- (void)displayEmptyView:(BOOL)isDisplay {
    [self.emptyDataView displayEmptyView:isDisplay];
}

- (BOOL)isDisplayEmptyView {
    return self.emptyDataView.isDisplayEmptyView;
}

- (void)reloadEmptyView:(KVEmptyDataInfo *)info {
    [self.emptyDataView reloadEmptyView:info];
}

- (KVEmptyDataInfo *)emptyDataInfo {
    return self.emptyDataView.emptyDataInfo;
}

- (void)showInitialize {
    [self.stateView showInitialize];
}

- (void)showInfo:(id<KVStateViewInfoProtocol>)info {
    [self.stateView showInfo:info];
}

- (id<KVStateViewInfoProtocol>)info {
    return self.stateView.info;
}

- (KVViewState)state {
    return self.stateView.state;
}

- (void)setStateView:(UIView<KVStateViewProtocol> *)stateView andMoveTo:(UIView *)view {
    // nil 则表示只删除
    [self.stateView removeFromSuperview];
    [stateView showInitialize];
    objc_setAssociatedObject(self, UIViewStateViewKey, stateView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (stateView == nil) {
        return;
    }
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
            [self layoutEmptyDataView];
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
            [self aspect_hookSelector:@selector(removeFromSuperview) withOptions:(AspectPositionBefore) usingBlock:^ (id<AspectInfo> info) {
                id instance = info.instance;
                if ([instance isKindOfClass:UIView.class]) {
                    UIView *view = instance;
                    if (view.stateView) {
                        [view showInitialize];
                        [view.stateView removeFromSuperview];
                    }
                }
            } error:nil];

        }
    }
}

- (void)emptyDataViewBindSuperView:(UIView *)view {
    
    if (self.emptyDataView) {
        UIView *superView = view;
        if (self.emptyDataView.superview != view ||
            ![superView.subviews containsObject:self.emptyDataView]) {
            [self.emptyDataView removeFromSuperview];
            [superView addSubview:self.emptyDataView];
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

- (void)layoutEmptyDataView {
    self.emptyDataView.frame = self.bounds;
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
