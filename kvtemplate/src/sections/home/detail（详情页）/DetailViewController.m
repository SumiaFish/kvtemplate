//
//  HomeViewController.m
//  KVTableView
//
//  Created by kevin on 2020/5/11.
//  Copyright © 2020 kevin. All rights reserved.
//

#import "DetailViewController.h"

#import "HomePresent.h"

#import "AppStateView.h"
#import "AppEmptyDataView.h"

@interface DetailViewController ()
<KVUIViewDisplayDelegate>

@property (strong, nonatomic) HomePresent *homePresent;

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) UIButton *button;

@end

@implementation DetailViewController

- (void)dealloc {
    kLog(@"%@ dealloc~", NSStringFromClass(self.class));
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Detail";
    
//
//    [self.tableView display:NO];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
////        [self.tableView removeFromSuperview];
//        [self.tableView display:YES animate:YES];
//        [self.tableView refreshData:YES];
//    });
    
//    [self.tableView refreshData:YES];
    
    [self.collectionView refreshData:YES];
    
//     [self.hdCollectionView refreshData:YES];

}

- (void)selecteIndex:(NSInteger)idx {
    NSLog(@"选中了: %ld", idx);
}

- (void)clearAction {

}

- (void)onView:(UIView *)view display:(BOOL)isDisplay animate:(BOOL)animate {
    if (view == _tableView) {
        [UIView animateWithDuration:animate ? 0.8 : 0 animations:^{
            view.alpha = isDisplay ? 1 : 0;
            CGRect frame = view.frame;
            frame.origin.x = isDisplay ? 0 : -self.view.bounds.size.width;
            view.frame = frame;
        }];
    }
}

- (FBLPromise *)loadTableViewData:(NSInteger)page isRefresh:(BOOL)isRefresh {
    __weak typeof(self) ws = self;
    [self.tableView showInfo:KVStateViewInfo.loaddingInfo];
    return [[[self.homePresent loadData:page isRefresh:isRefresh] then:^id _Nullable(id  _Nullable value) {
        [ws.tableView.adapter update:value];
        [ws.tableView showInfo:KVStateViewInfo.succInfo];
        [ws.tableView reloadEmptyView];
        return value;
    }] catch:^(NSError * _Nonnull error) {
        [ws.tableView showInfo:[KVStateViewInfo errorInfo:error]];
    }];
}

- (FBLPromise *)loadCollectionViewData:(NSInteger)page isRefresh:(BOOL)isRefresh {
    
    __weak typeof(self) ws = self;
    [self.collectionView showInfo:KVStateViewInfo.loaddingInfo];
    return [[[self.homePresent loadData:page isRefresh:isRefresh] then:^id _Nullable(id  _Nullable value) {
        [ws.collectionView.adapter update:value];
        [ws.collectionView showInfo:KVStateViewInfo.succInfo];
        [ws.collectionView reloadEmptyView];
        return value;
    }] catch:^(NSError * _Nonnull error) {
        [ws.collectionView showInfo:[KVStateViewInfo errorInfo:error]];
        //
        [[ws.homePresent loadCacheData:page isRefresh:isRefresh] then:^id _Nullable(id  _Nullable value) {
            [ws.collectionView.adapter update:value];
            [ws.collectionView reloadData];
            return value;
        }];
    }];
}

