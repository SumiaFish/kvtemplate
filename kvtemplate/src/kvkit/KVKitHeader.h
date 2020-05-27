//
//  KVKitHeader.h
//  kvtemplate
//
//  Created by kevin on 2020/5/22.
//  Copyright © 2020 kevin. All rights reserved.
//

#define KVKitHeader_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#ifdef DEBUG
#ifndef KVKitLog
#define KVKitLog(format,...) { \
printf("\n%s #%d: \n", __func__, __LINE__); \
printf("%s\n", [NSString stringWithFormat:(format), ##__VA_ARGS__].UTF8String); \
NSLog(@"\n\n"); \
}
#else
#define KVKitLog(...)
#endif

#endif /* KVKitHeader_h */
