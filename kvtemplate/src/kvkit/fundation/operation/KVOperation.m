//
//  KVOperation.m
//  kvtemplate
//
//  Created by kevin on 2020/5/14.
//  Copyright © 2020 kevin. All rights reserved.
//

#import "KVOperation.h"

@interface KVOperation ()

@property (assign, nonatomic) BOOL kv_isExecuting;
@property (assign, nonatomic) BOOL kv_isFinished;

@end

@implementation KVOperation
{
    NSCondition *_cond;
}

- (void)dealloc {
    _isPause = NO;
#if DEBUG
    NSLog(@"%@ dealloc~", NSStringFromClass(self.class));
#endif
}

- (instancetype)init {
    if (self = [super init]) {
        _taskId = NSUUID.UUID.UUIDString;
        _taskSemaphore = dispatch_semaphore_create(1);
        _pauseSemaphore = dispatch_semaphore_create(1);
        _completeSemaphore = dispatch_semaphore_create(1);
//        _cond = [[NSCondition alloc] init];
    }
    return self;
}

- (BOOL)isAsynchronous {
    return NO;
}

- (void)start {
    dispatch_semaphore_wait(_taskSemaphore, DISPATCH_TIME_FOREVER);
    if (self.isCancelled ||
        self.isFinished) {
        dispatch_semaphore_signal(_taskSemaphore);
        return;
    }
    if (self.isExecuting) {
        dispatch_semaphore_signal(_taskSemaphore);
        return;
    }
    
    self.kv_isExecuting = YES;
    [self todo];
    while (_kv_isFinished == NO || _isPause == YES) {
        NSTimeInterval val = 0.05;
        dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(NSEC_PER_SEC * val));
        dispatch_semaphore_wait(_taskSemaphore, time);
        sleep(val);
    }
    [self complete];
    self.kv_isExecuting = NO;
    dispatch_semaphore_signal(_taskSemaphore);
}

- (void)complete {
    dispatch_semaphore_wait(_completeSemaphore, DISPATCH_TIME_FOREVER);
    if (!self.kv_isFinished) {
        self.kv_isFinished = YES;
    }
    dispatch_semaphore_signal(_completeSemaphore);
}

- (void)cancel {
    dispatch_semaphore_wait(_completeSemaphore, DISPATCH_TIME_FOREVER);
    if (!self.kv_isFinished) {
        [super cancel];
        [self onCancel];
        self.kv_isFinished = YES;
    }
    dispatch_semaphore_signal(_completeSemaphore);
}

- (void)todo {
    
}

- (void)pause {
    dispatch_semaphore_wait(_pauseSemaphore, DISPATCH_TIME_FOREVER);
    if (_isPause) {
        dispatch_semaphore_signal(_pauseSemaphore);
        return;
    }
    _isPause = YES;
    if (self.isCancelled ||
        self.isFinished) {
        dispatch_semaphore_signal(_pauseSemaphore);
        return;
    }
    [self onPause];
    dispatch_semaphore_signal(_pauseSemaphore);
}

- (void)onPause {
    
}

- (void)resume {
    dispatch_semaphore_wait(_pauseSemaphore, DISPATCH_TIME_FOREVER);
    if (!_isPause) {
        dispatch_semaphore_signal(_pauseSemaphore);
        return;
    }
    _isPause = NO;
    if (self.isCancelled ||
        self.isFinished) {
        dispatch_semaphore_signal(_pauseSemaphore);
        return;
    }
    [self onResume];
    dispatch_semaphore_signal(_pauseSemaphore);
}

- (void)onResume {
    
}

- (void)onCancel {
    
}

- (void)setKv_isExecuting:(BOOL)kv_isExecuting {
    [self willChangeValueForKey:NSStringFromSelector(@selector(isExecuting))];
    _kv_isExecuting = kv_isExecuting;
    [self didChangeValueForKey:NSStringFromSelector(@selector(isExecuting))];
}

- (BOOL)isExecuting {
    return _kv_isExecuting;
}

- (void)setKv_isFinished:(BOOL)kv_isFinished {
    [self willChangeValueForKey:NSStringFromSelector(@selector(isFinished))];
    _kv_isFinished = kv_isFinished;
    [self didChangeValueForKey:NSStringFromSelector(@selector(isFinished))];
}

- (BOOL)isFinished {
    return _kv_isFinished;
}


@end