- (UIButton *)button {
    if (!_button) {
        _button = [UIButton buttonWithType:(UIButtonTypeSystem)];
        [self.view addSubview:_button];
        _button.frame = CGRectMake(0, 0, 100, 40);
        _button.center = self.view.center;
        [_button setTitle:@"clear" forState:0];
        [_button addTarget:self action:@selector(clearAction) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _button;
}

- (UITableView *)tableView {
    if (!_tableView) {

        __weak typeof(self) ws = self;
        
        HomePresent *present = self.homePresent;
        
        KVTableViewAdapter *adapter = [[KVTableViewAdapter alloc] init];
        
        adapter.onRenderSectionsBlock = ^NSInteger(UITableView<KVTableViewProtocol> * _Nonnull tableView) {
            return present.data.count;
        };
        
        adapter.onRenderHeaderBlock = ^UITableViewHeaderFooterView * _Nonnull(UITableView<KVTableViewProtocol> * _Nonnull tableView, NSInteger section) {
            UITableViewHeaderFooterView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"header"];
            if (!view.backgroundView) {
                view.backgroundView = UIView.new;
            }
            view.backgroundView.theme_backgroundColor = globalSectionHeaderBackgroundColorPicker;
            return view;
        };
        
        adapter.onRenderHeaderHeightBlock = ^CGFloat(UITableView<KVTableViewProtocol> * _Nonnull tableView, NSInteger section) {
          return 100;
        };
        
        adapter.onRenderRowsBlock = ^NSInteger(UITableView<KVTableViewProtocol> * _Nonnull tableView, NSInteger section) {
            return present.data[section].count;
        };
        
        adapter.onRenderCellBlock = ^UITableViewCell * _Nonnull(UITableView<KVTableViewProtocol> * _Nonnull tableView, NSIndexPath * _Nonnull indexPath) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
            cell.textLabel.text = @(indexPath.row).stringValue;
            cell.contentView.theme_backgroundColor = globalBackgroundColorPicker;
            cell.textLabel.theme_textColor = globalTextColorPicker;
            return cell;
        };
        
        adapter.onSelecteItemBlock = ^(UITableView<KVTableViewProtocol> * _Nonnull tableView, NSIndexPath * _Nonnull indexPath) {
            [ws selecteIndex: indexPath.row];
        };

        _tableView = [UITableView KVTableViewWithAdapter:adapter];
        _tableView.onRefreshBlock = ^FBLPromise<KVListAdapterInfo *> * _Nonnull(BOOL isRefresh, NSInteger nextPage, UITableView<KVTableViewProtocol> * _Nonnull tableView) {
            return [ws loadTableViewData:nextPage isRefresh:isRefresh];
        };
        _tableView.displayContext = self;
        [self.view addSubview:_tableView];
        _tableView.frame = self.view.bounds;

        [_tableView registerCellClazz:@{@"cell": UITableViewCell.class}];
        
        [_tableView registerHeaderFooterClazz:@{@"header": UITableViewHeaderFooterView.class}];
        
        AppStateView *stateView = [AppStateView viewWithKVTableView:(UITableView<KVTableViewProtocol> *)_tableView];
        [_tableView setStateView:stateView andMoveTo:AppDelegate.window];
        
        AppEmptyDataView *emptyView = [AppEmptyDataView view];
        emptyView.onDisplayEmptyViewBlock = ^KVEmptyDataInfo * _Nonnull{
            return present.data.count == 0 ? KVEmptyDataInfo.info : nil;
        };
        _tableView.emptyDataView = emptyView;
        
        _tableView.theme_backgroundColor = globalBackgroundColorPicker;
        
        if ([_tableView.mj_header isKindOfClass:MJRefreshNormalHeader.class]) {
            ((MJRefreshNormalHeader *)_tableView.mj_header).loadingView.theme_color = globalTextColorPicker;
            ((MJRefreshNormalHeader *)_tableView.mj_header).stateLabel.theme_textColor = globalTextColorPicker;
            ((MJRefreshNormalHeader *)_tableView.mj_header).lastUpdatedTimeLabel.theme_textColor = globalTextColorPicker;
        }
        if ([_tableView.mj_footer isKindOfClass:MJRefreshAutoNormalFooter.class]) {
            ((MJRefreshAutoNormalFooter *)_tableView.mj_footer).loadingView.theme_color = globalTextColorPicker;
            ((MJRefreshAutoNormalFooter *)_tableView.mj_footer).stateLabel.theme_textColor = globalTextColorPicker;
        }
        
    }
    
    return _tableView;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        
        __weak typeof(self) ws = self;
        
        HomePresent *present = self.homePresent;
        
        KVCollectionViewAdapter *adapter = [[KVCollectionViewAdapter alloc] init];
        
        adapter.onRenderSectionsBlock = ^NSInteger(UICollectionView<KVCollectionViewProtocol> * _Nonnull collectionView) {
            return present.data.count;
        };
        
        adapter.onRenderHeaderBlock = ^UICollectionReusableView * _Nullable(UICollectionView<KVCollectionViewProtocol> * _Nonnull collectionView, NSIndexPath * _Nonnull indexPath) {
            UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
            view.theme_backgroundColor = globalSectionHeaderBackgroundColorPicker;
            return view;
        };
        
        adapter.onRenderHeaderSizeBlock = ^CGSize(UICollectionView<KVCollectionViewProtocol> * _Nonnull collectionView, NSInteger section) {
            return CGSizeMake(collectionView.bounds.size.width, 100);
        };
        
        adapter.onRenderRowsBlock = ^NSInteger(UICollectionView<KVCollectionViewProtocol> * _Nonnull collectionView, NSInteger section) {
            return present.data[section].count;
        };
        
        adapter.onRenderCellBlock = ^UICollectionViewCell * _Nonnull(UICollectionView<KVCollectionViewProtocol> * _Nonnull collectionView, NSIndexPath * _Nonnull indexPath) {
            UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
            
            NSInteger textLabTag = 100000;
            UILabel *lable = (UILabel *)[cell.contentView viewWithTag:textLabTag];
            if (!lable) {
                lable = [[UILabel alloc] init];
                lable.tag = textLabTag;
                lable.frame = cell.contentView.bounds;
                lable.textAlignment = NSTextAlignmentCenter;
                lable.font = [UIFont systemFontOfSize:16];
                [cell.contentView addSubview:lable];
            }
            lable.text = @(indexPath.row).stringValue;
            cell.contentView.theme_backgroundColor = globalBackgroundColorPicker;
            lable.theme_textColor = globalTextColorPicker;
            return cell;
        };
        
        adapter.onRenderItemSizeBlock = ^CGSize(UICollectionView<KVCollectionViewProtocol> * _Nonnull collectionView, NSIndexPath * _Nonnull indexPath) {
            return CGSizeMake(collectionView.bounds.size.width/5, collectionView.bounds.size.width/5);
        };
        
        adapter.onSelecteItemBlock = ^(UICollectionView<KVCollectionViewProtocol> * _Nonnull collectionView, NSIndexPath * _Nonnull indexPath) {
            [ws selecteIndex: indexPath.row];
        };

        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.sectionInset = UIEdgeInsetsZero;
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.sectionHeadersPinToVisibleBounds = YES;
        
        _collectionView = [UICollectionView KVCollectionViewWithAdapter:adapter layout:layout];
        _collectionView.onRefreshBlock = ^FBLPromise<KVListAdapterInfo *> * _Nonnull(BOOL isRefresh, NSInteger nextPage, UICollectionView<KVCollectionViewProtocol> * _Nonnull collectionView) {
            return [ws loadCollectionViewData:nextPage isRefresh:isRefresh];
        };
        _collectionView.displayContext = self;
        [self.view addSubview:_collectionView];
        _collectionView.frame = self.view.bounds;

        [_collectionView registerCellClazz:@{@"cell": UICollectionViewCell.class}];
        
        [_collectionView registerHeaderFooterClazz:@{@"header": UICollectionReusableView.class} isHeader:YES];
        
        AppStateView *stateView = [AppStateView viewWithKVCollectionView:(UICollectionView<KVCollectionViewProtocol> *)_collectionView];
        [_collectionView setStateView:stateView andMoveTo:AppDelegate.window];
        
        AppEmptyDataView *emptyView = [AppEmptyDataView view];
        emptyView.onDisplayEmptyViewBlock = ^KVEmptyDataInfo * _Nonnull{
            return present.data.count == 0 ? KVEmptyDataInfo.info : nil;
        };
        _collectionView.emptyDataView = emptyView;
        
        _collectionView.theme_backgroundColor = globalBackgroundColorPicker;
        
        if ([_collectionView.mj_header isKindOfClass:MJRefreshNormalHeader.class]) {
            ((MJRefreshNormalHeader *)_collectionView.mj_header).loadingView.theme_color = globalTextColorPicker;
            ((MJRefreshNormalHeader *)_collectionView.mj_header).stateLabel.theme_textColor = globalTextColorPicker;
            ((MJRefreshNormalHeader *)_collectionView.mj_header).lastUpdatedTimeLabel.theme_textColor = globalTextColorPicker;
        }
        if ([_collectionView.mj_footer isKindOfClass:MJRefreshAutoNormalFooter.class]) {
            ((MJRefreshAutoNormalFooter *)_collectionView.mj_footer).loadingView.theme_color = globalTextColorPicker;
            ((MJRefreshAutoNormalFooter *)_collectionView.mj_footer).stateLabel.theme_textColor = globalTextColorPicker;
        }
        
    }
    return _collectionView;
}

- (HomePresent *)homePresent {
    if (!_homePresent) {
        _homePresent = [[HomePresent alloc] init];
    }
    return _homePresent;
}

@end
