//
//  HomeViewController.m
//  KVTableView
//
//  Created by kevin on 2020/5/11.
//  Copyright © 2020 kevin. All rights reserved.
//

#import "DetailViewController.h"

#import "HomePresent.h"

#import "AppTableViewStateView.h"

@interface DetailViewController ()
<KVUIViewDisplayDelegate, KVTableViewPresentProtocol>

@property (strong, nonatomic) HomePresent *homePresent;

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIButton *button;

@end

@implementation DetailViewController
{
    AppNetworking *task;
}

- (void)dealloc {
    kLog(@"%@ dealloc~", NSStringFromClass(self.class));
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Detail";
    
//
//    [self.tableView display:NO];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
////        [self.tableView removeFromSuperview];
//        [self.tableView display:YES animate:YES];
//        [self.tableView refreshData:YES];
//    });
    
    [self.tableView refreshData:YES];

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

- (FBLPromise *)kv_loadDataWithTableView:(id<KVTableViewProtocol>)tableView isRefresh:(BOOL)isRefresh {
    if (tableView == self.tableView) {
        return [[self.homePresent kv_loadDataWithTableView:tableView isRefresh:isRefresh] then:^id _Nullable(id  _Nullable value) {
            return value;
        }];
    }
    return nil;
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
            UIColor *color = section % 2 == 0? UIColor.redColor: UIColor.blueColor;
            view.backgroundView.backgroundColor = color;
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
            return cell;
        };
        
        adapter.onSelecteItemBlock = ^(UITableView<KVTableViewProtocol> * _Nonnull tableView, NSIndexPath * _Nonnull indexPath) {
            [ws selecteIndex: indexPath.row];
        };

        _tableView = [UITableView KVTableViewWithPresent:self adapter:adapter stateView:self.view.stateView];
        _tableView.displayContext = self;
        [self.view addSubview:_tableView];
        _tableView.frame = self.view.bounds;

        [_tableView registerCellClazz:@{@"cell": UITableViewCell.class}];
        
        [_tableView registerHeaderFooterClazz:@{@"header": UITableViewHeaderFooterView.class}];
        
        AppTableViewStateView *stateView = [AppTableViewStateView viewWithKVTableView:(UITableView<KVTableViewPresentProtocol> *)_tableView];
        [_tableView setStateView:stateView andMoveTo:self.view];
        
    }
    
    return _tableView;
}

- (HomePresent *)homePresent {
    if (!_homePresent) {
        _homePresent = [[HomePresent alloc] init];
    }
    return _homePresent;
}

@end
