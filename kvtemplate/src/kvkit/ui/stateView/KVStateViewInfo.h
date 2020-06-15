//
//  KVStateViewInfo.h
//  kvtemplate
//
//  Created by kevin on 2020/6/15.
//  Copyright © 2020 kevin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

static NSString * const KVStateViewInfo_DefaultLoddingTitle = @"加载中...";

static NSString * const KVStateViewInfo_DefaultSuccTitle = @"加载成功";

typedef NS_ENUM(NSInteger, KVViewState) {
    KVViewState_Initialize = 0,
    KVViewState_Loadding,
    KVViewState_Success,
    KVViewState_Error,
};

@protocol KVStateViewInfoProtocol <NSObject>

- (KVViewState)state;

- (NSString *)title;

@end

@interface KVStateViewInfo : NSObject
<KVStateViewInfoProtocol>

@property (assign, nonatomic, readonly) KVViewState state;

@property (copy, nonatomic) NSString *title;

+ (instancetype)infoWithState:(KVViewState)state;

+ (instancetype)initializeInfo;

+ (instancetype)loaddingInfo;

+ (instancetype)succInfo;

+ (instancetype)errorInfo:(NSError *)error;

@end

NS_ASSUME_NONNULL_END
