//
//  KVToastViewProtocol.h
//  KVTableView
//
//  Created by kevin on 2020/5/12.
//  Copyright © 2020 kevin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol KVToastViewProtocol <NSObject>

- (void)show:(NSString *)text;

- (void)show:(NSString *)text duration:(NSTimeInterval)duration;

- (void)hide;

@end

NS_ASSUME_NONNULL_END
