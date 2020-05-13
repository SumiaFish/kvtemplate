//
//  KVTableViewProtocol.h
//  KVTableView
//
//  Created by kevin on 2020/5/11.
//  Copyright © 2020 kevin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "KVTableViewPresentResponse.h"

NS_ASSUME_NONNULL_BEGIN

@protocol KVTableViewProtocol;

typedef NS_ENUM(NSInteger, KVViewState) {
    KVViewState_Initialize = 0,
    KVViewState_Loadding,
    KVViewState_Success,
    KVViewState_Error,
};

@protocol KVTableViewPresentProtocol <NSObject>

- (FBLPromise *)kv_loadData:(id<KVTableViewProtocol>)view isRefresh:(BOOL)isRefresh;

@end

@protocol KVTableViewAdapterProtocol <UITableViewDataSource>

- (NSInteger)getOffsetPageWithIsRefresh:(BOOL)isRefresh;

- (void)updateWithData:(NSArray * __nullable)data page:(NSInteger)page hasMore:(BOOL)hasMore;

- (NSInteger)page;
- (NSArray * __nullable)data;
- (BOOL)hasMore;

- (void)setRows:(NSInteger)rows;
- (NSInteger)rows;

@end

@protocol KVTableViewProtocol <NSObject>

- (id<KVTableViewPresentProtocol> __nullable)present;
- (id<KVTableViewAdapterProtocol> __nullable)adapter;

@end

@protocol KVStateViewProtocol <NSObject>

- (void)showInitialize;
- (void)showLoadding;
- (void)showSuccess;
- (void)showError:(NSError * __nullable)error;

- (KVViewState)state;

@end

NS_ASSUME_NONNULL_END
