//
//  UIView+Context.m
//  kvtemplate
//
//  Created by kevin on 2020/5/27.
//  Copyright © 2020 kevin. All rights reserved.
//

#import "UIView+Context.h"

static NSString * const UIViewContextKey = @"UIViewContextKey";

static NSString * const UIViewDisplayContextKey = @"UIViewDisplayContextKey";

@implementation UIView (Context)

- (void)setContext:(id)context {
    [self.weakPropsMap setObject:context forKey:UIViewContextKey];
}

- (id)context {
    return [self.weakPropsMap objectForKey:UIViewContextKey];
}

@end

@implementation UIView (DisplayContext)

- (void)setDisplayContext:(id<KVUIViewDisplayDelegate>)displayContext {
    [self.weakPropsMap setObject:displayContext forKey:UIViewDisplayContextKey];
}

- (id<KVUIViewDisplayDelegate>)displayContext {
    return [self.weakPropsMap objectForKey:UIViewDisplayContextKey];
}

- (void)display:(BOOL)isDisplay {
    [self display:isDisplay animate:NO];
}

- (void)display:(BOOL)isDisplay animate:(BOOL)animate {
    if (self.isDisplay == isDisplay) {
        return;
    }
    if ([self.displayContext respondsToSelector:@selector(onView:display:animate:)]) {
        [self.displayContext onView:self display:isDisplay animate:animate];
    } else {
        self.alpha = isDisplay ? 1 : 0;
    }
}

- (BOOL)isDisplay {
    return self.alpha == 1;
}

@end
