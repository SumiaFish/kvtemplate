//
//  KVTableViewProtocol.h
//  KVTableView
//
//  Created by kevin on 2020/5/11.
//  Copyright © 2020 kevin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import <FBLPromises/FBLPromises.h>

#import "KVListAdapterInfo.h"

NS_ASSUME_NONNULL_BEGIN

@protocol KVTableViewAdapterProtocol;
@protocol KVTableViewProtocol;

@protocol KVTableViewAdapterProtocol <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic, nullable) id context;
@property (weak, nonatomic, nullable) UITableView<KVTableViewProtocol>* tableView;

@property (copy, nonatomic, nullable) NSInteger (^ onRenderSectionsBlock) (UITableView<KVTableViewProtocol> *tableView);

@property (copy, nonatomic, nullable) NSInteger (^ onRenderRowsBlock) (UITableView<KVTableViewProtocol> *tableView, NSInteger section);

@property (copy, nonatomic, nullable) UITableViewHeaderFooterView* _Nullable (^ onRenderHeaderBlock) (UITableView<KVTableViewProtocol> *tableView, NSInteger section);

@property (copy, nonatomic, nullable) UITableViewCell* (^ onRenderCellBlock) (UITableView<KVTableViewProtocol> *tableView, NSIndexPath *indexPath);

@property (copy, nonatomic, nullable) CGFloat (^ onRenderRowHeightBlock) (UITableView<KVTableViewProtocol> *tableView, NSIndexPath *indexPath);

@property (copy, nonatomic, nullable) CGFloat (^ onRenderHeaderHeightBlock) (UITableView<KVTableViewProtocol> *tableView, NSInteger section);

@property (copy, nonatomic, nullable) void (^ onSelecteItemBlock) (UITableView<KVTableViewProtocol> *tableView, NSIndexPath *indexPath);

- (instancetype)initWithContext:(id _Nullable)context;

- (void)update:(KVListAdapterInfo *)info;
- (void)updateWithData:(NSArray * __nullable)data page:(NSInteger)page hasMore:(BOOL)hasMore;
- (NSInteger)getOffsetPageWithIsRefresh:(BOOL)isRefresh;
- (NSInteger)page;
- (NSArray * __nullable)data;
- (BOOL)hasMore;

@end

@protocol KVTableViewProtocol <NSObject>

@property (copy, nonatomic) FBLPromise<KVListAdapterInfo *>* (^ onRefreshBlock) (BOOL isRefresh, NSInteger nextPage, UITableView<KVTableViewProtocol>* tableView);

@property (strong, nonatomic, nullable) id<KVTableViewAdapterProtocol> adapter;

- (void)refreshData:(BOOL)isShowHeaderLoadding;

- (void)loadMoreData:(BOOL)isShowFooterLoadding;

@end



NS_ASSUME_NONNULL_END
