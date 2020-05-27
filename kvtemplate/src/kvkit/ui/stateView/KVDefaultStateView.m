//
//  KVDefaultStateView.m
//  KVTableView
//
//  Created by kevin on 2020/5/11.
//  Copyright © 2020 kevin. All rights reserved.
//

#import "KVDefaultStateView.h"

@interface KVDefaultStateView ()

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *hud;
@property (weak, nonatomic) IBOutlet UILabel *infoLab;
@property (weak, nonatomic) IBOutlet UILabel *bg;

@end

@implementation KVDefaultStateView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.hud.hidesWhenStopped = YES;
    self.infoLab.text = @"";
    
    self.bg.layer.cornerRadius = 4;
    self.bg.clipsToBounds = YES;
    self.bg.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.5];
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
        
    }];
}

- (void)onHideToast {
    self.infoLab.alpha = 0;
}

- (void)onDisplayLoadding:(BOOL)isDisplay {
    isDisplay? [self.hud startAnimating]: [self.hud stopAnimating];
}

@end
