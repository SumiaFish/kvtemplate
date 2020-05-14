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
    __weak typeof(self) ws = self;
    self.layoutStateViewBlock = ^{
        if (ws.stateView) {
            ws.stateView.frame = ws.bounds;
        }
    };
    
    self.tableFooterView = UIView.new;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.stateView) {
        self.layoutStateViewBlock? self.layoutStateViewBlock(): nil;
    }
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
    
    [mj_footer endRefreshingWithNoMoreData];
    mj_footer.hidden = self.adapter.rows == 0;
    [super setMj_footer:mj_footer];
}

- (void)setStateView:(UIView<KVStateViewProtocol> *)stateView {
    [_stateView removeFromSuperview];
    _stateView = stateView;
    
    [stateView showInitialize];
    stateView? [self addSubview:stateView]: nil;
}

- (void)setAdapter:(id<KVTableViewAdapterProtocol>)adapter {
    _adapter = adapter;
    self.dataSource = adapter;
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
    
    [self showLoaddingState];
        
    [[[[self.present kv_loadDataWithTableView:self isRefresh:isRefresh] then:^id _Nullable(id  _Nullable value) {

        dispatch_async(dispatch_get_main_queue(), ^{
            [self showSuccessState];
        });
        
        if (!isRefresh) {
            NSInteger r1 = self.adapter.rows;
            NSInteger r2 = self.adapter.data.count;
            
            NSMutableArray<NSIndexPath *> *ips = [NSMutableArray array];
            for (NSInteger i = 0; i<r2-r1; i++) {
                NSIndexPath *ip = [NSIndexPath indexPathForRow:r1+(r2>r1? i: -i) inSection:0];
                [ips addObject:ip];
            }
            
            self.adapter.rows = r2;
            if (ips.count) {
                [UIView performWithoutAnimation:^{
                    [self insertRowsAtIndexPaths:ips withRowAnimation:(UITableViewRowAnimationNone)];
                }];
            } else {
                [self reloadData];
            }
            
        } else {
            self.adapter.rows = self.adapter.data.count;
            [self reloadData];
            
        }

        return value;
        
    }] catch:^(NSError * _Nonnull error) {
        [self showErrorState:error];
        [self.toast kv_show:error.localizedDescription];
        
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
        
        self.mj_footer.hidden = self.adapter.rows == 0;
        if (self.adapter.hasMore) {
            [self.mj_footer resetNoMoreData];
        } else {
            [self.mj_footer endRefreshingWithNoMoreData];
        }
    }
}

- (void)showLoaddingState {
    if (self.adapter.rows == 0) {
        self.stateView.hidden = NO;
        [self.stateView showLoadding];
    }
}

- (void)showSuccessState {
    self.stateView.hidden = YES;
    [self.stateView showSuccess];
}

- (void)showErrorState:(NSError *)error {
    if (self.adapter.rows == 0) {
        self.stateView.hidden = NO;
        [self.stateView showError:error];
    }
}

@end

@implementation KVTableView (Factory)

+ (instancetype)defaultTableViewWithPresent:(id<KVTableViewPresentProtocol>)present adapter:(id<KVTableViewAdapterProtocol>)adapter toast:(id<KVToastViewProtocol>)toast {
    KVTableView *tableView = [[KVTableView alloc] initWithFrame:CGRectZero style:(UITableViewStylePlain)];

    [tableView useDefaultHeader];
    [tableView useDefaultFooter];
    [tableView useDefaultStateView];
    
    tableView.adapter = adapter;

    tableView.present = present;
    
    tableView.toast = toast;
    
    return tableView;
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
