//
//  HMDealAnnotation.m
//  团购
//
//  Created by apple on 14-11-27.
//  Copyright (c) 2014年 Simple. All rights reserved.
//

#import "HMDealAnnotation.h"

@implementation HMDealAnnotation
- (BOOL)isEqual:(HMDealAnnotation *)other
{
    return self.coordinate.latitude == other.coordinate.latitude && self.coordinate.longitude == other.coordinate.longitude;
}
@end
