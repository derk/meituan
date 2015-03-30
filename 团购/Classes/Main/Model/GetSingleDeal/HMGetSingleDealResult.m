//
//  HMGetSingleDealResult.m
//  美团
//
//  Created by apple on 14-12-09.
//  Copyright (c) 2014年 Simple. All rights reserved.
//

#import "HMGetSingleDealResult.h"
#import "HMDeal.h"

@implementation HMGetSingleDealResult

- (NSDictionary *)objectClassInArray
{
    return @{@"deals" : [HMDeal class]};
}
@end
