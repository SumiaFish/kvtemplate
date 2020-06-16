//
//  UICollectionView+KVCollectionViewProtocol.h
//  kvtemplate
//
//  Created by kevin on 2020/6/16.
//  Copyright © 2020 kevin. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <MJRefresh/MJRefresh.h>

#import "KVCollectionViewProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface UICollectionView (KVCollectionViewProtocol)
<KVCollectionViewProtocol>

+ (instancetype)KVCollectionViewWithAdapter:(id<KVCollectionViewAdapterProtocol> _Nullable)adapter layout:(UICollectionViewFlowLayout *)layout;

- (void)registerCellNib:(NSDictionary<NSString *, NSString *> *)cellNibs;

- (void)registerCellClazz:(NSDictionary<NSString *, Class> *)cellClazz;

- (void)registerHeaderFooterNib:(NSDictionary<NSString *, NSString *> *)nibs isHeader:(BOOL)isHeader;

- (void)registerHeaderFooterClazz:(NSDictionary<NSString *, Class> *)clazz isHeader:(BOOL)isHeader;

- (void)useDefaultHeader;

- (void)useDefaultFooter;

@end

NS_ASSUME_NONNULL_END
