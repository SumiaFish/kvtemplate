//
//  AppNetworking.h
//  KVTableView
//
//  Created by kevin on 2020/5/13.
//  Copyright © 2020 kevin. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "KVHttpTool.h"

#import "KVToastViewProtocol.h"

NS_ASSUME_NONNULL_BEGIN

#define AppNetworkErrCode_Succ (200)



typedef NS_ENUM(NSInteger, AppNetworkingToastShowMode) {
    AppNetworkingToastShowMode_Disable,
    AppNetworkingToastShowMode_OnSuccess = 1,
    AppNetworkingToastShowMode_OnFailed = 2,
    AppNetworkingToastShowMode_All = 3,
};

@interface NSError (AppNetwork)

@end

/** 请求封装 */
@interface AppNetworking : KVHttpTool
<KVHttpToolBusinessProtocol>

/** Toast 默认 nil */
@property (class, strong, nonatomic, nullable) id<KVToastViewProtocol> toast;
/** 单独设置 Toast 默认 nil */
@property (strong, nonatomic, nullable) id<KVToastViewProtocol> toast;
/** Toast何时显示; 默认 Disable */
@property (class, assign, nonatomic) AppNetworkingToastShowMode toastShowMode;
/** 单独设置Toast何时显示; 默认 Disable */
@property (assign, nonatomic) AppNetworkingToastShowMode toastShowMode;

@end

NS_ASSUME_NONNULL_END
