//
//  KVBaseStateView.m
//  kvtemplate
//
//  Created by kevin on 2020/5/22.
//  Copyright © 2020 kevin. All rights reserved.
//

#import "KVBaseStateView.h"

@interface KVBaseStateView ()
{
    NSTimeInterval _dismissTime;
}

@property (assign, nonatomic, readwrite) KVViewState state;
@property (strong, nonatomic) CADisplayLink *displayLink;

@end

@implementation KVBaseStateView

- (void)showInitialize {
    self.state = KVViewState_Initialize;
    [self onShowInfo:@"" duration:0];
    [self onDisplayLoadding:NO];
    [self.superview sendSubviewToBack:self];
}

- (void)showLoadding:(NSString *)text {
    [self showInitialize];
    self.state = KVViewState_Loadding;
    [self onDisplayLoadding:YES];
    [self showInfo:text];
}

- (void)showSuccess:(NSString *)text {
    [self showInitialize];
    self.state = KVViewState_Success;
    [self showInfo:text];
}

- (void)showError:(NSError *)error {
    [self showInitialize];
    self.state = KVViewState_Error;
    [self showInfo:error.localizedDescription];
}

- (void)showInfo:(NSString *)text {
    if (!text.length) {
        KVKitLog(@"text.length == 0");
        return;
    }
    NSTimeInterval duration = self.textDuration? self.textDuration.floatValue: 3;
    _dismissTime = NSDate.date.timeIntervalSince1970 + duration;
    [self onShowInfo:text duration:duration];
}

#pragma mark - 子类重写

- (void)onShowInfo:(NSString *)text duration:(NSTimeInterval)duration {
    
}

- (void)onHideToast {
    
}

- (void)onDisplayLoadding:(BOOL)isDisplay {
    
}

#pragma mark - Private

- (void)displayLinkRun {
    if (_dismissTime == 0) {
        return;
    }
    
    if ([NSDate date].timeIntervalSince1970 >= _dismissTime) {
        [self onHideToast];
    }
}

- (CADisplayLink *)displayLink {
    if (!_displayLink) {
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkRun)];
        [_displayLink addToRunLoop:NSRunLoop.currentRunLoop forMode:NSRunLoopCommonModes];
        if (@available (iOS 10.0, *)) {
            _displayLink.preferredFramesPerSecond = 4;
        } else {
            _displayLink.frameInterval = 4;
        }
    }
    return _displayLink;
}

@end
