//
//  KVCollectionViewAdapter.m
//  kvtemplate
//
//  Created by kevin on 2020/6/15.
//  Copyright © 2020 kevin. All rights reserved.
//

#import "KVCollectionViewAdapter.h"

@interface KVCollectionViewAdapter ()

@property (strong, nonatomic) NSArray *data;
@property (assign, nonatomic) NSInteger page;
@property (assign, nonatomic) BOOL hasMore;

@end

@implementation KVCollectionViewAdapter

@synthesize context = _context;
@synthesize collectionView = _collectionView;
@synthesize onRenderSectionsBlock = _onRenderSectionsBlock;
@synthesize onRenderRowsBlock = _onRenderRowsBlock;
@synthesize onRenderHeaderBlock = _onRenderHeaderBlock;
@synthesize onRenderCellBlock = _onRenderCellBlock;
@synthesize onRenderItemSizeBlock = _onRenderItemSizeBlock;
@synthesize onRenderHeaderSizeBlock = _onRenderHeaderSizeBlock;
@synthesize onSelecteItemBlock = _onSelecteItemBlock;

- (instancetype)init {
    return [[self.class alloc] initWithContext:nil];
}

- (instancetype)initWithContext:(id _Nullable)context {
    if (self = [super init]) {
        self.context = context;
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    self.data = @[];
    self.page = 1;
    self.hasMore = NO;
}

- (void)update:(KVListAdapterInfo *)info {
    [self updateWithData:info.data page:info.page hasMore:info.hasMore];
}

- (void)updateWithData:(NSArray *)data page:(NSInteger)page hasMore:(BOOL)hasMore {
    self.data = data;
    if (hasMore) {
        self.page = page;
    }
    self.hasMore = hasMore;
}

- (NSInteger)getOffsetPageWithIsRefresh:(BOOL)isRefresh {
    if (isRefresh) {
        return 1;
    }
    return self.page+1;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return _onRenderSectionsBlock? _onRenderSectionsBlock(_collectionView): 1;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _onRenderRowsBlock? _onRenderRowsBlock(_collectionView, section): 0;
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return _onRenderCellBlock? _onRenderCellBlock(_collectionView, indexPath): nil;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        return _onRenderHeaderBlock? _onRenderHeaderBlock(_collectionView, indexPath): nil;
    }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return _onRenderItemSizeBlock? _onRenderItemSizeBlock(_collectionView, indexPath): CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return _onRenderHeaderSizeBlock? _onRenderHeaderSizeBlock(_collectionView, section): CGSizeZero;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    _onSelecteItemBlock? _onSelecteItemBlock(_collectionView, indexPath): nil;
}

@end
