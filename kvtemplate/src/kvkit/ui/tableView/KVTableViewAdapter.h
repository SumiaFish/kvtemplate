//
//  KVTableViewAdapter.h
//  KVTableView
//
//  Created by kevin on 2020/5/12.
//  Copyright © 2020 kevin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KVTableViewProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@class KVTableView;

typedef UITableViewCell* _Nonnull (^ KVTableViewRenderCellBlock) (KVTableView *tableView, NSIndexPath *indexPath);

@interface KVTableViewAdapter : NSObject
<KVTableViewAdapterProtocol>

@property (copy, nonatomic, nullable) KVTableViewRenderCellBlock renderCellBlock;

@end

NS_ASSUME_NONNULL_END
