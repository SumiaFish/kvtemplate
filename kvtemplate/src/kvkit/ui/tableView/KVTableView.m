//
//  KVTableView.m
//  KVTableView
//
//  Created by kevin on 2020/5/11.
//  Copyright © 2020 kevin. All rights reserved.
//

#import "KVTableView.h"
#import <objc/runtime.h>

@interface KVTableView ()

@end

@implementation KVTableView

@synthesize present = _present;
@synthesize adapter = _adapter;
@synthesize onReloadDataBlock = _onReloadDataBlock;

- (instancetype)init {
    if (self = [super init]) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    if (self = [super initWithFrame:frame style:style]) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    self.tableFooterView = UIView.new;
}

- (void)setMj_header:(MJRefreshHeader *)mj_header {
    __weak typeof(self) ws = self;
    mj_header.refreshingBlock = ^{
        [ws loadData:YES];
    };
    
    [super setMj_header:mj_header];
}

- (void)setMj_footer:(MJRefreshFooter *)mj_footer {
    __weak typeof(self) ws = self;
    mj_footer.refreshingBlock = ^{
        [ws loadData:NO];
    };
    
    [super setMj_footer:mj_footer];
    
    [self initMJFooter];
}

- (void)initMJFooter {
    [self.mj_footer endRefreshingWithNoMoreData];
    self.mj_footer.hidden = self.adapter.data.count == 0;
}

- (void)setAdapter:(id<KVTableViewAdapterProtocol>)adapter {
    _adapter = adapter;
    adapter.tableView = self;
    adapter.context = self.context;
    self.dataSource = adapter;
    self.delegate = adapter;
    
    [self initMJFooter];
}

- (void)setContext:(id)context {
    [super setContext:context];
    self.adapter.context = context;
}

- (void)refreshData:(BOOL)isShowHeaderLoadding {
    BOOL isRefresh = YES;
    if (isShowHeaderLoadding) {
        [self displayRefreshCompoent:isShowHeaderLoadding isRefresh:isRefresh];
    } else {
        [self loadData:isRefresh];
    }
}

- (void)loadMoreData:(BOOL)isShowFooterLoadding {
    BOOL isRefresh = NO;
    if (isShowFooterLoadding) {
        [self displayRefreshCompoent:isShowFooterLoadding isRefresh:isRefresh];
    } else {
        [self loadData:isRefresh];
    }
}

/// 注意防止被调用两次：header(no refreshing)  ->  -loadData  ->  beginRefreshing  ->  loadData;
- (void)loadData:(BOOL)isRefresh {
    
    [self showLoadding:@"加载中"];
        
    [[[[self.present kv_loadDataWithTableView:self isRefresh:isRefresh] then:^id _Nullable(id  _Nullable value) {

        dispatch_async(dispatch_get_main_queue(), ^{
            [self showSuccess:@"加载成功"];
        });
        
        if (self.onReloadDataBlock) {
            self.onReloadDataBlock(self);
        } else {
            [self reloadData];
        }

        return value;
        
    }] catch:^(NSError * _Nonnull error) {
        [self showError:error];
        
    }] always:^{
        [self displayRefreshCompoent:NO isRefresh:isRefresh];
        
    }];
}

- (void)displayRefreshCompoent:(BOOL)isShow isRefresh:(BOOL)isRefresh {
    if (isShow) {
        if (isRefresh) {
            !self.mj_header.isRefreshing ? [self.mj_header beginRefreshing] : nil;
        } else {
            !self.mj_footer.isRefreshing ? [self.mj_footer beginRefreshing] : nil;
        }
        
    } else {
        [self.mj_header endRefreshing];
        [self.mj_footer endRefreshing];
        
        self.mj_footer.hidden = self.adapter.data.count == 0;
        if (self.adapter.hasMore) {
            [self.mj_footer resetNoMoreData];
        } else {
            [self.mj_footer endRefreshingWithNoMoreData];
        }
    }
}

@end

@implementation KVTableView (Factory)

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

@end
