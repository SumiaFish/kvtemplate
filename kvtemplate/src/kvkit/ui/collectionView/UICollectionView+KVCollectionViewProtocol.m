//
//  UICollectionView+KVCollectionViewProtocol.m
//  kvtemplate
//
//  Created by kevin on 2020/6/16.
//  Copyright © 2020 kevin. All rights reserved.
//

#import "UICollectionView+KVCollectionViewProtocol.h"

#import "KVCollectionView.h"

@implementation UICollectionView (KVCollectionViewProtocol)

@dynamic adapter;

@dynamic present;

@dynamic onReloadDataBlock;

+ (instancetype)KVCollectionViewWithPresent:(id<KVCollectionViewPresentProtocol>)present adapter:(id<KVCollectionViewAdapterProtocol>)adapter layout:(nonnull UICollectionViewFlowLayout *)layout {
    
    KVCollectionView *view = [[KVCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];

    [view useDefaultHeader];
    [view useDefaultFooter];
    
    view.adapter = adapter;
    view.present = present;
    
    return view;
}

- (void)setAdapter:(id<KVCollectionViewAdapterProtocol>)adapter {
    self.kv.adapter = adapter;
}

- (id<KVCollectionViewAdapterProtocol>)adapter {
    return self.kv.adapter;;
}

- (void)setPresent:(id<KVCollectionViewPresentProtocol>)present {
    self.kv.present = present;
}

- (id<KVCollectionViewPresentProtocol>)present {
    return self.kv.present;
}

- (void)setOnReloadDataBlock:(void (^)(UICollectionView<KVCollectionViewProtocol> * _Nonnull))onReloadDataBlock {
    self.kv.onReloadDataBlock = onReloadDataBlock;
}

- (void (^)(UICollectionView<KVCollectionViewProtocol> * _Nonnull))onReloadDataBlock {
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
        [self registerClass:obj forCellWithReuseIdentifier:key];
    }];
}

- (void)registerCellNib:(NSDictionary<NSString *, NSString *> *)cellNibs {
    [cellNibs enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
        [self registerNib:[UINib nibWithNibName:obj bundle:nil] forCellWithReuseIdentifier:key];
    }];
}

- (void)registerHeaderFooterClazz:(NSDictionary<NSString *,Class> *)clazz isHeader:(BOOL)isHeader {
    [clazz enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, Class  _Nonnull obj, BOOL * _Nonnull stop) {
        [self registerClass:obj forSupplementaryViewOfKind:isHeader? UICollectionElementKindSectionHeader: UICollectionElementKindSectionFooter withReuseIdentifier:key];
    }];
}

- (void)registerHeaderFooterNib:(NSDictionary<NSString *,NSString *> *)nibs isHeader:(BOOL)isHeader {
    [nibs enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
        [self registerNib:[UINib nibWithNibName:obj bundle:nil] forSupplementaryViewOfKind:isHeader? UICollectionElementKindSectionHeader: UICollectionElementKindSectionFooter withReuseIdentifier:key];
    }];
}

- (void)useDefaultHeader {
    self.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{}];
}

- (void)useDefaultFooter {
    self.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{}];
}

- (KVCollectionView *)kv {
    if ([self isKindOfClass:KVCollectionView.class]) {
        return ((KVCollectionView *)self);
    }
    return nil;
}

@end
