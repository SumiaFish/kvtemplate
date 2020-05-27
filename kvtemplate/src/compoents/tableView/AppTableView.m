//
//  AppTableView.m
//  KVTableView
//
//  Created by kevin on 2020/5/13.
//  Copyright © 2020 kevin. All rights reserved.
//

#import "AppTableView.h"

@implementation AppTableView

+ (instancetype)defaultTableViewWithPresent:(id<KVTableViewPresentProtocol>)present adapter:(id<KVTableViewAdapterProtocol>)adapter stateView:(UIView<KVStateViewProtocol> *)stateView {
    AppTableView *tableView = [[AppTableView alloc] initWithFrame:CGRectZero style:(UITableViewStylePlain)];

    [tableView useDefaultHeader];
    [tableView useDefaultFooter];

    tableView.stateView = stateView;
    
    tableView.adapter = adapter;

    tableView.present = present;
        
    return tableView;
}

- (void)showLoadding:(NSString *)text {
    if (self.showLoaddingMode == AppTableViewShowInfoMode_WhenEmptyContent) {
        /// 没有cell 或 section 才显示
        if (self.adapter.data.count == 0) {
            /// 不显示 loadding text
            [super showLoadding:@""];
        }
    } else {
        [super showLoadding:text];
    }
}

- (void)registerCellClazz:(NSDictionary<NSString *, Class> *)cellClazz {
    [cellClazz enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, Class  _Nonnull obj, BOOL * _Nonnull stop) {
        [self registerClass:obj forCellReuseIdentifier:key];
    }];
}

- (void)registerCellNib:(NSDictionary<NSString *, NSString *> *)cellNibs {
    [cellNibs enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
        [self registerNib:[UINib nibWithNibName:obj bundle:nil] forCellReuseIdentifier:key];
    }];
}

- (void)useDefaultHeader {
    self.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{}];
}

- (void)useDefaultFooter {
    self.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{}];
}

@end
