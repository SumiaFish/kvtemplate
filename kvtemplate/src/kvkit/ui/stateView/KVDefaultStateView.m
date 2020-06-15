//
//  KVDefaultStateView.m
//  KVTableView
//
//  Created by kevin on 2020/5/11.
//  Copyright © 2020 kevin. All rights reserved.
//

#import "KVDefaultStateView.h"

#import "NSObject+WeakObserve.h"

@interface KVDefaultStateView ()

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *hud;
@property (weak, nonatomic) IBOutlet UILabel *infoLab;
@property (weak, nonatomic) IBOutlet UILabel *bg;

@end

@implementation KVDefaultStateView

+ (instancetype)view {
    return [NSBundle.mainBundle loadNibNamed:@"KVDefaultStateView" owner:nil options:nil].lastObject;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.hud.hidesWhenStopped = YES;
    self.infoLab.text = @"";
    
    self.bg.layer.cornerRadius = 4;
    self.bg.clipsToBounds = YES;
    self.bg.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.5];
    
    [self.infoLab kv_addWeakObserve:self keyPath:@"alpha" options:(NSKeyValueObservingOptionNew) context:(__bridge void * _Nullable)(self) isCallBackInMain:YES];
}

- (void)kv_receiveWeakObserveValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (object == self.infoLab &&
        [keyPath isEqualToString:@"alpha"] &&
        context == (__bridge void * _Nullable)(self)) {
        self.bg.alpha = self.infoLab.alpha;
    } else {
        [super kv_receiveWeakObserveValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)onSetupView {
    [self onDisplayLoadding:self.state == KVViewState_Loadding];
    [self onShowInfo:self.info.title duration:3];
}

- (void)onShowInfo:(NSString *)text duration:(NSTimeInterval)duration {
    if (duration == 0) {
        self.infoLab.alpha = 0;
        return;
    }
    self.infoLab.text = text;
    [UIView animateWithDuration:0.1 animations:^{
        self.infoLab.alpha = 1;
    } completion:^(BOOL finished) {
        [self onHideToast];
    }];
}

- (void)onHideToast {
    self.infoLab.alpha = 0;
}

- (void)onDisplayLoadding:(BOOL)isDisplay {
    isDisplay? [self.hud startAnimating]: [self.hud stopAnimating];
}

@end
