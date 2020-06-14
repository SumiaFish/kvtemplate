//
//  KVStateViewProtocol.h
//  kvtemplate
//
//  Created by kevin on 2020/5/22.
//  Copyright © 2020 kevin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, KVViewState) {
    KVViewState_Initialize = 0,
    KVViewState_Loadding,
    KVViewState_Success,
    KVViewState_Error,
};

@protocol KVStateViewProtocol <NSObject>

- (void)showInitialize;
- (void)showLoadding:(NSString *)text;
- (void)showSuccess:(NSString *)text;
- (void)showError:(NSError * __nullable)error;
- (void)showInfo:(NSString *)text;

- (KVViewState)state;

@end

NS_ASSUME_NONNULL_END
