//
//  HomeViewController.m
//  KVTableView
//
//  Created by kevin on 2020/5/11.
//  Copyright © 2020 kevin. All rights reserved.
//

#import "HomeViewController.h"

#import "KVTableView.h"
#import "HomePresent.h"

#import "KVStorege.h"
#import "KVHttpTool+MISC.h"

@interface HomeTableViewAdapter : KVTableViewAdapter

@end

@interface HomeViewController ()
<KVUIViewDisplayDelegate>

@property (strong, nonatomic) AppTableView *tableView;
@property (strong, nonatomic) UIButton *button;

@end

@implementation HomeViewController
{
    AppNetworking *task;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Home";
    self.navigationController.navigationBar.hidden = NO;
    self.view.backgroundColor = UIColor.whiteColor;
    
    self.view.stateView = AppTableViewStateView.view;
    
//    [self.tableView display:NO];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView removeFromSuperview];
//        [self.tableView display:YES animate:YES];
    });
    
    [self.tableView refreshData:YES];
//    [self button];

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

- (KVTableView *)tableView {
    if (!_tableView) {

        HomeTableViewAdapter *adapter = [[HomeTableViewAdapter alloc] init];
        adapter.onRenderRowsBlock = ^NSInteger(UITableView<KVTableViewProtocol> * _Nonnull tableView, NSInteger section) {
            return tableView.adapter.data.count;
        };
        adapter.onRenderCellBlock = ^UITableViewCell * _Nonnull(UITableView<KVTableViewProtocol> * _Nonnull tableView, NSIndexPath * _Nonnull indexPath) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
            cell.textLabel.text = @(indexPath.row).stringValue;
            return cell;
        };
        
        HomePresent *present = [HomePresent new];
                
        _tableView = [AppTableView defaultTableViewWithPresent:present adapter:adapter stateView:self.view.stateView];
        _tableView.context = self;
        _tableView.displayContext = self;
        [self.view addSubview:_tableView];
        _tableView.frame = self.view.bounds;

        [_tableView registerCellClazz:@{@"cell": UITableViewCell.class}];
        
    }
    
    return _tableView;
}

@end

@implementation HomeTableViewAdapter

- (HomeViewController *)context {
    return [super context];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.context selecteIndex:indexPath.row];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
