//
//  KVToast.h
//  KVTableView
//
//  Created by kevin on 2020/5/12.
//  Copyright © 2020 kevin. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "KVToastViewProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface KVToast : NSObject
<KVToastViewProtocol>

+ (instancetype)share;

@end

NS_ASSUME_NONNULL_END
