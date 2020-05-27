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

NS_ASSUME_NONNULL_BEGIN

@protocol KVTableViewProtocol;
@protocol KVTableViewAdapterProtocol;
@protocol KVStateViewProtocol;
@protocol KVTableViewProtocol;

@protocol KVTableViewPresentProtocol <NSObject>

- (FBLPromise *)kv_loadDataWithTableView:(id<KVTableViewProtocol>)tableView isRefresh:(BOOL)isRefresh;

@end

@protocol KVTableViewAdapterProtocol <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) id context;
@property (weak, nonatomic) UITableView<KVTableViewProtocol>* tableView;

@property (copy, nonatomic) NSInteger (^ onRenderSectionsBlock) (UITableView<KVTableViewProtocol> *tableView);

@property (copy, nonatomic) NSInteger (^ onRenderRowsBlock) (UITableView<KVTableViewProtocol> *tableView, NSInteger section);

@property (copy, nonatomic) UITableViewCell* (^ onRenderCellBlock) (UITableView<KVTableViewProtocol> *tableView, NSIndexPath *indexPath);

@property (copy, nonatomic) CGFloat (^ onRenderRowHeightBlock) (UITableView<KVTableViewProtocol> *tableView, NSIndexPath *indexPath);

- (void)updateWithData:(NSArray * __nullable)data page:(NSInteger)page hasMore:(BOOL)hasMore;
- (NSInteger)getOffsetPageWithIsRefresh:(BOOL)isRefresh;
- (NSInteger)page;
- (NSArray * __nullable)data;
- (BOOL)hasMore;

@end

@protocol KVTableViewProtocol <NSObject>

@property (copy, nonatomic) void (^ onReloadDataBlock) (UITableView<KVTableViewProtocol> *tableView);

@property (strong, nonatomic) id<KVTableViewPresentProtocol> present;
@property (strong, nonatomic) id<KVTableViewAdapterProtocol> adapter;

@end



NS_ASSUME_NONNULL_END
