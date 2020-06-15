//
//  KVEmptyDataView.m
//  kvtemplate
//
//  Created by kevin on 2020/6/15.
//  Copyright © 2020 kevin. All rights reserved.
//

#import "KVEmptyDataView.h"

@implementation KVEmptyDataView

- (void)displayEmptyView:(BOOL)isDisplay {
    if (isDisplay) {
        [self.superview bringSubviewToFront:self];
        self.alpha = 1;
    } else {
        [self.superview sendSubviewToBack:self];
        self.alpha = 0;
    }
}

- (BOOL)isDisplayEmptyView {
    return self.alpha == 1;
}

- (void)reloadEmptyView:(KVEmptyDataInfo *)info {
    self.emptyDataInfo = info;
    [self onSetupView];
    //
    if (self.onDisplayBlock) {
        [self displayEmptyView:self.onDisplayBlock()];
    }
}

- (void)onSetupView {
    
}

@end
