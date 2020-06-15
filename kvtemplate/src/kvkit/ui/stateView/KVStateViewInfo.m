//
//  KVStateViewInfo.m
//  kvtemplate
//
//  Created by kevin on 2020/6/15.
//  Copyright © 2020 kevin. All rights reserved.
//

#import "KVStateViewInfo.h"

@interface KVStateViewInfo ()

@property (assign, nonatomic, readwrite) KVViewState state;

@end

@implementation KVStateViewInfo

+ (instancetype)infoWithState:(KVViewState)state {
    KVStateViewInfo *info = [[KVStateViewInfo alloc] init];
    info.state = state;
    return info;
}

+ (instancetype)initializeInfo {
    KVStateViewInfo *info = [KVStateViewInfo infoWithState:(KVViewState_Initialize)];
    info.title = @"";
    return info;
}

+ (instancetype)loaddingInfo {
    KVStateViewInfo *info = [KVStateViewInfo infoWithState:(KVViewState_Loadding)];
    info.title = KVStateViewInfo_DefaultLoddingTitle;
    return info;
}

+ (instancetype)succInfo {
    KVStateViewInfo *info = [KVStateViewInfo infoWithState:(KVViewState_Success)];
    info.title = KVStateViewInfo_DefaultSuccTitle;
    return info;
}

+ (instancetype)errorInfo:(NSError *)error {
    KVStateViewInfo *info = [KVStateViewInfo infoWithState:(KVViewState_Error)];
    info.title = error.localizedDescription;
    return info;
}

@end
