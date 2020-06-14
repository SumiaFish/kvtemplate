//
//  UITableView+KVTableViewProtocol.h
//  kvtemplate
//
//  Created by kevin on 2020/6/14.
//  Copyright © 2020 kevin. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <MJRefresh/MJRefresh.h>

#import "KVTableViewProtocol.h"

#import "KVTableViewAdapter.h"

NS_ASSUME_NONNULL_BEGIN

@interface UITableView (KVTableViewProtocol)
<KVTableViewProtocol>

+ (instancetype)KVTableViewWithPresent:(id<KVTableViewPresentProtocol> _Nullable)present adapter:(id<KVTableViewAdapterProtocol> _Nullable)adapter stateView:(UIView<KVStateViewProtocol> * _Nullable)stateView;

- (void)registerCellNib:(NSDictionary<NSString *, NSString *> *)cellNibs;

- (void)registerCellClazz:(NSDictionary<NSString *, Class> *)cellClazz;

- (void)registerHeaderFooterNib:(NSDictionary<NSString *, NSString *> *)nibs;

- (void)registerHeaderFooterClazz:(NSDictionary<NSString *, Class> *)clazz;

- (void)useDefaultHeader;

- (void)useDefaultFooter;

@end

NS_ASSUME_NONNULL_END
