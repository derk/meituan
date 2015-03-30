//
//  HMRegion.h
//  美团
//
//  Created by apple on 14-12-10.
//  Copyright (c) 2014年 Simple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HMDropdownMenu.h"

@interface HMRegion : NSObject <HMDropdownMenuItem>
/** 区域名称 */
@property (copy, nonatomic) NSString *name;
/** 子区域 */
@property (strong, nonatomic) NSArray *subregions;
@end
