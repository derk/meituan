//
//  HMRegionsViewController.h
//  美团
//
//  Created by apple on 14-12-03.
//  Copyright (c) 2014年 Simple. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HMRegion;

@interface HMRegionsViewController : UIViewController
@property (nonatomic, strong) NSArray *regions;
/** 当前选中的区域 */
@property (strong, nonatomic) HMRegion *selectedRegion;
/** 当前选中的子区域名称 */
@property (copy, nonatomic) NSString *selectedSubRegionName;
@end
