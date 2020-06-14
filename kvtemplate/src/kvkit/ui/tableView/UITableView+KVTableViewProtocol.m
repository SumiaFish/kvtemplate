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

@dynamic present;

@dynamic onReloadDataBlock;

+ (instancetype)KVTableViewWithPresent:(id<KVTableViewPresentProtocol>)present adapter:(id<KVTableViewAdapterProtocol>)adapter stateView:(UIView<KVStateViewProtocol> *)stateView {
    
    KVTableView *view = [[KVTableView alloc] initWithFrame:CGRectZero style:(UITableViewStylePlain)];
     
    view.tableFooterView = UIView.new;
    
    [view useDefaultHeader];
    [view useDefaultFooter];
    
    view.adapter = adapter;
    view.present = present;
    view.stateView = stateView;
    
    return view;
}

- (void)setAdapter:(id<KVTableViewAdapterProtocol>)adapter {
    self.kv.adapter = adapter;
}

- (id<KVTableViewAdapterProtocol>)adapter {
    return self.kv.adapter;;
}

- (void)setPresent:(id<KVTableViewPresentProtocol>)present {
    self.kv.present = present;
}

- (id<KVTableViewPresentProtocol>)present {
    return self.kv.present;
}

- (void)setOnReloadDataBlock:(void (^)(UITableView<KVTableViewProtocol> * _Nonnull))onReloadDataBlock {
    self.kv.onReloadDataBlock = onReloadDataBlock;
}

- (void (^)(UITableView<KVTableViewProtocol> * _Nonnull))onReloadDataBlock {
    return self.kv.onReloadDataBlock;
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

@implementation UITableView (ShowLoaddingMode)

@dynamic showLoaddingMode;

static void* UITableViewShowLoaddingModeKey;

- (void)setShowLoaddingMode:(KVTableViewShowLoaddingMode)showLoaddingMode {
    if (self.kv == nil) {
        return;
    }
    
    objc_setAssociatedObject(self, UITableViewShowLoaddingModeKey, [NSNumber numberWithInteger:showLoaddingMode], OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (KVTableViewShowLoaddingMode)showLoaddingMode {
    if (self.kv == nil) {
        return (KVTableViewShowLoaddingMode)0;
    }
    
    id res = objc_getAssociatedObject(self, UITableViewShowLoaddingModeKey);
    if ([res isKindOfClass:NSNumber.class]) {
        return ((NSNumber *)res).integerValue;
    }
    
    return (KVTableViewShowLoaddingMode)0;
}

- (void)showLoadding:(NSString *)text {
    if (self.kv == nil) {
        [super showLoadding:text];
        return;
    }
    
    if (self.showLoaddingMode == KVTableViewShowInfoMode_WhenEmptyContent) {
        // 没有cell 或 section 才显示
        if (self.adapter.data.count == 0) {
            // 不显示 loadding text
            [super showLoadding:@""];
        }
    } else {
        [super showLoadding:text];
    }
}

@end

