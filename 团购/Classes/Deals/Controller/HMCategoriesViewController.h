//
//  HMCategoriesViewController.h
//  美团
//
//  Created by apple on 14-12-02.
//  Copyright (c) 2014年 Simple. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HMCategory;

@interface HMCategoriesViewController : UIViewController
/** 当前选中的分类 */
@property (strong, nonatomic) HMCategory *selectedCategory;
/** 当前选中的子分类名称 */
@property (copy, nonatomic) NSString *selectedSubCategoryName;
@end
