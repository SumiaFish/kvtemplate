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

@interface HomeViewController ()
<KVToastViewProtocol>

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
    

    for (NSInteger i = 0; i<20; i++) {
        [[HomePresent new] kv_loadDataWithTableView:nil isRefresh:YES];
    }
    
//    [self.tableView refreshData:YES];
//    [self button];
    
    
//    AppNetworking.toast = [KVToast share];
//    AppNetworking.toastShowMode = AppNetworkingToastShowMode_All;
//    KVHttpTool *a = [KVHttpTool request:@"https://www.baidu.com"];
////    task = a;
//    a.failure(^(NSError * _Nullable error) {
//        NSLog(@"失败了");
//    })
//    .success(^(id  _Nullable responseObject) {
//        NSLog(@"成功了");
//    })
//    .send()
//    ;

}

- (void)kv_show:(NSString *)text {
    NSLog(@"%@", text);
}

- (void)clearAction {
//    [KVStorege clearCache:YES];
    [task resume];
    
//    AppNetworking.toast = [KVToast share];
//    AppNetworking.toastShowMode = AppNetworkingToastShowMode_All;
    KVHttpTool *a = [KVHttpTool request:@"https://www.baidu.com"];
    task = a;
    a.failure(^(NSError * _Nullable error) {
        NSLog(@"失败了");
    })
    .success(^(id  _Nullable responseObject) {
        NSLog(@"成功了");
    })
    .send()
    ;
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

        KVTableViewAdapter *adapter = [[KVTableViewAdapter alloc] init];
        adapter.renderCellBlock = ^UITableViewCell * _Nonnull(KVTableView * _Nonnull tableView, NSIndexPath * _Nonnull indexPath) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
            cell.textLabel.text = @(indexPath.row).stringValue;
            return cell;
        };
        
        HomePresent *present = [HomePresent new];
                
        _tableView = [AppTableView defaultTableViewWithPresent:present adapter:adapter toast:[KVToast share]];
        [self.view addSubview:_tableView];
        _tableView.frame = self.view.bounds;

        [_tableView registerCellClazz:@{@"cell": UITableViewCell.class}];
        
        
    }
    
    return _tableView;
}

@end
