//
//  HMSearchViewController.h
//  团购
//
//  Created by apple on 14-11-27.
//  Copyright (c) 2014年 Simple. All rights reserved.
//

#import "HMDealListViewController.h"
@class HMCity;

@interface HMSearchViewController : HMDealListViewController
/** 选中的状态 */
@property (nonatomic, strong) HMCity *selectedCity;
@end
