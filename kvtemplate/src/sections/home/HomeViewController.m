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

@interface HomeViewController ()
<KVToastViewProtocol>

@property (strong, nonatomic) AppTableView *tableView;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Home";
    self.navigationController.navigationBar.hidden = NO;
    self.view.backgroundColor = UIColor.whiteColor;


    [self.tableView loadData:YES];
}

- (void)kv_show:(NSString *)text {
    NSLog(@"%@", text);
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
