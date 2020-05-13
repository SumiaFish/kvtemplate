//
//  KVDefaultStateView.m
//  KVTableView
//
//  Created by kevin on 2020/5/11.
//  Copyright © 2020 kevin. All rights reserved.
//

#import "KVDefaultStateView.h"

@interface KVDefaultStateView ()

@property (assign, nonatomic) KVViewState state;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *hud;
@property (weak, nonatomic) IBOutlet UILabel *infoLab;

@end

@implementation KVDefaultStateView

- (void)showInitialize {
    self.state = KVViewState_Initialize;
    [self.hud stopAnimating];
    self.infoLab.alpha = 0;
}

- (void)showLoadding {
    self.state = KVViewState_Loadding;
    [UIView animateWithDuration:0.1 animations:^{
        self.infoLab.alpha = 0;
    } completion:^(BOOL finished) {
        [self.hud startAnimating];
    }];
}

- (void)showSuccess {
    self.state = KVViewState_Success;
    [self.hud stopAnimating];
    self.infoLab.alpha = 0;
}

- (void)showError:(NSError *)error {
    self.state = KVViewState_Error;
    [self.hud stopAnimating];
    self.infoLab.text = error.localizedDescription;
    [UIView animateWithDuration:0.1 animations:^{
        self.infoLab.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
}

@end
