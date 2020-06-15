//
//  KVEmptyDataView.h
//  kvtemplate
//
//  Created by kevin on 2020/6/15.
//  Copyright © 2020 kevin. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "KVEmptyDataViewProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface KVEmptyDataView : UIView
<KVEmptyDataViewProtocol>

@property (strong, nonatomic, nullable) KVEmptyDataInfo *emptyDataInfo;

#pragma mark - 子类重写

- (void)onSetupView;

@end

NS_ASSUME_NONNULL_END
