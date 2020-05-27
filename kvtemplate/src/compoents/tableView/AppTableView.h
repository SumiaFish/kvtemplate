//
//  AppTableView.h
//  KVTableView
//
//  Created by kevin on 2020/5/13.
//  Copyright © 2020 kevin. All rights reserved.
//

#import "KVTableView.h"

NS_ASSUME_NONNULL_BEGIN

@interface AppTableView : KVTableView

+ (instancetype)defaultTableViewWithPresent:(id<KVTableViewPresentProtocol>)present adapter:(id<KVTableViewAdapterProtocol>)adapter toast:(id<KVToastViewProtocol>)toast;

@end

NS_ASSUME_NONNULL_END
