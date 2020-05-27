//
//  AppTableView.m
//  KVTableView
//
//  Created by kevin on 2020/5/13.
//  Copyright © 2020 kevin. All rights reserved.
//

#import "AppTableView.h"

@implementation AppTableView

+ (instancetype)defaultTableViewWithPresent:(id<KVTableViewPresentProtocol>)present adapter:(id<KVTableViewAdapterProtocol>)adapter toast:(id<KVToastViewProtocol>)toast {
    AppTableView *tableView = [[AppTableView alloc] initWithFrame:CGRectZero style:(UITableViewStylePlain)];

    [tableView useDefaultHeader];
    [tableView useDefaultFooter];
    [tableView useDefaultStateView];
    
    tableView.adapter = adapter;

    tableView.present = present;
    
    tableView.toast = toast;
    
    return tableView;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.stateView.frame = self.bounds;
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

- (void)useDefaultStateView {
    if (!self.stateView) {
        self.stateView = [[NSBundle mainBundle] loadNibNamed:@"KVDefaultStateView" owner:nil options:nil].lastObject;
    }
}
@end
