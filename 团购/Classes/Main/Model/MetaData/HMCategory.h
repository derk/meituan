//
//  HMCategory.h
//  美团
//
//  Created by apple on 14-12-09.
//  Copyright (c) 2014年 Simple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HMDropdownMenu.h"

@interface HMCategory : NSObject <HMDropdownMenuItem>
/** 类别名称 */
@property (copy, nonatomic) NSString *name;
/** 大图标 */
@property (copy, nonatomic) NSString *icon;
/** 大图标(高亮) */
@property (copy, nonatomic) NSString *highlighted_icon;
/** 小图标 */
@property (copy, nonatomic) NSString *small_icon;
/** 小图标(高亮) */
@property (copy, nonatomic) NSString *small_highlighted_icon;
/** 子类别 */
@property (strong, nonatomic) NSArray *subcategories;

/** 这种类别显示在地图上的大头针图标 */
@property (nonatomic, copy) NSString *map_icon;
@end
