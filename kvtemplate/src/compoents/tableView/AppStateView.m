//
//  AppStateView.m
//  kvtemplate
//
//  Created by kevin on 2020/5/27.
//  Copyright © 2020 kevin. All rights reserved.
//

#import "AppStateView.h"
#import "KVBaseStateView.h"

@interface AppStateView ()

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activity;

@property (weak, nonatomic, readwrite) UITableView<KVTableViewProtocol> *tableView;

@property (weak, nonatomic, readwrite) UICollectionView<KVCollectionViewProtocol> *collectionView;

@end

@implementation AppStateView

+ (instancetype)viewWithKVTableView:(UITableView<KVTableViewProtocol> *)tableView {
    AppStateView *view = [NSBundle.mainBundle loadNibNamed:NSStringFromClass(AppStateView.class) owner:nil options:nil].lastObject;
    view.tableView = tableView;
    return view;
}

+ (instancetype)viewWithKVCollectionView:(UICollectionView<KVCollectionViewProtocol> *)collectionView {
    AppStateView *view = [NSBundle.mainBundle loadNibNamed:NSStringFromClass(AppStateView.class) owner:nil options:nil].lastObject;
    view.collectionView = collectionView;
    return view;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundColor = UIColor.clearColor;
    
    _activity.hidesWhenStopped = YES;
    
    _activity.theme_color = globalTextColorPicker;
}

- (void)onSetupView {
    [self onDisplayLoadding:self.state == KVViewState_Loadding];
    [self onShowInfo:self.info.title duration:3];
}

- (void)onShowInfo:(NSString *)text duration:(NSTimeInterval)duration {
    [KVToast.share show:text duration:duration];
}

- (void)onDisplayLoadding:(BOOL)isDisplay {
    if (isDisplay) {
        if (self.showLoaddingMode == KVTableViewShowInfoMode_WhenEmptyContent) {
            // 没有cell 才显示
            if (self.tableView) {
                if (self.tableView.adapter.data.count == 0) {
                    [self.tableView.emptyDataView displayEmptyView:NO];
                    [_activity startAnimating];
                    return;
                }
            }
            if (self.collectionView) {
                if (self.collectionView.adapter.data.count == 0) {
                    [self.collectionView.emptyDataView displayEmptyView:NO];
                    [_activity startAnimating];
                    return;
                }
            }
            
        }
    }
    
    [_activity stopAnimating];
}

@end
