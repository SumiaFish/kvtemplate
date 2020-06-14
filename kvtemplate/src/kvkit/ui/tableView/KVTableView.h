//
//  KVTableView.h
//  KVTableView
//
//  Created by kevin on 2020/5/11.
//  Copyright © 2020 kevin. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <MJRefresh/MJRefresh.h>

#import "UIView+KVState.h"
#import "UIView+Context.h"

#import "KVTableViewProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface KVTableView : UITableView
<KVTableViewProtocol>

@end

NS_ASSUME_NONNULL_END
