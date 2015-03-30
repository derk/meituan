//
//  HMSortsViewController.h
//  美团
//
//  Created by apple on 14-12-04.
//  Copyright (c) 2014年 Simple. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HMSort;

@interface HMSortsViewController : UIViewController
/** 当前选中的排序 */
@property (strong, nonatomic) HMSort *selectedSort;
@end
