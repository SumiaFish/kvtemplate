//
//  CTMediator+Detail.h
//  kvtemplate
//
//  Created by kevin on 2020/6/14.
//  Copyright © 2020 kevin. All rights reserved.
//

#import <CTMediator/CTMediator.h>

NS_ASSUME_NONNULL_BEGIN

@interface CTMediator (Detail)

- (UIViewController *)detailController;

@end

@interface Target_Detail : NSObject

- (UIViewController *)Action_DetailController:(id)params;

@end

NS_ASSUME_NONNULL_END
