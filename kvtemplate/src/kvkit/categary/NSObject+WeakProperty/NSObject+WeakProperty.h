//
//  NSObject+WeakProperty.h
//  kvtemplate
//
//  Created by kevin on 2020/6/14.
//  Copyright © 2020 kevin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (WeakProperty)

//@property (strong, nonatomic) NSMapTable<NSString *, id> *weakPropsMap;

- (NSMapTable<NSString *,id> * _Nonnull)weakPropsMap;

@end

NS_ASSUME_NONNULL_END
