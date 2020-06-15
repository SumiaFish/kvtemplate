//
//  KVCollectionView.h
//  kvtemplate
//
//  Created by kevin on 2020/6/15.
//  Copyright © 2020 kevin. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "KVCollectionViewProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface KVCollectionView : UICollectionView
<KVCollectionViewProtocol>

@end

NS_ASSUME_NONNULL_END
