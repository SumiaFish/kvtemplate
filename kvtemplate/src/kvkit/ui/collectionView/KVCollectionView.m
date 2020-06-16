//
//  KVCollectionView.m
//  kvtemplate
//
//  Created by kevin on 2020/6/15.
//  Copyright © 2020 kevin. All rights reserved.
//

#import "KVCollectionView.h"

@implementation KVCollectionView

@synthesize adapter = _adapter;
@synthesize onRefreshBlock = _onRefreshBlock;

- (void)dealloc {
    KVKitLog(@"%@ dealloc~", NSStringFromClass(self.class));
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

- (void)setAdapter:(id<KVCollectionViewAdapterProtocol>)adapter {
    _adapter = adapter;
    adapter.collectionView = self;
    self.dataSource = adapter;
    self.delegate = adapter;
    
    [self initMJFooter];
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

// 注意防止被调用两次：header(no refreshing)  ->  -loadData  ->  beginRefreshing  ->  loadData;
- (void)loadData:(BOOL)isRefresh {
    __weak typeof(self) ws = self;
    
    if (self.onRefreshBlock) {
        [[self.onRefreshBlock(isRefresh, [self.adapter getOffsetPageWithIsRefresh:isRefresh], self) then:^id _Nullable(KVListAdapterInfo * _Nullable value) {
            [ws reloadData];
            return value;
            
        }] catch:^(NSError * _Nonnull error) {
            [ws displayRefreshCompoent:NO isRefresh:isRefresh];
            
        }];
        
    } else {
        [ws displayRefreshCompoent:NO isRefresh:isRefresh];
        
    }

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
