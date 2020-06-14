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

/** stateView loadding显示配置 */
typedef NS_ENUM(NSInteger, KVTableViewShowLoaddingMode) {
    /** 加载中且当列表为空的时候才显示 */
    KVTableViewShowInfoMode_WhenEmptyContent,
    /** 加载中就显示 */
    KVTableViewShowInfoMode_AnyTime,
};

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

@interface UITableView (ShowLoaddingMode)

@property (assign, nonatomic) KVTableViewShowLoaddingMode showLoaddingMode;

@end

NS_ASSUME_NONNULL_END
