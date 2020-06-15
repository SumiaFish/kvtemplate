//
//  AppEmptyDataView.m
//  kvtemplate
//
//  Created by kevin on 2020/6/15.
//  Copyright © 2020 kevin. All rights reserved.
//

#import "AppEmptyDataView.h"

@interface AppEmptyDataView ()

@property (weak, nonatomic) IBOutlet UILabel *infoLab;

@end

@implementation AppEmptyDataView

+ (instancetype)view {
    return [NSBundle.mainBundle loadNibNamed:NSStringFromClass(AppEmptyDataView.class) owner:nil options:nil].lastObject;;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundColor = UIColor.clearColor;
    _infoLab.theme_textColor = globalTextColorPicker;
}

- (void)displayEmptyView:(BOOL)isDisplay {
    [UIView animateWithDuration:isDisplay ? 0.3 : 0 animations:^{
        [super displayEmptyView:isDisplay];
    }];
}

- (void)onSetupView {
    self.infoLab.text = self.emptyDataInfo.title;
}

@end
