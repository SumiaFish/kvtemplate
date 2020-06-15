//
//  HomePresent.h
//  KVTableView
//
//  Created by kevin on 2020/5/11.
//  Copyright © 2020 kevin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KVTableViewProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface HomePresent : NSObject
<KVTableViewPresentProtocol, KVCollectionViewPresentProtocol>

@property (strong, nonatomic, readonly) NSArray<NSArray<NSNumber *> *> *data;

@end

NS_ASSUME_NONNULL_END
