//
//  KVStorege.h
//  KVTableView
//
//  Created by kevin on 2020/5/13.
//  Copyright © 2020 kevin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KVStorege : NSObject

@property (copy, nonatomic, readonly) NSString *name;
@property (strong, nonatomic, readonly) NSFileManager *fileManager;

+ (void)registStorege:(NSString *)directoryPath;

@end

NS_ASSUME_NONNULL_END
