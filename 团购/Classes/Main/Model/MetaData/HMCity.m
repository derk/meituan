//
//  HMCity.m
//  美团
//
//  Created by apple on 14-12-10.
//  Copyright (c) 2014年 Simple. All rights reserved.
//

#import "HMCity.h"
#import "HMRegion.h"

@implementation HMCity
- (NSDictionary *)objectClassInArray
{
    return @{@"regions" : [HMRegion class]};
}
@end
