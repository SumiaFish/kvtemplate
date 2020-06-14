//
//  AppNetworking.m
//  KVTableView
//
//  Created by kevin on 2020/5/13.
//  Copyright © 2020 kevin. All rights reserved.
//

#import "AppNetworking.h"

#import "NSObject+WeakObserve.h"

@implementation NSError (AppNetwork)

@end

@interface AppNetworking ()

@property (strong, nonatomic, readwrite) KVHttpToolInfos *info;

// 请求成功回调：默认 nil
@property (copy, nonatomic, readwrite) KVHttpTool* _Nullable (^ success) (void (^ _Nullable successBlock)(id _Nullable responseObject));

// 请求成功失败：默认 nil
@property (copy, nonatomic, readwrite) KVHttpTool* _Nullable (^ failure) (void (^ _Nullable failureBlock)(NSError * _Nullable error));

@end

static id<KVToastViewProtocol> AppNetworkingToast = nil;

static AppNetworkingToastShowMode AppNetworkingToastShowModeVar = AppNetworkingToastShowMode_Disable;

@implementation AppNetworking
{
    KVHttpTool* _Nullable (^ _success) (void (^ _Nullable successBlock)(id _Nullable responseObject));
    KVHttpTool* _Nullable (^ _failure) (void (^ _Nullable failureBlock)(NSError * _Nullable error));
    KVHttpToolInfos *_info;
}

@dynamic success;
@dynamic failure;
@dynamic info;


+ (void)setToast:(id<KVToastViewProtocol>)toast {
    AppNetworkingToast = toast;
}

+ (id<KVToastViewProtocol>)toast {
    return AppNetworkingToast;
}

- (id<KVToastViewProtocol>)toast {
    if (!_toast) {
        return self.class.toast;
    }
    return _toast;
}

+ (void)setToastShowMode:(AppNetworkingToastShowMode)toastShowMode {
    AppNetworkingToastShowModeVar = toastShowMode;
}

+ (AppNetworkingToastShowMode)toastShowMode {
    return AppNetworkingToastShowModeVar;
}

- (AppNetworkingToastShowMode)toastShowMode {
    if (_toastShowMode == AppNetworkingToastShowMode_Disable) {
        return self.class.toastShowMode;
    }
    return _toastShowMode;
}

- (void)setInfo:(KVHttpToolInfos *)info {
    _info = info;
}

- (KVHttpToolInfos *)info {
    return _info;
}

- (KVHttpTool * _Nullable (^)(void (^ _Nullable)(id _Nullable)))success {
    if (!_success) {
        __weak typeof(self) ws = self;
        _success = ^KVHttpTool * _Nullable(void (^ _Nonnull obj)(id responseObject)) {
            [ws lock];
            __strong typeof(ws) ss = ws;
            ws.info.successBlock = ^(id  _Nullable responseObject) {
                obj? obj(responseObject): nil;
                if (ss.toastShowMode == AppNetworkingToastShowMode_OnSuccess ||
                    ss.toastShowMode == AppNetworkingToastShowMode_All) {
                    [ss.toast show:RequestSucc];
                }
                ss.info.successBlock = nil;
                ss.info.failureBlock = nil;
                // self->info->failureBlock->ss 循环引用; ss.info.failureBlock = nil;打破循环; 都要打破; 因为走了成功就不会走失败的回调，这里就造成内存泄漏了
            };
            [ws unlock];
            return ws;
        };
    }
    return _success;
}

- (KVHttpTool * _Nullable (^)(void (^ _Nullable)(NSError * _Nullable)))failure {
    if (!_failure) {
        __weak typeof(self) ws = self;
        _failure = ^KVHttpTool * _Nullable(void (^ _Nonnull obj)(NSError * error)) {
            [ws lock];
            __strong typeof(ws) ss = ws;
            ws.info.failureBlock = ^(NSError * _Nullable error) {
                obj? obj(error): nil;
                if (ss.toastShowMode == AppNetworkingToastShowMode_OnFailed ||
                    ss.toastShowMode == AppNetworkingToastShowMode_All) {
                    [ss.toast show:error.localizedDescription];
                }
                ss.info.failureBlock = nil;
                ss.info.successBlock = nil;
                // self->info->failureBlock->ss 循环引用; ss.info.failureBlock = nil;打破循环; 都要打破; 因为走了成功就不会走失败的回调，这里就造成内存泄漏了
            };
            [ws unlock];
            return ws;
        };
    }
    return _failure;
}

- (NSError *)getBusinessErrorWithUrl:(NSString *)url responseObject:(id)responseObject {
    
    if (!responseObject) {
        return nil;
    }
    
    return nil;
    
//    NSInteger code = [responseObject[@"code"] integerValue];
//    if (code == 200) {
//        return nil;
//    }
//
//    NSString *msg = responseObject[@"msg"]? responseObject[@"msg"]: @"";
//    NSError *error = [NSError errorWithDomain:url code:code userInfo:@{NSLocalizedDescriptionKey: msg}];
//    return error;
    
}

@end
