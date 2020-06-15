//
//  KVToast.h
//  KVTableView
//
//  Created by kevin on 2020/5/12.
//  Copyright © 2020 kevin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Toast/UIView+Toast.h>

#import "KVToastViewProtocol.h"

NS_ASSUME_NONNULL_BEGIN

/** toast 配置 */
@interface KVToastConf : NSObject

@property (strong, nonatomic) CSToastStyle *style;
@property (assign, nonatomic) NSTimeInterval duration;
@property (assign, nonatomic) CGPoint screenPoint;
@property (copy, nonatomic, nullable) void (^ onComplete) (BOOL didTap);

@end

/** toast 弹窗 */
@interface KVToast : NSObject
<KVToastViewProtocol>

@property (strong, nonatomic) KVToastConf *conf;

+ (instancetype)share;

@end

NS_ASSUME_NONNULL_END
