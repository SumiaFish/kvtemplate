//
//  CTMediator+Detail.m
//  kvtemplate
//
//  Created by kevin on 2020/6/14.
//  Copyright © 2020 kevin. All rights reserved.
//

#import "CTMediator+Detail.h"

#import "DetailViewController.h"

@implementation CTMediator (Detail)

- (UIViewController *)detailController {
    return [self performTarget:@"Detail" action:@"DetailController" params:nil shouldCacheTarget:NO];
}

@end

@implementation Target_Detail

- (UIViewController *)Action_DetailController:(id)params {
    return [[DetailViewController alloc] init];
}

@end
