//
//  KVOperation.h
//  kvtemplate
//
//  Created by kevin on 2020/5/14.
//  Copyright © 2020 kevin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, KVOperationState) {
    KVOperationState_Ready,
    KVOperationState_Running,
    KVOperationState_Pause,
    KVOperationState_Cancel,
    KVOperationState_Finish,
};

@interface KVOperation : NSOperation
{
    @private dispatch_semaphore_t _taskSemaphore;
    @private dispatch_semaphore_t _pauseSemaphore;
    @private dispatch_semaphore_t _completeSemaphore;
}

@property (copy, nonatomic, readonly) NSString *taskId;

@property (assign, readonly) KVOperationState state;

#pragma mark - 外部调用

- (void)pause; // 暂停
- (void)resume;

#pragma mark - 子类调用

- (void)todo; // 子类重写
- (void)onCancel; // 子类重写
- (void)onPause; // 子类重写
- (void)onResume; // 子类重写
- (void)complete; // 子类完成后调用

@end

NS_ASSUME_NONNULL_END
