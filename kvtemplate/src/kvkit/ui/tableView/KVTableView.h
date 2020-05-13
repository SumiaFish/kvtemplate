//
//  KVTableView.h
//  KVTableView
//
//  Created by kevin on 2020/5/11.
//  Copyright © 2020 kevin. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <MJRefresh/MJRefresh.h>

#import "KVToastViewProtocol.h"

#import "KVTableViewProtocol.h"

#import "KVDefaultStateView.h"
#import "KVTableViewAdapter.h"

NS_ASSUME_NONNULL_BEGIN

@class KVTableView;

typedef void (^ KVTableViewLayoutStateViewBlock) (void);

@interface KVTableView : UITableView
<KVTableViewProtocol>

@property (strong, nonatomic, nullable) id<KVTableViewPresentProtocol> present;
@property (strong, nonatomic, nullable) id<KVTableViewAdapterProtocol> adapter;

@property (copy, nonatomic, nullable) KVTableViewLayoutStateViewBlock layoutStateViewBlock;
@property (strong, nonatomic, nullable) UIView<KVStateViewProtocol> *stateView;
@property (weak, nonatomic, nullable) id<KVToastViewProtocol> toast;

- (void)loadData:(BOOL)isRefresh;

@end

@interface KVTableView (Factory)

+ (instancetype)defaultTableViewWithPresent:(id<KVTableViewPresentProtocol> __nullable)present adapter:(id<KVTableViewAdapterProtocol> __nullable)adapter toast:(id<KVToastViewProtocol> __nullable)toast;

- (void)registerCellNib:(NSDictionary<NSString *, NSString *> *)cellNibs;

- (void)registerCellClazz:(NSDictionary<NSString *, Class> *)cellClazz;

- (void)useDefaultHeader;

- (void)useDefaultFooter;

- (void)useDefaultStateView;

@end

NS_ASSUME_NONNULL_END
