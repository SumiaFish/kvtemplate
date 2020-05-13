//
//  AppNetworking.m
//  KVTableView
//
//  Created by kevin on 2020/5/13.
//  Copyright © 2020 kevin. All rights reserved.
//

#import "AppNetworking.h"

@implementation NSError (AppNetwork)

@end

@implementation AppNetworking

+ (NSError *)getBusinessErrorWithUrl:(NSString *)url responseObject:(id)responseObject {
    
    return nil;
    
//    NSInteger code = [responseObject[@"code"] integerValue];
//    if (code == 200) {
//        return nil;
//    }
//
//    NSString *msg = responseObject[@"msg"]? responseObject[@"msg"]: @"";
//    NSError *error = [NSError errorWithDomain:url code:code userInfo:@{NSLocalizedDescriptionKey: msg}];
//    return error;
    
}

@end
