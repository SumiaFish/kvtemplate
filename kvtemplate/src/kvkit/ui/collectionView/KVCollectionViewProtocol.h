//
//  KVCollectionViewProtocol.h
//  kvtemplate
//
//  Created by kevin on 2020/6/15.
//  Copyright © 2020 kevin. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

#import "KVListAdapterInfo.h"

NS_ASSUME_NONNULL_BEGIN

@protocol KVCollectionViewAdapterProtocol;
@protocol KVCollectionViewProtocol;

@protocol KVCollectionViewAdapterProtocol <UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>

@property (weak, nonatomic, nullable) id context;
@property (weak, nonatomic, nullable) UICollectionView<KVCollectionViewProtocol>* collectionView;

@property (copy, nonatomic, nullable) NSInteger (^ onRenderSectionsBlock) (UICollectionView<KVCollectionViewProtocol>* collectionView);

@property (copy, nonatomic, nullable) NSInteger (^ onRenderRowsBlock) (UICollectionView<KVCollectionViewProtocol>* collectionView, NSInteger section);

@property (copy, nonatomic, nullable) UICollectionReusableView* _Nullable (^ onRenderHeaderBlock) (UICollectionView<KVCollectionViewProtocol>* collectionView, NSIndexPath *indexPath);

@property (copy, nonatomic, nullable) UICollectionViewCell* (^ onRenderCellBlock) (UICollectionView<KVCollectionViewProtocol>* collectionView, NSIndexPath *indexPath);

@property (copy, nonatomic, nullable) CGSize (^ onRenderItemSizeBlock) (UICollectionView<KVCollectionViewProtocol>* collectionView, NSIndexPath *indexPath);

@property (copy, nonatomic, nullable) CGSize (^ onRenderHeaderSizeBlock) (UICollectionView<KVCollectionViewProtocol>* collectionView, NSInteger section);

@property (copy, nonatomic, nullable) void (^ onSelecteItemBlock) (UICollectionView<KVCollectionViewProtocol>* collectionView, NSIndexPath *indexPath);

- (instancetype)initWithContext:(id _Nullable)context;

- (void)update:(KVListAdapterInfo *)info;
- (void)updateWithData:(NSArray * __nullable)data page:(NSInteger)page hasMore:(BOOL)hasMore;
- (NSInteger)getOffsetPageWithIsRefresh:(BOOL)isRefresh;
- (NSInteger)page;
- (NSArray * __nullable)data;
- (BOOL)hasMore;

@end

@protocol KVCollectionViewProtocol <NSObject>

@property (copy, nonatomic) FBLPromise<KVListAdapterInfo *>* (^ onRefreshBlock) (BOOL isRefresh, NSInteger nextPage, UICollectionView<KVCollectionViewProtocol>* collectionView);

@property (strong, nonatomic, nullable) id<KVCollectionViewAdapterProtocol> adapter;

- (void)refreshData:(BOOL)isShowHeaderLoadding;

- (void)loadMoreData:(BOOL)isShowFooterLoadding;

@end

NS_ASSUME_NONNULL_END
