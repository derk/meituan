//
//  HMDealCell.h
//  美团
//
//  Created by apple on 14-11-27.
//  Copyright (c) 2014年 Simple. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HMDeal, HMDealCell;

@protocol HMDealCellDelegate <NSObject>

@optional
- (void)dealCellDidClickCover:(HMDealCell *)dealCell;

@end

@interface HMDealCell : UICollectionViewCell
@property (nonatomic, strong) HMDeal *deal;

@property (nonatomic, weak) id<HMDealCellDelegate> delegate;
@end
