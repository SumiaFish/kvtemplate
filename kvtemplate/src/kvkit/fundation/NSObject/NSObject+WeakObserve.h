//
//  NSObject+WeakObserve.h
//  KVWeakObserve
//
//  Created by kevin on 2020/5/11.
//  Copyright © 2020 kevin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (WeakObserve)

// isCallBackInMain: NO
- (void)kv_addWeakObserve:(NSObject *)object keyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:( void * _Nullable )context;

- (void)kv_addWeakObserve:(NSObject *)object keyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:( void * _Nullable )context isCallBackInMain:(BOOL)isCallBackInMain;

- (void)kv_receiveWeakObserveValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:( void * _Nullable )context;

- (void)kv_removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath;

@end

NS_ASSUME_NONNULL_END
