//
//  AppStateView.h
//  kvtemplate
//
//  Created by kevin on 2020/5/27.
//  Copyright © 2020 kevin. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "KVBaseStateView.h"

NS_ASSUME_NONNULL_BEGIN

/** stateView loadding显示配置 */
typedef NS_ENUM(NSInteger, KVTableViewShowLoaddingMode) {
    /** 加载中且当列表为空的时候才显示 */
    KVTableViewShowInfoMode_WhenEmptyContent,
    /** 加载中就显示 */
    KVTableViewShowInfoMode_AnyTime,
};

@interface AppStateView : KVBaseStateView

@property (assign, nonatomic) KVTableViewShowLoaddingMode showLoaddingMode;

@property (weak, nonatomic, readonly) UITableView<KVTableViewProtocol> *tableView;

@property (weak, nonatomic, readonly) UICollectionView<KVCollectionViewProtocol> *collectionView;

+ (instancetype)viewWithKVTableView:(UITableView<KVTableViewProtocol> *)tableView;

+ (instancetype)viewWithKVCollectionView:(UICollectionView<KVCollectionViewProtocol> *)collectionView;

@end

NS_ASSUME_NONNULL_END
