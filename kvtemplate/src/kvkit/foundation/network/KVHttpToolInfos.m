//
//  KVHttpToolInfos.m
//  kvtemplate
//
//  Created by kevin on 2020/5/14.
//  Copyright © 2020 kevin. All rights reserved.
//

#import "KVHttpToolInfos.h"

@implementation KVHttpToolInfos

- (nonnull id)copyWithZone:(nullable NSZone *)zone {
    KVHttpToolInfos *info = [self.class allocWithZone:zone];
    
    unsigned int count = 0;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    for (int i = 0; i < count; i++) {
        const char *name = property_getName(properties[i]);
        NSString *propertyName = [NSString stringWithUTF8String:name];
        id propertyValue = [self valueForKey:propertyName];
        if (propertyValue) {
            if ([propertyValue isKindOfClass:NSObject.class] &&
                [propertyValue conformsToProtocol:@protocol(NSCopying)]) {
                NSObject<NSCopying> *value = propertyValue;
                [info setValue:[value copy] forKey:propertyName];
            } else {
                [info setValue:propertyValue forKey:propertyName];
            }
        }
    }
    free(properties);
    
    return info;
}

@end
