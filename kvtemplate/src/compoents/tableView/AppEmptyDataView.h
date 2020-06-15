//
//  AppEmptyDataView.h
//  kvtemplate
//
//  Created by kevin on 2020/6/15.
//  Copyright © 2020 kevin. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "KVEmptyDataView.h"

NS_ASSUME_NONNULL_BEGIN

@interface AppEmptyDataView : KVEmptyDataView
<KVEmptyDataViewProtocol>

+ (instancetype)view;

@end

NS_ASSUME_NONNULL_END
