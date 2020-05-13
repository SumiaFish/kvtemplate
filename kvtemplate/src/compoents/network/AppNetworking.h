//
//  AppNetworking.h
//  KVTableView
//
//  Created by kevin on 2020/5/13.
//  Copyright © 2020 kevin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define AppNetworkErrCode_Succ (200)

@interface NSError (AppNetwork)

@end

@interface AppNetworking : NSObject
<KVHttpToolBusinessProtocol>

@end

NS_ASSUME_NONNULL_END
