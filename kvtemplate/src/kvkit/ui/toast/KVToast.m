//
//  KVToast.m
//  KVTableView
//
//  Created by kevin on 2020/5/12.
//  Copyright © 2020 kevin. All rights reserved.
//

#import "KVToast.h"

#import <Toast/UIView+Toast.h>

#import "AppDelegate.h"

@interface KVToast ()

@property (strong, nonatomic) CSToastStyle *defaultStyle;
@property (strong, nonatomic) UIView *currentToast;

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
            _defaultStyle = ({
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
        }
    }
    
    return instance;
}

- (void)kv_show:(NSString *)text {
    if (!text.length) {
        return;
    }
    
    void (^ todo) (void) = ^{
        UIWindow *window = ((AppDelegate *)UIApplication.sharedApplication.delegate).window;
        [window hideToast];
        [window hideToastActivity];
        [window hideToast:self.currentToast];
        
        self.currentToast = [window toastViewForMessage:text title:nil image:nil style:self.defaultStyle];
        [window showToast:self.currentToast duration:3 position:[NSValue valueWithCGPoint:CGPointMake(UIScreen.mainScreen.bounds.size.width / 2.f, UIScreen.mainScreen.bounds.size.height - 49 - 20)] completion:nil];
    };
    
    if (strcmp(dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL), dispatch_queue_get_label(dispatch_get_main_queue())) == 0) {
        todo();
    } else {
        dispatch_async(dispatch_get_main_queue(), todo);
    }
}

@end
