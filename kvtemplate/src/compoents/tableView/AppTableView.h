//
//  AppTableView.h
//  KVTableView
//
//  Created by kevin on 2020/5/13.
//  Copyright © 2020 kevin. All rights reserved.
//

#import "KVTableView.h"
#import "AppTableViewStateView.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, AppTableViewShowLoaddingMode) {
    AppTableViewShowInfoMode_WhenEmptyContent, /// 列表为空的时候才显示
    AppTableViewShowInfoMode_AnyTime, // 有就显示
};

@interface AppTableView : KVTableView

@property (assign, nonatomic) AppTableViewShowLoaddingMode showLoaddingMode;

+ (instancetype)defaultTableViewWithPresent:(id<KVTableViewPresentProtocol>)present adapter:(id<KVTableViewAdapterProtocol>)adapter stateView:(UIView<KVStateViewProtocol> * _Nullable)stateView;

@end

NS_ASSUME_NONNULL_END
