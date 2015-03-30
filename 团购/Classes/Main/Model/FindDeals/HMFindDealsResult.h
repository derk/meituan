//
//  HMFindDealsResult.h
//  美团
//
//  Created by apple on 14-12-08.
//  Copyright (c) 2014年 Simple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HMGetSingleDealResult.h"

@interface HMFindDealsResult : HMGetSingleDealResult
/** 所有页面团购总数 */
@property (assign, nonatomic) int total_count;
@end
