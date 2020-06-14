//
//  KVToast.m
//  KVTableView
//
//  Created by kevin on 2020/5/12.
//  Copyright © 2020 kevin. All rights reserved.
//

#import "KVToast.h"

@interface KVToast ()

@property (strong, nonatomic) UIView *currentToast;

@end

@implementation KVToastConf

- (NSValue *)positionValue {
    return [NSValue valueWithCGPoint:self.screenPoint];
}

@end

@implementation KVToast

static KVToast *instance = nil;
static BOOL KVToastInitFlag = NO;

+ (instancetype)share {
    static dispatch_once_t token;
    _dispatch_once(&token, ^{
        KVToastInitFlag = YES;
        instance = [[KVToast alloc] init];
        KVToastInitFlag = NO;
    });
    return instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t token;
    _dispatch_once(&token, ^{
        instance = [super allocWithZone:zone];
    });
    return instance;
}

- (instancetype)init {
    if (KVToastInitFlag) {
        if (self = [super init]) {
            
        }
    }
    
    return instance;
}

- (void)show:(NSString *)text {
    if (!text.length) {
        return;
    }
    
    void (^ todo) (void) = ^{
        UIWindow *window = self.window;
        [window hideToast];
        [window hideToastActivity];
        [window hideToast:self.currentToast];
        
        self.currentToast = [window toastViewForMessage:text title:nil image:nil style:self.conf.style];
        [window showToast:self.currentToast duration:self.conf.deuration position:self.conf.positionValue completion:self.conf.onComplete];
    };
    
    if (strcmp(dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL), dispatch_queue_get_label(dispatch_get_main_queue())) == 0) {
        todo();
    } else {
        dispatch_async(dispatch_get_main_queue(), todo);
    }
}

- (void)hide {
    UIWindow *window = self.window;
    [window hideToast];
    [window hideToastActivity];
    [window hideToast:self.currentToast];
}

- (KVToastConf *)conf {
    if (!_conf) {
        _conf = [[KVToastConf alloc] init];
        _conf.style = ({
            [CSToastManager setTapToDismissEnabled:YES];
            [CSToastManager setQueueEnabled:YES];
            CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle];
            style.messageFont = [UIFont boldSystemFontOfSize:15];
            style.messageColor = [UIColor whiteColor];
            style.messageAlignment = NSTextAlignmentCenter;
            style.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.5];
            //    style.backgroundColor = JLNavBarTinColor;
            //    style.cornerRadius = 2.f;
            style.fadeDuration = 1.0;
            //    style.displayShadow = YES;
            style;
        });
        _conf.deuration = 3;
        _conf.screenPoint = CGPointMake(UIScreen.mainScreen.bounds.size.width / 2.f, UIScreen.mainScreen.bounds.size.height - 49 - 20);
        _conf.onComplete = nil;
    }
    return _conf;
}

- (UIWindow *)window {
    NSArray<UIWindow *> *windows = UIApplication.sharedApplication.windows;
    for (UIWindow *window in windows) {
        if (window.hidden == NO) {
            return window;
        }
    }
    return nil;
}

@end
