//
//  AppTableViewStateView.m
//  kvtemplate
//
//  Created by kevin on 2020/5/27.
//  Copyright © 2020 kevin. All rights reserved.
//

#import "AppTableViewStateView.h"
#import "KVBaseStateView.h"

@interface AppTableViewStateView ()

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activity;

@property (weak, nonatomic, readwrite) UITableView<KVTableViewPresentProtocol> *tableView;

@end

@implementation AppTableViewStateView

+ (instancetype)viewWithKVTableView:(UITableView<KVTableViewPresentProtocol> *)tableView {
    AppTableViewStateView *view = [NSBundle.mainBundle loadNibNamed:NSStringFromClass(AppTableViewStateView.class) owner:nil options:nil].lastObject;
    view.tableView = tableView;
    return view;
}

- (void)replaceTableView:(UITableView<KVTableViewPresentProtocol> *)tableView {
    self.tableView = tableView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _activity.hidesWhenStopped = YES;
    
    _activity.theme_color = globalTextColorPicker;
}

- (void)showLoadding:(NSString *)text {
    if (self.showLoaddingMode == KVTableViewShowInfoMode_WhenEmptyContent) {
        // 没有cell 或 section 才显示
        if (self.tableView.adapter.data.count == 0) {
            // 不显示 loadding text
            [super showLoadding:@""];
        }
    } else {
        [super showLoadding:text];
    }
}

- (void)onShowInfo:(NSString *)text duration:(NSTimeInterval)duration {
    [super onShowInfo:text duration:duration];
    [KVToast.share show:text];
}

- (void)onHideToast {
    [super onHideToast];
}

- (void)onDisplayLoadding:(BOOL)isDisplay {
    [super onDisplayLoadding:isDisplay];
    isDisplay ? [_activity startAnimating] : [_activity stopAnimating];
}

@end
