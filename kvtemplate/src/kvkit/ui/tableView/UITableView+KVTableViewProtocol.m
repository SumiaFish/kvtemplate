//
//  UITableView+KVTableViewProtocol.m
//  kvtemplate
//
//  Created by kevin on 2020/6/14.
//  Copyright © 2020 kevin. All rights reserved.
//

#import "UITableView+KVTableViewProtocol.h"

#import "KVTableView.h"

@implementation UITableView (KVTableViewProtocol)

@dynamic adapter;

+ (instancetype)KVTableViewWithAdapter:(id<KVTableViewAdapterProtocol> _Nullable)adapter {
    
    KVTableView *view = [[KVTableView alloc] initWithFrame:CGRectZero style:(UITableViewStylePlain)];
     
    view.tableFooterView = UIView.new;
    
    [view useDefaultHeader];
    [view useDefaultFooter];
    
    view.adapter = adapter;
    
    return view;
}

- (void)setAdapter:(id<KVTableViewAdapterProtocol>)adapter {
    self.kv.adapter = adapter;
}

- (id<KVTableViewAdapterProtocol>)adapter {
    return self.kv.adapter;;
}

- (void)setOnRefreshBlock:(FBLPromise<KVListAdapterInfo *> * _Nonnull (^)(BOOL, NSInteger, UITableView<KVTableViewProtocol> * _Nonnull))onRefreshBlock {
    self.kv.onRefreshBlock = onRefreshBlock;
}

- (FBLPromise<KVListAdapterInfo *> * _Nonnull (^)(BOOL, NSInteger, UITableView<KVTableViewProtocol> * _Nonnull))onRefreshBlock {
    return self.kv.onRefreshBlock;
}

- (void)refreshData:(BOOL)isShowHeaderLoadding {
    [self.kv refreshData:isShowHeaderLoadding];
}

- (void)loadMoreData:(BOOL)isShowFooterLoadding {
    [self.kv loadMoreData:isShowFooterLoadding];
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

- (void)registerHeaderFooterClazz:(NSDictionary<NSString *,Class> *)clazz {
    [clazz enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, Class  _Nonnull obj, BOOL * _Nonnull stop) {
        [self registerClass:obj forHeaderFooterViewReuseIdentifier:key];
    }];
}

- (void)registerHeaderFooterNib:(NSDictionary<NSString *,NSString *> *)nibs {
    [nibs enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
        [self registerNib:[UINib nibWithNibName:obj bundle:nil] forHeaderFooterViewReuseIdentifier:key];
    }];
}

- (void)useDefaultHeader {
    self.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{}];
}

- (void)useDefaultFooter {
    self.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{}];
}

- (KVTableView *)kv {
    if ([self isKindOfClass:KVTableView.class]) {
        return ((KVTableView *)self);
    }
    return nil;
}

@end

