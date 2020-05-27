//
//  AppTableViewStateView.m
//  kvtemplate
//
//  Created by kevin on 2020/5/27.
//  Copyright © 2020 kevin. All rights reserved.
//

#import "AppTableViewStateView.h"
#import "KVBaseStateView.h"
#import "KVToast.h"

@interface AppTableViewStateView ()

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activity;

@end

@implementation AppTableViewStateView

+ (instancetype)view {
    return [NSBundle.mainBundle loadNibNamed:NSStringFromClass(AppTableViewStateView.class) owner:nil options:nil].lastObject;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _activity.hidesWhenStopped = YES;
}

- (void)onShowInfo:(NSString *)text duration:(NSTimeInterval)duration {
    [super onShowInfo:text duration:duration];
    [[KVToast share] kv_show:text];
}

- (void)onHideToast {
    [super onHideToast];
    /// 不管他
}

- (void)onDisplayLoadding:(BOOL)isDisplay {
    [super onDisplayLoadding:isDisplay];
    isDisplay ? [_activity startAnimating] : [_activity stopAnimating];
}

@end
